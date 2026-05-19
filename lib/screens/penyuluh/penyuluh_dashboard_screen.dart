import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fe_photobug/screens/penyuluh/laporan_penyuluh_view.dart';
import 'package:fe_photobug/screens/penyuluh/notifikasi_penyuluh_view.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class PenyuluhDashboardScreen extends StatefulWidget {
  const PenyuluhDashboardScreen({super.key});

  @override
  State<PenyuluhDashboardScreen> createState() => _PenyuluhDashboardScreenState();
}

class _PenyuluhDashboardScreenState extends State<PenyuluhDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaView(topPadding),
          LaporanPenyuluhView(topPadding: topPadding),
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
                  const Text(
                    'Tren Deteksi Hama',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A148C),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildChartCard(),
                  const SizedBox(height: 24),
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
                  const Text(
                    'Info Hama Terkini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A148C),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNewsItem(
                    title: 'Waspada Hama Wereng Coklat',
                    description: 'Populasi wereng coklat meningkat tajam di musim hujan. Segera berikan rekomendasi pengendalian ke petani.',
                    icon: Icons.newspaper_rounded,
                    iconColor: const Color(0xFFE65100),
                    date: '18 Mei 2026',
                  ),
                  const SizedBox(height: 12),
                  _buildNewsItem(
                    title: 'Perkembangan Wereng Hijau',
                    description: 'Wereng hijau mulai terdeteksi di beberapa lahan fase vegetatif. Pantau terus perkembangannya.',
                    icon: Icons.article_rounded,
                    iconColor: const Color(0xFF7B1FA2),
                    date: '17 Mei 2026',
                  ),
                  const SizedBox(height: 30),
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
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/gambartest.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.white.withValues(alpha: 0.2),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
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
                                      'IS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Irwan Setiawan',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1A2E),
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          'penyuluh@gmail.com',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.grey,
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
                            value: 0,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3E5F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xFF7B1FA2),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Lihat Profil',
                                  style: TextStyle(
                                    color: Color(0xFF7B1FA2),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
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
                      'Penyuluh Pertanian • Desa Hergamanah Aktif',
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
              const Text(
                'Halo, Irwan Setiawan 👋',
                style: TextStyle(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.assignment_rounded, // Same as petani
            iconColor: const Color(0xFF7B1FA2),
            iconBg: const Color(0xFFF3E5F5),
            value: '3',
            label: 'Laporan\nMasuk',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.hourglass_top_rounded, // Same as petani
            iconColor: const Color(0xFFF57C00),
            iconBg: const Color(0xFFFFF3E0),
            value: '1',
            label: 'Menunggu',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSingleStatCard(
            icon: Icons.check_circle_rounded, // Same as petani
            iconColor: const Color(0xFF2E7D32),
            iconBg: const Color(0xFFE8F5E9),
            value: '2',
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
            'Tren Hama Wareng 6 Bulan Terakhir',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4A148C),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 9,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Jan', style: style);
                            break;
                          case 1:
                            text = const Text('Feb', style: style);
                            break;
                          case 2:
                            text = const Text('Mar', style: style);
                            break;
                          case 3:
                            text = const Text('Apr', style: style);
                            break;
                          case 4:
                            text = const Text('Mei', style: style);
                            break;
                          case 5:
                            text = const Text('Jun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 6, // Jarak teks dengan garis bawah
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 9,
                      reservedSize: 32, // Sedikit diperbesar dari 30
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          space: 8, // Menambahkan jarak teks dengan grafik (Y-axis)
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 36,
                lineBarsData: [
                  // Hijau line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 18),
                      FlSpot(1, 24),
                      FlSpot(2, 20),
                      FlSpot(3, 37), // slightly over 36 to match the peak
                      FlSpot(4, 30),
                      FlSpot(5, 33),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2E7D32),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    ),
                  ),
                  // Coklat line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 5),
                      FlSpot(1, 8),
                      FlSpot(2, 10),
                      FlSpot(3, 12),
                      FlSpot(4, 9),
                      FlSpot(5, 14),
                    ],
                    isCurved: true,
                    color: const Color(0xFFE65100),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFE65100).withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Legends
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF2E7D32), 'Wareng Hijau'),
              const SizedBox(width: 24),
              _buildLegend(const Color(0xFFE65100), 'Wareng Coklat'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 1; // Index tab Laporan
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
                      const Text(
                        '3 Laporan Menunggu Balasan!',
                        style: TextStyle(
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

  Widget _buildNewsItem({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFBDBDBD),
            size: 24,
          ),
        ],
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
              _buildNavItem(Icons.notifications_outlined, 'Notifikasi', 2),
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
}
