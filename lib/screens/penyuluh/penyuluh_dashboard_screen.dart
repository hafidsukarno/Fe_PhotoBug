import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fe_photobug/screens/penyuluh/laporan_penyuluh_view.dart';
import 'package:fe_photobug/screens/penyuluh/notifikasi_penyuluh_view.dart';
import 'package:fe_photobug/screens/penyuluh/artikel_penyuluh_view.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';
import 'package:fe_photobug/services/penyuluh_service.dart';
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/utils/dialog_utils.dart';
import 'package:fe_photobug/services/admin_service.dart';

class PenyuluhDashboardScreen extends StatefulWidget {
  const PenyuluhDashboardScreen({super.key});

  @override
  State<PenyuluhDashboardScreen> createState() => _PenyuluhDashboardScreenState();
}

class _PenyuluhDashboardScreenState extends State<PenyuluhDashboardScreen> {
  int _currentIndex = 0;
  int _laporanInitialTab = 0;
  GlobalKey<LaporanPenyuluhViewState> _laporanKey = GlobalKey<LaporanPenyuluhViewState>();
  final GlobalKey<ArtikelPenyuluhViewState> _artikelKey = GlobalKey<ArtikelPenyuluhViewState>();
  bool _isLoadingStatus = true;
  bool _isLoadingTrend = true;
  String _villageName = 'Memuat...';
  late PenyuluhReportStatusResponse _reportStatus;
  late PestTrendResponse _pestTrend;

  DateTime? _selectedStartMonth;
  DateTime? _selectedEndMonth;
  List<VillageReportItem> _villagesList = [];

  List<DateTime> _generateMonthsList() {
    final list = <DateTime>[];
    final now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      list.add(DateTime(now.year, now.month - i, 1));
    }
    return list;
  }

  String _formatMonthName(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return "${months[dt.month - 1]} ${dt.year}";
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedStartMonth = DateTime(now.year, now.month, 1);
    _selectedEndMonth = DateTime(now.year, now.month, 1);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingStatus = true;
      _isLoadingTrend = true;
    });

    String? startStr;
    String? endStr;

    if (_selectedStartMonth != null) {
      startStr = "${_selectedStartMonth!.year}-${_selectedStartMonth!.month.toString().padLeft(2, '0')}-01";
    }
    if (_selectedEndMonth != null) {
      final lastDay = DateTime(_selectedEndMonth!.year, _selectedEndMonth!.month + 1, 0).day;
      endStr = "${_selectedEndMonth!.year}-${_selectedEndMonth!.month.toString().padLeft(2, '0')}-$lastDay";
    }

    final status = await PenyuluhService.getReportStatus(dateFrom: startStr, dateTo: endStr);
    final trend = await PenyuluhService.getPestTrend(dateFrom: startStr, dateTo: endStr);
    final villagesData = await PenyuluhService.getVillages(dateFrom: startStr, dateTo: endStr);
    
    String villageText = 'Desa Tidak Diketahui';
    if (villagesData.success && villagesData.data.isNotEmpty) {
      villageText = 'Desa ${villagesData.data.map((e) => e.villageName).join(", ")}';
    }

    if (mounted) {
      setState(() {
        _reportStatus = status;
        _pestTrend = trend;
        _villageName = villageText;
        _villagesList = villagesData.data;
        _isLoadingStatus = false;
        _isLoadingTrend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaView(topPadding),
          LaporanPenyuluhView(
            key: _laporanKey, 
            topPadding: topPadding, 
            initialTabIndex: _laporanInitialTab,
            selectedStartMonth: _selectedStartMonth,
            selectedEndMonth: _selectedEndMonth,
          ),
          ArtikelPenyuluhView(key: _artikelKey, topPadding: topPadding),
          NotifikasiPenyuluhView(topPadding: topPadding),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBerandaView(double topPadding) {
    return Column(
      children: [
        _buildHeader(topPadding),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodFilterCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Status Laporan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A148C),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  if (!_isLoadingStatus && _villagesList.isNotEmpty) ...[
                    const Text(
                      'Cakupan Desa Binaan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A148C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: _villagesList.map((desa) {
                          final colors = [
                            const Color(0xFF7B1FA2),
                            const Color(0xFF9C27B0),
                            const Color(0xFFAB47BC),
                            const Color(0xFFCE93D8),
                          ];
                          final index = _villagesList.indexOf(desa);
                          return Padding(
                            padding: EdgeInsets.only(bottom: index == _villagesList.length - 1 ? 0 : 18),
                            child: _DesaItem(
                              nama: desa.villageName,
                              jumlahLaporan: desa.totalReports,
                              totalHama: desa.totalPestsDetected,
                              progress: (desa.totalReports > 0 ? (desa.totalReports / 20).clamp(0.0, 1.0) : 0.0).toDouble(),
                              color: colors[index % colors.length],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildChartCard(),
                  const SizedBox(height: 24),
                  if (!_isLoadingStatus && _reportStatus.success && _reportStatus.waitingVerification > 0) ...[
                    const Text(
                      'Tindakan Mendesak',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A148C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(),
                    const SizedBox(height: 28),
                  ],

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(double topPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A148C),
            Color(0xFF7B1FA2),
            Color(0xFF9C27B0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x444A148C),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -10,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 60,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Logo, Notifications & Profile Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Penyuluh System',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Text(
                            'Photobug',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Profile Dropdown
                      PopupMenuButton<int>(
                        position: PopupMenuPosition.under,
                        offset: const Offset(0, 12),
                        elevation: 16,
                        shadowColor: const Color(0xFF7B1FA2).withValues(alpha: 0.16),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            enabled: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (AuthService.userName?.isNotEmpty ?? false)
                                          ? AuthService.userName![0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AuthService.userName ?? 'Pengguna',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1A2E),
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red.shade700,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Keluar Akun',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            DialogUtils.showLogoutConfirmation(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Penyuluh Pertanian • $_villageName Aktif',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Greeting
              Text(
                'Halo, ${AuthService.userName ?? 'Penyuluh'} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pantau laporan hama dan bantu petani mengendalikan tanaman hari ini.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    if (_isLoadingStatus) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        )
      );
    }

    if (!_reportStatus.success) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Gagal memuat data: ${_reportStatus.message}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.assignment_rounded, // Same as petani
            iconColor: const Color(0xFF7B1FA2),
            iconBg: const Color(0xFFF3E5F5),
            value: '${_reportStatus.totalIncoming}',
            label: 'Laporan\nMasuk',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.hourglass_top_rounded, // Same as petani
            iconColor: const Color(0xFFF57C00),
            iconBg: const Color(0xFFFFF3E0),
            value: '${_reportStatus.waitingVerification}',
            label: 'Menunggu',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.check_circle_rounded, // Same as petani
            iconColor: const Color(0xFF2E7D32),
            iconBg: const Color(0xFFE8F5E9),
            value: '${_reportStatus.completed}',
            label: 'Selesai',
          ),
        ),
      ],
    );
  }

  Widget _buildSingleStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    if (_isLoadingTrend) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ));
    }

    if (!_pestTrend.success) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Gagal memuat tren: ${_pestTrend.message}', style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    int hijauTotal = 0;
    int coklatTotal = 0;
    
    for (var trend in _pestTrend.data) {
      if (trend.pestName.toLowerCase().contains('hijau')) {
        hijauTotal = trend.totalDetected;
      } else if (trend.pestName.toLowerCase().contains('coklat')) {
        coklatTotal = trend.totalDetected;
      }
    }

    int total = hijauTotal + coklatTotal;
    double hijauPercent = total == 0 ? 0 : (hijauTotal / total) * 100;
    double coklatPercent = total == 0 ? 0 : (coklatTotal / total) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Jenis Hama',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    startDegreeOffset: -90,
                    sections: total == 0 
                      ? [
                          PieChartSectionData(
                            value: 1,
                            color: Colors.grey.shade200,
                            title: '',
                            radius: 25,
                          )
                        ]
                      : [
                          PieChartSectionData(
                            value: coklatTotal.toDouble(),
                            color: const Color(0xFF1B5E20),
                            title: '',
                            radius: 25,
                          ),
                          PieChartSectionData(
                            value: hijauTotal.toDouble(),
                            color: const Color(0xFF00BFA5),
                            title: '',
                            radius: 25,
                          ),
                        ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendPercent(const Color(0xFF1B5E20), 'Wereng Coklat', '$coklatTotal Hama'),
                    const SizedBox(height: 16),
                    _buildLegendPercent(const Color(0xFF00BFA5), 'Wereng Hijau', '$hijauTotal Hama'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendPercent(Color color, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard() {
    final count = _reportStatus.waitingVerification;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 1; // Index tab Laporan
          _laporanInitialTab = 1; // Tab Menunggu
          _laporanKey = GlobalKey<LaporanPenyuluhViewState>();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFECDCA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD92D20),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$count Laporan Menunggu Balasan!',
                        style: const TextStyle(
                          color: Color(0xFFB42318),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Lihat →',
                        style: TextStyle(
                          color: const Color(0xFFD92D20),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Petani memerlukan rekomendasi segera untuk mengatasi hama',
                    style: TextStyle(
                      color: Color(0xFFD92D20),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Beranda', 0),
              _buildNavItem(Icons.description_outlined, 'Laporan', 1),
              _buildNavItem(Icons.article_rounded, 'Artikel', 2),
              _buildNavItem(Icons.notifications_outlined, 'Notifikasi', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          _loadData();
        } else if (index == 1) {
          _laporanKey.currentState?.silentRefresh();
        } else if (index == 2) {
          _artikelKey.currentState?.silentRefresh();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF7B1FA2)
                  : Colors.grey.shade400,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF7B1FA2)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodFilterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: Color(0xFF7B1FA2), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Periode Laporan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              if (_selectedStartMonth != null || _selectedEndMonth != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStartMonth = null;
                      _selectedEndMonth = null;
                    });
                    _loadData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh_rounded, color: Color(0xFF7B1FA2), size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7B1FA2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
                      hint: Text(
                        'Dari Bulan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _selectedStartMonth,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade700,
                        size: 18,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownColor: Colors.white,
                      items: _generateMonthsList().map((dt) {
                        return DropdownMenuItem<DateTime>(
                          value: dt,
                          child: Text(
                            _formatMonthName(dt),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStartMonth = val;
                          if (_selectedEndMonth != null && val != null && val.isAfter(_selectedEndMonth!)) {
                            _selectedEndMonth = val;
                          }
                        });
                        _loadData();
                      },
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.trending_flat_rounded,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
                      hint: Text(
                        'Sampai Bulan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _selectedEndMonth,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade700,
                        size: 18,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownColor: Colors.white,
                      items: _generateMonthsList().map((dt) {
                        return DropdownMenuItem<DateTime>(
                          value: dt,
                          child: Text(
                            _formatMonthName(dt),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedEndMonth = val;
                          if (_selectedStartMonth != null && val != null && val.isBefore(_selectedStartMonth!)) {
                            _selectedStartMonth = val;
                          }
                        });
                        _loadData();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesaItem extends StatelessWidget {
  final String nama;
  final int jumlahLaporan;
  final int totalHama;
  final double progress;
  final Color color;

  const _DesaItem({
    required this.nama,
    required this.jumlahLaporan,
    required this.totalHama,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();
    
    // Tentukan tingkat bahaya berdasarkan jumlah total hama yang diidentifikasi
    String status = 'Tidak Bahaya';
    Color statusColor = const Color(0xFF2E7D32); // Green
    IconData statusIcon = Icons.check_circle_outline_rounded;

    if (totalHama >= 15) {
      status = 'Sangat Bahaya';
      statusColor = const Color(0xFFC62828); // Red
      statusIcon = Icons.gpp_bad_rounded;
    } else if (totalHama >= 5) {
      status = 'Bahaya';
      statusColor = const Color(0xFFE65100); // Orange
      statusIcon = Icons.warning_amber_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor.withValues(alpha: 0.25), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.description_outlined, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              '$jumlahLaporan Laporan',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 14),
            Icon(Icons.bug_report_outlined, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              '$totalHama Hama Terdeteksi',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
