import 'package:flutter/material.dart';
import 'package:fe_photobug/services/detection_service.dart';
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';
import 'package:fe_photobug/utils/dialog_utils.dart';
import 'laporan_hasil_screen.dart';
import 'riwayat_detail_screen.dart';

class RiwayatLaporanView extends StatefulWidget {
  const RiwayatLaporanView({super.key});

  @override
  State<RiwayatLaporanView> createState() => RiwayatLaporanViewState();
}

class RiwayatLaporanViewState extends State<RiwayatLaporanView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  TabController get tabController {
    _tabController ??= TabController(length: 3, vsync: this);
    return _tabController!;
  }

  late Future<HistoryResponse> _futureAll;
  late Future<HistoryResponse> _futurePending;
  late Future<HistoryResponse> _futureCompleted;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshData();
  }

  void _refreshData() {
    _futureAll = DetectionService.getHistory('all');
    _futurePending = DetectionService.getHistory('pending');
    _futureCompleted = DetectionService.getHistory('completed');
  }

  void silentRefresh() {
    setState(() {
      _refreshData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // ========== HEADER ==========
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, topPadding + 16, 22, 20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Profile
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
                                child: Text(
                                  AuthService.userName ?? 'Pengguna',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                    fontSize: 14.5,
                                  ),
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
              // TabBar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: TabBar(
                  controller: tabController,
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
        ),
        const SizedBox(height: 8),
        // ========== CONTENT ==========
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _buildHistoryList(_futureAll, 'Semua Laporan'),
              _buildHistoryList(_futurePending, 'Laporan Menunggu'),
              _buildHistoryList(_futureCompleted, 'Laporan Selesai'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(Future<HistoryResponse> future, String title) {
    return FutureBuilder<HistoryResponse>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7B1FA2)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          );
        }

        final response = snapshot.data;
        if (response == null || !response.success) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  response?.message ?? 'Gagal memuat data',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          );
        }

        final items = response.data ?? [];
        final filtered = items
            .where((item) => _searchQuery.isEmpty || item.pestName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada laporan',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: filtered.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
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
              );
            }
            return _buildHistoryCard(context, filtered[index - 1]);
          },
        );
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, HistoryItem item) {
    // Extract short AI recommendation
    final shortAiRec = _extractShortRecommendation(item.aiRecommendation.isNotEmpty ? item.aiRecommendation : item.recommendation);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RiwayatDetailScreen(detectionId: item.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TOP: IMAGE + INFO =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      'http://localhost:8000/api/image/${item.imagePath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: 28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.pestName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2C2C2C),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.status == 'pending'
                                    ? const Color(0xFFFFC107).withValues(alpha: 0.2)
                                    : Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status == 'pending' ? 'Menunggu' : 'Dibalas',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: item.status == 'pending'
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'Ds. ${item.villageName}  •  ${_formatDate(item.detectedAt)}',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Daun padi megunung,',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // ===== MIDDLE: REKOMENDASI AI =====
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REKOMENDASI AI (${item.highestConfidence})',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB0B0B0),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    shortAiRec,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A4A4A),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // ===== BOTTOM: STATUS =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: item.status == 'pending'
                    ? const Color(0xFFFEF3C7)
                    : Colors.green.withValues(alpha: 0.08),
              ),
              child: Row(
                children: [
                  Icon(
                    item.status == 'pending'
                        ? Icons.schedule_rounded
                        : Icons.check_circle_rounded,
                    size: 16,
                    color: item.status == 'pending'
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.status == 'pending'
                          ? 'Menunggu balasan dari Penyuluh...'
                          : 'Sudah dibalas oleh Penyuluh',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.status == 'pending'
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                      ),
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

  String _extractShortRecommendation(String recommendation) {
    // Extract first part before "Rekomendasi Penanganan" or similar
    if (recommendation.contains('Rekomendasi Penanganan')) {
      final parts = recommendation.split('Rekomendasi Penanganan');
      return parts[0].trim();
    }
    if (recommendation.contains('Mohon tunggu')) {
      return recommendation.split('Mohon tunggu')[0].trim();
    }
    // Return first 80 chars or first sentence
    final firstDot = recommendation.indexOf('.');
    if (firstDot > 0 && firstDot < 100) {
      return recommendation.substring(0, firstDot).trim();
    }
    return recommendation.length > 80 ? '${recommendation.substring(0, 80).trim()}...' : recommendation;
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
