import 'package:flutter/material.dart';

class PenggunaAdminView extends StatefulWidget {
  final double topPadding;

  const PenggunaAdminView({super.key, required this.topPadding});

  @override
  State<PenggunaAdminView> createState() => _PenggunaAdminViewState();
}

class _PenggunaAdminViewState extends State<PenggunaAdminView> {
  // 0 = Desa, 1 = Penyuluh
  int _selectedTab = 0;

  // Data Dummy Desa
  final List<Map<String, dynamic>> _desaList = [
    {'id': 1, 'nama': 'Ds. Sukamaju', 'kec': 'Kec. Ciawi', 'kab': 'Kab. Bogor'},
    {'id': 2, 'nama': 'Ds. Ciawi Lor', 'kec': 'Kec. Ciawi', 'kab': 'Kab. Bogor'},
    {'id': 3, 'nama': 'Ds. Rawa Gede', 'kec': 'Kec. Ciawi', 'kab': 'Kab. Bogor'},
    {'id': 4, 'nama': 'Ds. Sindangjaya', 'kec': 'Kec. Ciawi', 'kab': 'Kab. Bogor'},
  ];

  // Data Dummy Penyuluh
  final List<Map<String, dynamic>> _penyuluhList = [
    {
      'id': 1,
      'nama': 'Pak Irwan',
      'email': 'irwan.penyuluh@gmail.com',
      'phone': '081234567890',
      'desa_binaan': ['Ds. Sukamaju', 'Ds. Ciawi Lor'],
    },
    {
      'id': 2,
      'nama': 'Bu Sari',
      'email': 'sari.agri@gmail.com',
      'phone': '081298765432',
      'desa_binaan': ['Ds. Rawa Gede'],
    },
    {
      'id': 3,
      'nama': 'Pak Dedi',
      'email': 'dedi.tani@gmail.com',
      'phone': '085512341234',
      'desa_binaan': ['Ds. Sindangjaya'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTab == 0 ? _buildTabDesa() : _buildTabPenyuluh(),
          ),
        ),
      ],
    );
  }

  // ==================== HEADER & TAB TOGGLE ====================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, widget.topPadding + 20, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x334A148C),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manajemen Pengguna',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelola data desa dan akun penyuluh lapangan',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // Custom Tab Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTab == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Desa',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _selectedTab == 0
                                ? const Color(0xFF4A148C)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTab == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Penyuluh',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _selectedTab == 1
                                ? const Color(0xFF4A148C)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TAB 0: DESA ====================
  Widget _buildTabDesa() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Button Tambah Desa
        GestureDetector(
          onTap: _showAddDesaSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Color(0xFF7B1FA2)),
                SizedBox(width: 8),
                Text(
                  'Tambah Desa Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Daftar Desa (${_desaList.length})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),

        // List Item Desa
        ..._desaList.map((desa) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Color(0xFF7B1FA2), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        desa['nama'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${desa['kec']}, ${desa['kab']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Delete
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: Colors.red.shade400,
                  onPressed: () {
                    // TODO: Connect to delete API
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==================== TAB 1: PENYULUH ====================
  Widget _buildTabPenyuluh() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Button Tambah Penyuluh
        GestureDetector(
          onTap: _showAddPenyuluhSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_rounded, color: Color(0xFF7B1FA2)),
                SizedBox(width: 8),
                Text(
                  'Tambah Penyuluh Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Daftar Penyuluh (${_penyuluhList.length})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),

        // List Item Penyuluh
        ..._penyuluhList.map((penyuluh) {
          final List<String> binaan = penyuluh['desa_binaan'];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.support_agent_rounded,
                          color: Color(0xFF1565C0), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            penyuluh['nama'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            penyuluh['phone'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      color: Colors.grey.shade400,
                      onPressed: () {
                        // TODO: Open edit form
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: Colors.red.shade400,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.grey.shade100),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.assignment_ind_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Membina ${binaan.length} Desa: ${binaan.join(', ')}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==================== BOTTOM SHEETS (FORMS) ====================

  void _showAddDesaSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tambah Desa Baru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nama Desa', 'Masukkan nama desa (mis. Ds. Sukamaju)'),
            const SizedBox(height: 16),
            _buildTextField('Kecamatan', 'Masukkan kecamatan'),
            const SizedBox(height: 16),
            _buildTextField('Kabupaten', 'Masukkan kabupaten'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Desa',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPenyuluhSheet() {
    // Simulasi state checkbox lokal di dalam bottom sheet
    final Map<String, bool> selectedDesa = {
      for (var d in _desaList) d['nama']: false
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tambah Penyuluh Baru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      const Text('INFORMASI AKUN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey)),
                      const SizedBox(height: 12),
                      _buildTextField('Nama Lengkap', 'Masukkan nama penyuluh'),
                      const SizedBox(height: 16),
                      _buildTextField('Email', 'Masukkan email'),
                      const SizedBox(height: 16),
                      _buildTextField('No Handphone', 'Masukkan no hp'),
                      const SizedBox(height: 16),
                      _buildTextField('Password', 'Masukkan password sementara', isPassword: true),
                      const SizedBox(height: 24),

                      // Bagian Desa Binaan
                      const Text('PILIH DESA BINAAN (PENUGASAN)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: selectedDesa.keys.map((desaNama) {
                            return CheckboxListTile(
                              title: Text(
                                desaNama,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              value: selectedDesa[desaNama],
                              activeColor: const Color(0xFF7B1FA2),
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (bool? value) {
                                setSheetState(() {
                                  selectedDesa[desaNama] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Buat Akun & Tugaskan Desa',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7B1FA2), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
