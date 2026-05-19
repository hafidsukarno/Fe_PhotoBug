import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/penyuluh/laporan_detail_penyuluh_screen.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class LaporanPenyuluhView extends StatefulWidget {
  final double topPadding;

  const LaporanPenyuluhView({super.key, required this.topPadding});

  @override
  State<LaporanPenyuluhView> createState() => _LaporanPenyuluhViewState();
}

class _LaporanPenyuluhViewState extends State<LaporanPenyuluhView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              children: [
                _buildListView(context, includeWaiting: true, includeFinished: true),
                _buildListView(context, includeWaiting: true, includeFinished: false),
                _buildListView(context, includeWaiting: false, includeFinished: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, widget.topPadding + 16, 22, 24),
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
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tinjauan Penyuluh',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Text(
                            'Laporan Petani',
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
                                  'PI',
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
                                      'Pak Irwan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1A2E),
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      'irwan.penyuluh@gmail.com',
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

              // Tab Bar
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
    );
  }

  Widget _buildListView(
    BuildContext context, {
    required bool includeWaiting,
    required bool includeFinished,
  }) {
    final allReports = [
      {
        'title': 'Wereng Coklat',
        'petaniName': 'Budi Santoso',
        'location': 'Ds. Sukamaju',
        'date': '12 Apr · 08:47',
        'imageUrl': 'assets/images/gambartest.png',
        'accuracy': '94%',
        'status': 'Menunggu',
        'isWaiting': true,
      },
      {
        'title': 'Blas Padi',
        'petaniName': 'Siti Aminah',
        'location': 'Ds. Ciawi Lor',
        'date': '12 Apr · 06:20',
        'imageUrl': 'assets/images/gambartest.png',
        'accuracy': '87%',
        'status': 'Selesai',
        'isWaiting': false,
      },
      {
        'title': 'Ulat Grayak',
        'petaniName': 'Hendra W.',
        'location': 'Ds. Rawa Gede',
        'date': '11 Apr · 19:10',
        'imageUrl': 'assets/images/gambartest.png',
        'accuracy': '91%',
        'status': 'Selesai',
        'isWaiting': false,
      },
    ];

    final filtered = allReports.where((r) {
      final isW = r['isWaiting'] as bool;
      if (isW && !includeWaiting) return false;
      if (!isW && !includeFinished) return false;
      
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final title = (r['title'] as String).toLowerCase();
        final name = (r['petaniName'] as String).toLowerCase();
        final loc = (r['location'] as String).toLowerCase();
        return title.contains(query) || name.contains(query) || loc.contains(query);
      }
      return true;
    }).toList();

    final String title = includeWaiting && includeFinished
        ? 'Semua Laporan'
        : includeWaiting
            ? 'Laporan Menunggu'
            : 'Laporan Selesai';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
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
        if (filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada laporan ditemukan',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        else
          ...filtered.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildReportCard(
                title: r['title'] as String,
                petaniName: r['petaniName'] as String,
                location: r['location'] as String,
                date: r['date'] as String,
                imageUrl: r['imageUrl'] as String,
                accuracy: r['accuracy'] as String,
                status: r['status'] as String,
                isWaiting: r['isWaiting'] as bool,
              ),
            );
          }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildReportCard({
    required String title,
    required String petaniName,
    required String location,
    required String date,
    required String imageUrl,
    required String accuracy,
    required String status,
    required bool isWaiting,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaporanDetailPenyuluhScreen(isWaiting: isWaiting),
          ),
        );
      },
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isWaiting ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: isWaiting ? const Color(0xFFE65100) : const Color(0xFF2E7D32),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          petaniName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade100, thickness: 1.5, height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            color: Color(0xFF7B1FA2),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Akurasi AI: ',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        accuracy,
                        style: const TextStyle(
                          color: Color(0xFF7B1FA2),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B1FA2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          isWaiting ? 'Beri Rekomendasi' : 'Lihat Detail',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
