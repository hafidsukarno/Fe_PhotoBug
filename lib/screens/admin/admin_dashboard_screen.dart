import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/admin/kelola_desa_admin_view.dart';
import 'package:fe_photobug/screens/admin/pengguna_admin_view.dart';
import 'package:fe_photobug/screens/admin/kelola_artikel_admin_view.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';
import 'package:fe_photobug/services/admin_service.dart';
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/utils/dialog_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  final GlobalKey<KelolaDesaAdminViewState> _kelolaDesaKey = GlobalKey<KelolaDesaAdminViewState>();
  final GlobalKey<PenggunaAdminViewState> _penggunaKey = GlobalKey<PenggunaAdminViewState>();
  final GlobalKey<KelolaArtikelAdminViewState> _kelolaArtikelKey = GlobalKey<KelolaArtikelAdminViewState>();
  bool _isLoading = true;
  AdminDashboardData? _dashboardStats;
  VillagesReportData? _villagesReport;
  PestStatisticsData? _pestStats;

  DateTime? _selectedStartMonth;
  DateTime? _selectedEndMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedStartMonth = DateTime(now.year, now.month, 1);
    _selectedEndMonth = DateTime(now.year, now.month, 1);
    _loadData();
  }

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

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
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

    final results = await Future.wait([
      AdminService.getDashboardStats(dateFrom: startStr, dateTo: endStr),
      AdminService.getVillagesReport(dateFrom: startStr, dateTo: endStr),
      AdminService.getPestStatistics(dateFrom: startStr, dateTo: endStr),
    ]);
    
    if (mounted) {
      setState(() {
        _dashboardStats = results[0] as AdminDashboardData?;
        _villagesReport = results[1] as VillagesReportData?;
        _pestStats = results[2] as PestStatisticsData?;
        _isLoading = false;
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
          _buildDasborView(topPadding),
          KelolaDesaAdminView(key: _kelolaDesaKey, topPadding: topPadding),
          PenggunaAdminView(key: _penggunaKey, topPadding: topPadding),
          KelolaArtikelAdminView(key: _kelolaArtikelKey, topPadding: topPadding),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // =========================================================
  // TAB 0 — DASBOR UTAMA
  // =========================================================
  Widget _buildDasborView(double topPadding) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2)));
    }
    
    return Column(
      children: [
        // ---- PURPLE GRADIENT HEADER ----
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A148C),
                Color(0xFF6A1B9A),
                Color(0xFF9C27B0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x444A148C),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
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
                  // Top: logo + notifikasi
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
                                'Admin System',
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
                      PopupMenuButton<int>(
                        position: PopupMenuPosition.under,
                        offset: const Offset(0, 12),
                        elevation: 16,
                        shadowColor: const Color(0xFF4A148C).withValues(alpha: 0.16),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
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
                                    child: const Text(
                                      'A',
                                      style: TextStyle(
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
                                        const Text(
                                          'Super Admin',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1A2E),
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          'admin@photobug.id',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
                   const SizedBox(height: 16),
 
                   // Status chip
                   Container(
                     padding: const EdgeInsets.symmetric(
                         horizontal: 14, vertical: 8),
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
                           'Semua sistem berjalan normal • Update 2 mnt lalu',
                           style: TextStyle(
                             fontSize: 11.5,
                             color: Colors.white.withValues(alpha: 0.9),
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 12),

                  // Month Filter Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            const Text(
                              'Periode Laporan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
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
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.refresh_rounded, color: Colors.white, size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        'Reset',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
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
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<DateTime>(
                                    hint: Text(
                                      'Dari Bulan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    value: _selectedStartMonth,
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    dropdownColor: const Color(0xFF6A1B9A),
                                    items: _generateMonthsList().map((dt) {
                                      return DropdownMenuItem<DateTime>(
                                        value: dt,
                                        child: Text(
                                          _formatMonthName(dt),
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedStartMonth = val;
                                        // Ensure start month is before or equal to end month
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
                                color: Colors.white70,
                                size: 16,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<DateTime>(
                                    hint: Text(
                                      'Sampai Bulan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    value: _selectedEndMonth,
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    dropdownColor: const Color(0xFF6A1B9A),
                                    items: _generateMonthsList().map((dt) {
                                      return DropdownMenuItem<DateTime>(
                                        value: dt,
                                        child: Text(
                                          _formatMonthName(dt),
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedEndMonth = val;
                                        // Ensure end month is after or equal to start month
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
                  ),
                   const SizedBox(height: 20),

                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.55,
                    children: [
                      _StatCard(
                        icon: Icons.description_rounded,
                        label: 'Total Laporan',
                        value: _dashboardStats?.totalReports.toString() ?? '0',
                        trend: '',
                        isPositive: true,
                      ),
                      _StatCard(
                        icon: Icons.people_alt_rounded,
                        label: 'Pengguna Aktif',
                        value: '${_dashboardStats?.activeUsers ?? 0}',
                        trend: '',
                        isPositive: true,
                      ),
                      _StatCard(
                        icon: Icons.schedule_rounded,
                        label: 'Pending Review',
                        value: _dashboardStats?.pendingReview.toString() ?? '0',
                        trend: '',
                        isPositive: false,
                      ),
                      _StatCard(
                        icon: Icons.check_circle_rounded,
                        label: 'Diselesaikan',
                        value: _dashboardStats?.completed.toString() ?? '0',
                        trend: '',
                        isPositive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // ---- SCROLLABLE BODY ----
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- DOWNLOAD REPORT BUTTON ----
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showDownloadFilterDialog();
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Laporan Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ---- CAKUPAN DESA BINAAN ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Cakupan Desa Binaan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
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
                    children: _villagesReport?.data.map((desa) {
                          final colors = [
                            const Color(0xFF7B1FA2),
                            const Color(0xFF9C27B0),
                            const Color(0xFFAB47BC),
                            const Color(0xFFCE93D8),
                          ];
                          final index = _villagesReport!.data.indexOf(desa);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _DesaItem(
                              nama: desa.villageName,
                              jumlahLaporan: desa.totalReports,
                              totalHama: desa.totalPestsDetected,
                              progress: (desa.totalReports > 0 ? (desa.totalReports / 20).clamp(0.0, 1.0) : 0.0).toDouble(),
                              color: colors[index % colors.length],
                            ),
                          );
                        }).toList() ??
                        [const Text('Tidak ada data desa binaan')],
                  ),
                ),
                const SizedBox(height: 24),

                // ---- DISTRIBUSI JENIS HAMA ----
                _buildDistribusiHamaChart(),
                const SizedBox(height: 24),


              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== CHART: DISTRIBUSI JENIS HAMA ====================
  Widget _buildDistribusiHamaChart() {
    final werengCoklat = _pestStats?.summary['wereng_coklat']?.toDouble() ?? 0.0;
    final werengHijau = _pestStats?.summary['wereng_hijau']?.toDouble() ?? 0.0;
    final total = werengCoklat + werengHijau;
    final coklatPct = total > 0 ? ((werengCoklat / total) * 100).toInt() : 0;
    final hijauPct = total > 0 ? ((werengHijau / total) * 100).toInt() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Jenis Hama',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: total == 0
                      ? const Center(child: Text('Belum ada data', style: TextStyle(fontSize: 12, color: Colors.grey)))
                      : PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 35,
                            sections: [
                              if (werengCoklat > 0)
                                PieChartSectionData(
                                  color: const Color(0xFF1B5E20),
                                  value: werengCoklat,
                                  title: '',
                                  radius: 18,
                                ),
                              if (werengHijau > 0)
                                PieChartSectionData(
                                  color: const Color(0xFF00BFA5),
                                  value: werengHijau,
                                  title: '',
                                  radius: 18,
                                ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 20),

              // Legend
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildPieLegendRow('Wereng Coklat', '${werengCoklat.toInt()}', const Color(0xFF1B5E20)),
                    const SizedBox(height: 12),
                    _buildPieLegendRow('Wereng Hijau', '${werengHijau.toInt()}', const Color(0xFF00BFA5)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPieLegendRow(String label, String pct, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        Text(
          pct,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  // ==================== FILTER DOWNLOAD EXCEL ====================
  void _showDownloadFilterDialog() {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Filter Laporan Excel', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1A1A2E))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dari Tanggal:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF4A148C))),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF7B1FA2),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF1A1A2E),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => startDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF7B1FA2)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Sampai Tanggal:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF4A148C))),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF7B1FA2),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF1A1A2E),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => endDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF7B1FA2)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final dateFrom = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
                    final dateTo = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
                    final url = Uri.parse('${AdminService.baseUrl}/api/admin/download-statistics-report?token=${AuthService.authToken}&date_from=$dateFrom&date_to=$dateTo');
                    try {
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka URL unduhan')));
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan saat mengunduh: $e')));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FA2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Download', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            );
          },
        );
      },
    );
  }





  // =========================================================
  // PLACEHOLDER untuk tab yang belum dibuat
  // =========================================================
  Widget _buildPlaceholderView(
      String label, IconData icon, double topPadding) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A148C),
                Color(0xFF7B1FA2),
              ],
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      size: 56, color: const Color(0xFF7B1FA2)),
                ),
                const SizedBox(height: 20),
                Text(
                  'Halaman $label',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sedang dalam pengembangan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION BAR
  // =========================================================
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
              _buildNavItem(Icons.home_rounded, 'Dasbor', 0),
              _buildNavItem(Icons.location_city_rounded, 'Kelola Desa', 1),
              _buildNavItem(Icons.people_alt_outlined, 'Pengguna', 2),
              _buildNavItem(Icons.article_rounded, 'Artikel', 3),
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
          if (index == 0) {
            _loadData();
          } else if (index == 1) {
            _kelolaDesaKey.currentState?.silentRefresh();
          } else if (index == 2) {
            _penggunaKey.currentState?.silentRefresh();
          } else if (index == 3) {
            _kelolaArtikelKey.currentState?.silentRefresh();
          }
        });
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
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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


}

// =========================================================
// WIDGETS TERPISAH
// =========================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF69F0AE).withValues(alpha: 0.2)
                      : const Color(0xFFFF5252).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 10,
                      color: isPositive
                          ? const Color(0xFF69F0AE)
                          : const Color(0xFFFF8A80),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? const Color(0xFF69F0AE)
                            : const Color(0xFFFF8A80),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w500,
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


