import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/petani/laporan_view.dart';
import 'package:fe_photobug/screens/petani/riwayat_laporan_view.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/services/report_service.dart';
import 'package:fe_photobug/services/admin_service.dart';
import 'package:fe_photobug/utils/dialog_utils.dart';

class PetaniDashboardScreen extends StatefulWidget {
  const PetaniDashboardScreen({super.key});

  @override
  State<PetaniDashboardScreen> createState() => _PetaniDashboardScreenState();
}

class _PetaniDashboardScreenState extends State<PetaniDashboardScreen> {
  int _currentIndex = 0;
  final GlobalKey<RiwayatLaporanViewState> _riwayatKey = GlobalKey<RiwayatLaporanViewState>();
  bool _isLoadingStatus = true;
  bool _isLoadingArticles = true;
  String _petaniVillage = 'Loading...';
  late ReportStatusResponse _reportStatus;
  List<ArticleItem> _articlesList = [];

  DateTime? _selectedStartMonth;
  DateTime? _selectedEndMonth;

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

  String _formatDateString(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) return dateStr;
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedStartMonth = DateTime(now.year, now.month, 1);
    _selectedEndMonth = DateTime(now.year, now.month, 1);
    _loadAll();
    _loadPetaniVillage();
  }

  Future<void> _loadPetaniVillage() async {
    final village = await AuthService.getPetaniVillage();
    setState(() {
      _petaniVillage = village;
    });
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoadingStatus = true;
      _isLoadingArticles = true;
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

    final status = await ReportService.getReportStatus(dateFrom: startStr, dateTo: endStr);
    final articles = await ReportService.getArticles();

    if (mounted) {
      setState(() {
        _reportStatus = status;
        _articlesList = articles;
        _isLoadingStatus = false;
        _isLoadingArticles = false;
      });
    }
  }

  Future<void> _loadReportStatus() async => _loadAll();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaView(topPadding),
          LaporanView(
            onReportSubmitted: (int targetTab) {
              setState(() {
                _currentIndex = targetTab;
              });
              _loadReportStatus(); // Refresh dashboard stats
              _riwayatKey.currentState?.silentRefresh(); // Refresh riwayat
            },
          ),
          RiwayatLaporanView(
            key: _riwayatKey,
            selectedStartMonth: _selectedStartMonth,
            selectedEndMonth: _selectedEndMonth,
          ),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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

                // Stats Grid
                _buildStatsGrid(),
                const SizedBox(height: 28),

                _buildArticlesSection(),
                const SizedBox(height: 28),
                const Text(
                  'Layanan Pelaporan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4A148C),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Lapor Button
                _buildReportButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

  // ========== PREMIUM PURPLE HEADER ==========
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
            Color(0xFF6A1B9A),
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
              // Top Row: Logo & Profile Dropdown
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
                            'Petani System',
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

                  // Profile Dropdown
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
                      'Desa $_petaniVillage • Lahan Terpantau Aman',
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
                'Halo, ${AuthService.userName} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pantau hama wereng dan kirim laporan sawah Anda hari ini.',
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

  // ========== STATS ==========
  Widget _buildStatsGrid() {
    if (_isLoadingStatus) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: SizedBox(
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (!_reportStatus.success) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Gagal memuat data: ${_reportStatus.message}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.assignment_rounded,
              label: 'Laporan',
              value: '${_reportStatus.totalSent}',
              color: const Color(0xFF7B1FA2),
            ),
          ),
          Container(width: 1, height: 50, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle_rounded,
              label: 'Diverifikasi',
              value: '${_reportStatus.verified}',
              color: const Color(0xFF1565C0),
            ),
          ),
          Container(width: 1, height: 50, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatCard(
              icon: Icons.hourglass_top_rounded,
              label: 'Pending',
              value: '${_reportStatus.waitingVerification}',
              color: const Color(0xFFEF6C00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ========== NEWS CARD WITH IMAGE ==========
  Widget _buildNewsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/gambartest.png',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF8D6E63).withValues(alpha: 0.2),
                            const Color(0xFF8D6E63).withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.bug_report_rounded,
                            size: 60, color: Color(0xFF8D6E63)),
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Title on image
                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hama Wereng Coklat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Nilaparvata lugens',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'WASPADA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wereng coklat menyerang tanaman padi dengan menghisap cairan batang, menyebabkan hopperburn. Populasi meningkat di musim hujan dengan kelembaban tinggi.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Info Grid
                Row(
                  children: [
                    Expanded(
                        child:
                            _buildInfoTile('Gejala', 'Daun menguning, layu')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildInfoTile(
                            'Puncak Serangan', 'Musim hujan')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: _buildInfoTile(
                            'Ambang Ekonomi', '10 ekor/rumpun')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildInfoTile(
                            'Musuh Alami', 'Laba-laba, kumbang')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A148C),
            ),
          ),
        ],
      ),
    );
  }

  // ========== SIMPLE NEWS CARD ==========
  Widget _buildSimpleNewsCard({
    required String title,
    required String description,
    required IconData icon,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF7B1FA2), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A148C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFBDBDBD),
            size: 22,
          ),
        ],
      ),
    );
  }

  // ========== REPORT BUTTON ==========
  Widget _buildReportButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B1FA2).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laporkan Hama Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ambil foto & kirim laporan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== BOTTOM NAV (SIMPLE) ==========
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
              _buildNavItem(Icons.history_rounded, 'Riwayat', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
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

  // ========== PERIODE FILTER CARD ==========
  Widget _buildPeriodFilterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1),
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
                    _loadAll();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(10),
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
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
                      hint: Text('Dari Bulan', style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                      value: _selectedStartMonth,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B1FA2), size: 18),
                      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 12.5, fontWeight: FontWeight.bold),
                      dropdownColor: Colors.white,
                      items: _generateMonthsList().map((dt) => DropdownMenuItem<DateTime>(
                        value: dt,
                        child: Text(_formatMonthName(dt), style: const TextStyle(fontSize: 12.5, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600)),
                      )).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStartMonth = val;
                          if (_selectedEndMonth != null && val != null && val.isAfter(_selectedEndMonth!)) {
                            _selectedEndMonth = val;
                          }
                        });
                        _loadAll();
                      },
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.trending_flat_rounded, color: Colors.grey, size: 16),
              ),
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
                      hint: Text('Sampai Bulan', style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                      value: _selectedEndMonth,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B1FA2), size: 18),
                      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 12.5, fontWeight: FontWeight.bold),
                      dropdownColor: Colors.white,
                      items: _generateMonthsList().map((dt) => DropdownMenuItem<DateTime>(
                        value: dt,
                        child: Text(_formatMonthName(dt), style: const TextStyle(fontSize: 12.5, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600)),
                      )).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedEndMonth = val;
                          if (_selectedStartMonth != null && val != null && val.isBefore(_selectedStartMonth!)) {
                            _selectedStartMonth = val;
                          }
                        });
                        _loadAll();
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

  // ========== ARTICLES SECTION ==========
  Widget _buildArticlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Artikel & Edukasi',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF1A1A2E), letterSpacing: -0.4),
                ),
                Text('Pengetahuan dari Admin & Penyuluh', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.menu_book_rounded, color: Colors.white, size: 13),
                  SizedBox(width: 5),
                  Text('Baca', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Loading state
        if (_isLoadingArticles)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2), strokeWidth: 2.5)),
          )

        // Empty state
        else if (_articlesList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF3E5F5), shape: BoxShape.circle),
                  child: const Icon(Icons.article_rounded, size: 36, color: Color(0xFF9C27B0)),
                ),
                const SizedBox(height: 12),
                const Text('Belum ada artikel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Text('Artikel dari Admin & Penyuluh\nakan tampil di sini', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.5)),
              ],
            ),
          )

        else
          Column(
            children: [
              // Featured hero card - article[0]
              _buildHeroArticleCard(_articlesList[0]),

              // Remaining articles in horizontal scroll
              if (_articlesList.length > 1) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _articlesList.length - 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (ctx, i) => _buildSmallArticleCard(_articlesList[i + 1]),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildHeroArticleCard(ArticleItem article) {
    return GestureDetector(
      onTap: () => _showArticleDetail(article),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: const Color(0xFF7B1FA2).withValues(alpha: 0.20), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image or gradient fallback
              if (article.imageUrl != null)
                Image.network(
                  article.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
                      ),
                    ),
                  ),
                )
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(top: -20, right: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
                      Positioned(bottom: -30, left: 30, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)))),
                      const Center(child: Icon(Icons.article_rounded, size: 64, color: Colors.white30)),
                    ],
                  ),
                ),

              // Dark gradient overlay from bottom
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.15), Colors.black.withValues(alpha: 0.75)],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              // Content overlay
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(article.theme, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.3)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome, size: 10, color: Colors.white70),
                                const SizedBox(width: 4),
                                const Text('Unggulan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, height: 1.3, letterSpacing: -0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                            child: const Icon(Icons.person_rounded, size: 11, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          Text(article.authorName, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 11, color: Colors.white54),
                              const SizedBox(width: 4),
                              Text(_formatDateString(article.createdAt), style: const TextStyle(fontSize: 10.5, color: Colors.white54, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Tap ripple area
              Material(color: Colors.transparent, child: InkWell(onTap: () => _showArticleDetail(article), splashColor: Colors.white.withValues(alpha: 0.1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallArticleCard(ArticleItem article) {
    return GestureDetector(
      onTap: () => _showArticleDetail(article),
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image top
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)),
              child: SizedBox(
                width: double.infinity,
                height: 108,
                child: article.imageUrl != null
                    ? Image.network(article.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _articlePlaceholder())
                    : _articlePlaceholder(),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(6)),
                      child: Text(article.theme, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF7B1FA2))),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), height: 1.3),
                    ),
                    const Spacer(),
                    Text(
                      article.authorName,
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _articlePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
        ),
      ),
      child: const Center(child: Icon(Icons.article_rounded, size: 32, color: Colors.white30)),
    );
  }

  void _showArticleDetail(ArticleItem article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              // Header hero image
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 190,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (article.imageUrl != null)
                          Image.network(
                            article.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _detailImageFallback(),
                          )
                        else
                          _detailImageFallback(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16, bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(color: const Color(0xFF9C27B0), borderRadius: BorderRadius.circular(20)),
                            child: Text(article.theme, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1A2E), height: 1.3, letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 14),
                    // Author & date row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F0FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE1BEE7), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              article.authorName.isNotEmpty ? article.authorName[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                                Text('Dipublikasikan ${_formatDateString(article.createdAt)}', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: const [
                                Icon(Icons.visibility_rounded, size: 12, color: Color(0xFF7B1FA2)),
                                SizedBox(width: 4),
                                Text('Baca', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF7B1FA2))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(height: 1, color: Colors.grey.shade100),
                    const SizedBox(height: 22),
                    // Content
                    Text(
                      article.content,
                      style: const TextStyle(fontSize: 14.5, color: Color(0xFF3D3D3D), height: 1.75, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFF9C27B0)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
          const Center(child: Icon(Icons.article_rounded, size: 56, color: Colors.white24)),
        ],
      ),
    );
  }
}

