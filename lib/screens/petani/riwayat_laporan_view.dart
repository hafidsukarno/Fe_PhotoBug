import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/petani/riwayat_detail_screen.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class RiwayatLaporanView extends StatefulWidget {
  const RiwayatLaporanView({super.key});

  @override
  State<RiwayatLaporanView> createState() => _RiwayatLaporanViewState();
}

class _RiwayatLaporanViewState extends State<RiwayatLaporanView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // ========== PREMIUM PURPLE HEADER ==========
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 24),
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
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.history_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aktivitas Pelaporan',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Text(
                                  'Riwayat Laporan',
                                  style: TextStyle(
                                    fontSize: 16,
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
                                        'BS',
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
                                            'Budi Santoso',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF1A1A2E),
                                              fontSize: 14.5,
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            'petani@gmail.com',
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
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded,
                              color: Colors.white.withValues(alpha: 0.8), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Cari laporan hama...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Icon(Icons.clear_rounded,
                                  color: Colors.white, size: 18),
                            )
                          else
                            Icon(Icons.filter_alt_outlined,
                                color: Colors.white.withValues(alpha: 0.8), size: 22),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ========== PREMIUM TAB BAR INSIDE HEADER ==========
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: TabBar(
                        padding: const EdgeInsets.all(4),
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        labelColor: const Color(0xFF4A148C),
                        unselectedLabelColor: Colors.white.withValues(alpha: 0.85),
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Semua'),
                          Tab(text: 'Menunggu'),
                          Tab(text: 'Selesai'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ========== LIST KONTEN ==========
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: Semua
                _buildListView(
                  context,
                  includeWaiting: true,
                  includeFinished: true,
                ),
                // TAB 2: Menunggu
                _buildListView(
                  context,
                  includeWaiting: true,
                  includeFinished: false,
                ),
                // TAB 3: Selesai
                _buildListView(
                  context,
                  includeWaiting: false,
                  includeFinished: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(
    BuildContext context, {
    required bool includeWaiting,
    required bool includeFinished,
  }) {
    final List<Map<String, dynamic>> allReportsData = [
      {
        'hama': 'Wereng Coklat',
        'image': 'assets/images/gambartest.png',
        'date': '12 Apr 2026',
        'status': 'Menunggu',
        'description': 'Daun padi menguning, banyak serangga kecil.',
        'aiRecommendationShort': 'Drainase & semprot Buprofezin 25 WP',
        'aiRecommendationLong':
            'Berdasarkan hasil analisis gambar, hama yang menyerang lahan Anda teridentifikasi sebagai Wereng Coklat. Untuk mengendalikan populasi hama ini secara efektif, disarankan agar Anda segera melakukan pengeringan lahan sawah selama 5 hingga 7 hari. Tindakan drainase ini sangat penting untuk memutus siklus hidup hama. Selain itu, Anda perlu mengaplikasikan insektisida berbahan aktif Buprofezin (misal: 25 WP) dengan dosis 1-2 liter per hektar, dengan penyemprotan difokuskan pada bagian pangkal batang padi. Lakukan pemantauan rutin setiap 2 hari sekali dan bersihkan gulma di sekitar pematang untuk menghilangkan sarang alternatif.',
        'aiAccuracy': '94%',
        'penyuluhReply': null,
        'penyuluhName': null,
      },
      {
        'hama': 'Belalang',
        'image': 'assets/images/gambartest.png',
        'date': '8 Apr 2026',
        'status': 'Dibalas',
        'description': 'Banyak belalang menyerang daun muda padi.',
        'aiRecommendationShort': 'Semprot insektisida kontak pagi hari',
        'aiRecommendationLong':
            'Deteksi AI menunjukkan adanya populasi Belalang pada tanaman padi Anda. Hama ini umumnya menyerang bagian daun yang menyebabkan daun sobek atau berlubang. Sebagai langkah penanganan, sangat disarankan untuk melakukan penyemprotan insektisida kontak pada pagi hari saat embun sudah mengering namun belalang belum terlalu aktif bergerak. Gunakan bahan aktif berbahan dasar nabati atau kimiawi dengan dosis anjuran. Lakukan penyiangan gulma di area sekitar sawah untuk mengurangi tempat persembunyian alternatif bagi hama.',
        'aiAccuracy': '87%',
        'penyuluhReply':
            'Gunakan Malathion 57 EC, 2ml/L air. Semprot pagi hari jam 6-8. Ulangi 5 hari kemudian.',
        'penyuluhName': 'Pak Irwan',
      },
      {
        'hama': 'Ulat Grayak',
        'image': 'assets/images/gambartest.png',
        'date': '2 Apr 2026',
        'status': 'Dibalas',
        'description': 'Daun padi bolong-bolong akibat gigitan ulat.',
        'aiRecommendationShort': 'Aplikasi insektisida sistemik',
        'aiRecommendationLong':
            'Sistem mendeteksi serangan Ulat Grayak pada tanaman Anda. Ulat ini cenderung bersembunyi di pangkal tanaman pada siang hari dan aktif menyerang helai daun secara masif di malam hari. Untuk penanggulangan awal, pastikan sistem pengairan sawah diatur dengan baik. Segera persiapkan aplikasi penyemprotan insektisida sistemik atau kontak lambung pada waktu sore atau malam hari. Dianjurkan untuk menggunakan bahan aktif Spinetoram atau Emamektin benzoat sesuai panduan dosis kemasan untuk menekan populasi secara cepat.',
        'aiAccuracy': '91%',
        'penyuluhReply':
            'Segera lakukan penyemprotan Spinetoram pada sore hari, karena ulat aktif pada malam hari.',
        'penyuluhName': 'Bu Siska',
      },
    ];

    final filtered = allReportsData.where((report) {
      final isWaiting = report['status'] == 'Menunggu';
      if (isWaiting && !includeWaiting) return false;
      if (!isWaiting && !includeFinished) return false;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatches = report['hama'].toString().toLowerCase().contains(query);
        final descMatches = report['description'].toString().toLowerCase().contains(query);
        return nameMatches || descMatches;
      }
      return true;
    }).toList();

    final List<Widget> items = [];

    // Section Title
    items.add(
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              includeWaiting && includeFinished
                  ? 'Semua Laporan'
                  : includeWaiting
                      ? 'Laporan Menunggu'
                      : 'Laporan Selesai',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4A148C),
                letterSpacing: -0.3,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A148C).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${filtered.length} Laporan',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4A148C),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    for (var report in filtered) {
      items.add(
        _buildHistoryCard(
          context,
          hama: report['hama'],
          image: report['image'],
          date: report['date'],
          status: report['status'],
          description: report['description'],
          aiRecommendationShort: report['aiRecommendationShort'],
          aiRecommendationLong: report['aiRecommendationLong'],
          aiAccuracy: report['aiAccuracy'],
          penyuluhReply: report['penyuluhReply'],
          penyuluhName: report['penyuluhName'],
        ),
      );
      items.add(const SizedBox(height: 16));
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Tidak ada riwayat laporan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Remove last height spacer if list is not empty
    if (items.isNotEmpty) {
      items.removeLast();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: items,
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String hama,
    required String image,
    required String date,
    required String status,
    required String description,
    required String aiRecommendationShort,
    required String aiRecommendationLong,
    required String aiAccuracy,
    String? penyuluhReply,
    String? penyuluhName,
  }) {
    final isWaiting = status == 'Menunggu';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RiwayatDetailScreen(
              hama: hama,
              image: image,
              date: date,
              status: status,
              description: description,
              aiRecommendation: aiRecommendationLong,
              aiAccuracy: aiAccuracy,
              penyuluhReply: penyuluhReply,
              penyuluhName: penyuluhName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A148C).withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Content Padding
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Beautiful Image with shadow
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, color: Colors.grey, size: 30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  hama,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF4A148C),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isWaiting
                                      ? const Color(0xFFFFF3E0)
                                      : const Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isWaiting
                                        ? const Color(0xFFFFB74D).withValues(alpha: 0.3)
                                        : const Color(0xFFBA68C8).withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  isWaiting ? 'Menunggu' : 'Selesai',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: isWaiting
                                        ? const Color(0xFFE65100)
                                        : const Color(0xFF7B1FA2),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  size: 13, color: const Color(0xFF9C27B0).withValues(alpha: 0.6)),
                              const SizedBox(width: 4),
                              Text(
                                'Ds. Sukamaju',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade400,
                                ),
                              ),
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
                          const SizedBox(height: 8),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Light Premium Footer (Cohesive grouping)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBFD),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade100, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Section inside footer
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1BEE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'AI $aiAccuracy',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A148C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            aiRecommendationShort,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Penyuluh Section inside footer
                    if (isWaiting)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF3E0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.hourglass_empty_rounded,
                                size: 12, color: Color(0xFFE65100)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Menunggu tanggapan dari penyuluh...',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle_outline_rounded,
                                    size: 12, color: Color(0xFF2E7D32)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ditanggapi oleh ${penyuluhName ?? "Penyuluh"}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              penyuluhReply ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.3,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
