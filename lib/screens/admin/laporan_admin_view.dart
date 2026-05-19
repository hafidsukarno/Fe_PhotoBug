import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/admin/detail_laporan_admin_screen.dart';

class LaporanAdminView extends StatefulWidget {
  final double topPadding;

  const LaporanAdminView({super.key, required this.topPadding});

  @override
  State<LaporanAdminView> createState() => _LaporanAdminViewState();
}

class _LaporanAdminViewState extends State<LaporanAdminView> {
  int _selectedTab = 0;   // 0=Semua, 1=Pending, 2=Selesai
  int _currentPage = 1;
  static const int _perPage = 10;

  // Default ke bulan saat ini — inisialisasi langsung agar aman di IndexedStack
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  static const List<String> _namaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  // ===================== DATA DUMMY =====================
  // NOTE untuk backend nanti: ganti seluruh bagian ini dengan API call:
  // GET /api/laporan?bulan=$_selectedMonth&tahun=$_selectedYear&status=...&page=$_currentPage&limit=$_perPage
  // Response: { data: [...], total: int, pending: int, selesai: int }
  //
  // Data disebar ke beberapa bulan berbeda agar stats per bulan berubah saat filter diganti.
  static final List<Map<String, dynamic>> _dummyAll = _generateDummy();

  static List<Map<String, dynamic>> _generateDummy() {
    const statuses = ['Pending', 'Pending', 'Selesai', 'Selesai', 'Selesai'];
    const hamas = [
      'Wereng Coklat', 'Blas Padi', 'Ulat Grayak',
      'Wereng Hijau', 'Tikus Sawah', 'Belalang',
      'Walang Sangit', 'Penggerek Batang',
    ];
    const petanis = [
      'Budi Santoso', 'Siti Aminah', 'Hendra W.',
      'Ahmad Fauzi', 'Neng Rini', 'Ujang Purnama',
      'Dadang S.', 'Yanti Kusuma',
    ];
    const desas = [
      'Ds. Sukamaju', 'Ds. Ciawi Lor',
      'Ds. Rawa Gede', 'Ds. Sindangjaya',
    ];
    const penyuluhs = ['Pak Irwan', 'Bu Sari', 'Pak Dedi'];
    const akurasis = ['94%', '87%', '91%', '89%', '96%', '82%', '93%', '85%'];
    const namaBulan = [
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Agu','Sep','Okt','Nov','Des',
    ];

    // Distribusi jumlah laporan per bulan (total 120 data)
    // Bulan 1..12 → jumlah berbeda supaya stats keliatan berubah
    final perBulan = [5, 8, 12, 9, 14, 7, 11, 6, 13, 10, 8, 17];
    final now = DateTime.now();
    final List<Map<String, dynamic>> result = [];
    int globalId = 1;

    for (int m = 1; m <= 12; m++) {
      final count = perBulan[m - 1];
      for (int j = 0; j < count; j++) {
        final day = (j % 28) + 1;
        final hour = (8 + j % 12).toString().padLeft(2, '0');
        final min = (j * 7 % 60).toString().padLeft(2, '0');
        result.add({
          'id': globalId,
          'hama': hamas[globalId % hamas.length],
          'petani': petanis[globalId % petanis.length],
          'desa': desas[globalId % desas.length],
          'tanggal': '${day.toString().padLeft(2, '0')} ${namaBulan[m - 1]} · $hour:$min',
          'bulan': m,
          'tahun': now.year,
          'status': statuses[globalId % statuses.length],
          'akurasi': akurasis[globalId % akurasis.length],
          'penyuluh': penyuluhs[globalId % penyuluhs.length],
          'image': 'assets/images/gambartest.png',
        });
        globalId++;
      }
    }
    return result;
  }

  // ---- Filtered by bulan + tab ----
  // Saat connect backend: ganti _dummyAll dengan response API
  List<Map<String, dynamic>> get _filteredByBulan => _dummyAll
      .where((l) => l['bulan'] == _selectedMonth && l['tahun'] == _selectedYear)
      .toList();

  List<Map<String, dynamic>> get _filteredLaporan {
    final byBulan = _filteredByBulan;
    if (_selectedTab == 1) return byBulan.where((l) => l['status'] == 'Pending').toList();
    if (_selectedTab == 2) return byBulan.where((l) => l['status'] == 'Selesai').toList();
    return byBulan;
  }

  int get _totalPages => (_filteredLaporan.length / _perPage).ceil().clamp(1, 9999);

  List<Map<String, dynamic>> get _paginatedLaporan {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredLaporan.length);
    if (start >= _filteredLaporan.length) return [];
    return _filteredLaporan.sublist(start, end);
  }

  int get _pendingCount => _filteredByBulan.where((l) => l['status'] == 'Pending').length;
  int get _selesaiCount => _filteredByBulan.where((l) => l['status'] == 'Selesai').length;

  void _changeTab(int index) {
    setState(() {
      _selectedTab = index;
      _currentPage = 1;
    });
  }

  void _changeBulan(int month, int year) {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
      _currentPage = 1;
    });
  }

  void _showFilterBottomSheet() {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;
    final currentYear = DateTime.now().year;
    final years = [currentYear - 1, currentYear, currentYear + 1];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text('Filter Laporan',
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      )),
                  const SizedBox(height: 4),
                  Text('Pilih bulan dan tahun',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                  const SizedBox(height: 20),

                  // Year selector
                  const Text('Tahun',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 10),
                  Row(
                    children: years.map((y) {
                      final isActive = tempYear == y;
                      return GestureDetector(
                        onTap: () => setModalState(() => tempYear = y),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFF7B1FA2) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('$y',
                              style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700,
                                color: isActive ? Colors.white : Colors.grey.shade700,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Month grid
                  const Text('Bulan',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.0,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(_namaBulan.length, (i) {
                      final isActive = tempMonth == i + 1;
                      return GestureDetector(
                        onTap: () => setModalState(() => tempMonth = i + 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFF7B1FA2) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(_namaBulan[i],
                                style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700,
                                  color: isActive ? Colors.white : Colors.grey.shade700,
                                )),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _changeBulan(tempMonth, tempYear);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Terapkan Filter',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _paginatedLaporan.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        itemCount: _paginatedLaporan.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildLaporanCard(_paginatedLaporan[index]);
                        },
                      ),
              ),
              // ---- PAGINATION BAR ----
              _buildPagination(),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader() {
    final tabs = ['Semua', 'Pending', 'Selesai'];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, widget.topPadding + 16, 22, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        boxShadow: [
          BoxShadow(color: Color(0x444A148C), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Export
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Master Laporan',
                    style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semua laporan dari seluruh petani',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text('Export',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search bar + Filter button
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.8), size: 21),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Cari laporan, petani, hama...',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Filter button
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tune_rounded, color: Color(0xFF7B1FA2), size: 18),
                      const SizedBox(width: 6),
                      const Text('Filter',
                          style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: Color(0xFF7B1FA2),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active filter chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${_namaBulan[_selectedMonth - 1]} $_selectedYear',
                      style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        _changeBulan(now.month, now.year);
                      },
                      child: Icon(Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.7), size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ---- STATUS TABS ----
          Row(
            children: List.generate(tabs.length, (i) {
              final isActive = _selectedTab == i;
              return Padding(
                padding: EdgeInsets.only(right: i < tabs.length - 1 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => _changeTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isActive ? const Color(0xFF7B1FA2) : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // ---- STATS ROW ----
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip('${_filteredByBulan.length}', 'Total', const Color(0xFF7B1FA2)),
                Container(width: 1, height: 32, color: Colors.grey.shade200),
                _buildStatChip('$_pendingCount', 'Pending', const Color(0xFFF57C00)),
                Container(width: 1, height: 32, color: Colors.grey.shade200),
                _buildStatChip('$_selesaiCount', 'Selesai', const Color(0xFF2E7D32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 1),
        Text(label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
      ],
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.description_outlined,
                size: 48, color: Color(0xFF7B1FA2)),
          ),
          const SizedBox(height: 16),
          const Text('Tidak ada laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          Text('Belum ada laporan di bulan ini',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  // ==================== PAGINATION BAR ====================
  Widget _buildPagination() {
    if (_totalPages <= 1) return const SizedBox(height: 16);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Prev button
          _buildPageArrow(
            icon: Icons.chevron_left_rounded,
            enabled: _currentPage > 1,
            onTap: () => setState(() => _currentPage--),
          ),
          const SizedBox(width: 8),

          // Page numbers (show max 5 around current)
          ..._buildPageNumbers(),

          const SizedBox(width: 8),
          // Next button
          _buildPageArrow(
            icon: Icons.chevron_right_rounded,
            enabled: _currentPage < _totalPages,
            onTap: () => setState(() => _currentPage++),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<Widget> widgets = [];
    int start = (_currentPage - 2).clamp(1, _totalPages);
    int end = (start + 4).clamp(1, _totalPages);
    if (end - start < 4) start = (end - 4).clamp(1, end);

    if (start > 1) {
      widgets.add(_buildPageBtn(1));
      if (start > 2) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('...', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        ));
      }
    }

    for (int p = start; p <= end; p++) {
      widgets.add(_buildPageBtn(p));
    }

    if (end < _totalPages) {
      if (end < _totalPages - 1) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('...', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        ));
      }
      widgets.add(_buildPageBtn(_totalPages));
    }

    return widgets;
  }

  Widget _buildPageBtn(int page) {
    final isActive = _currentPage == page;
    return GestureDetector(
      onTap: () => setState(() => _currentPage = page),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7B1FA2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFF7B1FA2) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF7B1FA2).withValues(alpha: 0.08)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? const Color(0xFF7B1FA2).withValues(alpha: 0.3) : Colors.grey.shade200,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? const Color(0xFF7B1FA2) : Colors.grey.shade400,
        ),
      ),
    );
  }

  // ==================== LAPORAN CARD ====================
  Widget _buildLaporanCard(Map<String, dynamic> laporan) {
    final isPending = laporan['status'] == 'Pending';
    final Color statusColor = isPending ? const Color(0xFFF57C00) : const Color(0xFF2E7D32);
    final Color statusBg = isPending ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailLaporanAdminScreen(
              hama: laporan['hama'],
              image: laporan['image'],
              tanggal: laporan['tanggal'],
              status: laporan['status'],
              petani: laporan['petani'],
              desa: laporan['desa'],
              akurasi: laporan['akurasi'],
              penyuluh: laporan['penyuluh'],
            ),
          ),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // TOP
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nomor urut di halaman
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 10, top: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${laporan['id']}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                  ),
                ),
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    laporan['image'],
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 62,
                      height: 62,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.bug_report_rounded, color: Colors.grey, size: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                              laporan['hama'],
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              laporan['status'],
                              style: TextStyle(
                                  color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(laporan['petani'],
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12.5, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Text(laporan['desa'],
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          const SizedBox(width: 10),
                          Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Text(laporan['tanggal'],
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            const SizedBox(height: 10),

            // BOTTOM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text('AI',
                          style: TextStyle(
                              color: Color(0xFF2E7D32), fontSize: 9, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 5),
                    Text(laporan['akurasi'],
                        style: const TextStyle(
                            color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 10),
                    Icon(Icons.person_outline_rounded, size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(laporan['penyuluh'],
                        style: TextStyle(
                            fontSize: 11.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: Color(0xFF7B1FA2)),
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
