import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../utils/dialog_utils.dart';

class PenggunaAdminView extends StatefulWidget {
  final double topPadding;

  const PenggunaAdminView({super.key, required this.topPadding});

  @override
  State<PenggunaAdminView> createState() => _PenggunaAdminViewState();
}

class _PenggunaAdminViewState extends State<PenggunaAdminView> {
  @override
  void initState() {
    super.initState();
    _fetchDesaForPenyuluh();
    _fetchPenyuluh();
  }

  // We need to fetch desa list just for assigning to Penyuluh in the bottom sheet.
  List<Village> _desaList = [];
  Map<String, String> _desaStatusMap = {};
  Future<void> _fetchDesaForPenyuluh() async {
    final villages = await AdminService.getVillages();
    final statusMap = await AdminService.getVillagesStatus();
    if (mounted) {
      setState(() {
        _desaList = villages;
        _desaStatusMap = statusMap;
      });
    }
  }

  @override
  void dispose() {
    _penyuluhNameCtrl.dispose();
    _penyuluhUsernameCtrl.dispose();
    _penyuluhEmailCtrl.dispose();
    _penyuluhPhoneCtrl.dispose();
    _penyuluhPasswordCtrl.dispose();
    super.dispose();
  }

  List<PenyuluhItem> _penyuluhList = [];
  bool _isLoadingPenyuluh = true;

  Future<void> _fetchPenyuluh() async {
    setState(() => _isLoadingPenyuluh = true);
    final penyuluh = await AdminService.getPenyuluhList();
    if (mounted) {
      setState(() {
        _penyuluhList = penyuluh;
        _isLoadingPenyuluh = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildTabPenyuluh(),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                  ],
                ),
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
                            child: Text(
                              (AuthService.userName ?? 'A').substring(0, 1).toUpperCase(),
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
                                  AuthService.userName ?? 'Super Admin',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  AuthService.userEmail ?? 'admin@photobug.id',
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
        ],
      ),
    );
  }



  // ==================== TAB 1: PENYULUH ====================
  Widget _buildTabPenyuluh() {
    if (_isLoadingPenyuluh) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2)));
    }
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
          final List<String> binaan = penyuluh.managedVillages;
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
                            penyuluh.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            penyuluh.noHp ?? 'No. HP belum diatur',
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
                      onPressed: () => _showAddPenyuluhSheet(penyuluhToEdit: penyuluh),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: Colors.red.shade400,
                      onPressed: () {
                        _showDeleteConfirmation(
                          title: 'Hapus Penyuluh',
                          content: 'Apakah Anda yakin ingin menghapus penyuluh ${penyuluh.name}? Aksi ini tidak dapat dibatalkan.',
                          onConfirm: () => _deletePenyuluh(penyuluh.id),
                        );
                      },
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

  final TextEditingController _penyuluhNameCtrl = TextEditingController();
  final TextEditingController _penyuluhUsernameCtrl = TextEditingController();
  final TextEditingController _penyuluhEmailCtrl = TextEditingController();
  final TextEditingController _penyuluhPhoneCtrl = TextEditingController();
  final TextEditingController _penyuluhPasswordCtrl = TextEditingController();

  void _showSnackBar(String message, {bool isSuccess = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteConfirmation({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = 'Hapus',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }



  Future<void> _deletePenyuluh(int id) async {
    final errorMessage = await AdminService.deletePenyuluh(id);
    if (errorMessage == null) {
      _showSnackBar('Penyuluh berhasil dihapus', isSuccess: true);
      _fetchPenyuluh();
      _fetchDesaForPenyuluh();
    } else {
      _showSnackBar(errorMessage, isSuccess: false);
    }
  }

  void _showAddPenyuluhSheet({PenyuluhItem? penyuluhToEdit}) {
    _penyuluhNameCtrl.text = penyuluhToEdit?.name ?? '';
    _penyuluhUsernameCtrl.text = penyuluhToEdit?.username ?? '';
    _penyuluhEmailCtrl.text = penyuluhToEdit?.email ?? '';
    _penyuluhPhoneCtrl.text = penyuluhToEdit?.noHp ?? '';
    _penyuluhPasswordCtrl.text = ''; // Password selalu kosong

    final Map<int, bool> selectedDesa = {
      for (var d in _desaList) d.id: penyuluhToEdit?.managedVillages.contains(d.villageName) ?? false
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
                Text(
                  penyuluhToEdit == null ? 'Tambah Penyuluh Baru' : 'Edit Penyuluh',
                  style: const TextStyle(
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
                      _buildTextField('Nama Lengkap', 'Masukkan nama penyuluh', controller: _penyuluhNameCtrl),
                      const SizedBox(height: 16),
                      _buildTextField('Username', 'Masukkan username', controller: _penyuluhUsernameCtrl),
                      const SizedBox(height: 16),
                      _buildTextField('Email', 'Masukkan email', controller: _penyuluhEmailCtrl),
                      const SizedBox(height: 16),
                      _buildTextField('No Handphone', 'Masukkan no hp', controller: _penyuluhPhoneCtrl),
                      if (penyuluhToEdit == null) ...[
                        const SizedBox(height: 16),
                        _buildTextField('Password', 'Masukkan password sementara', isPassword: true, controller: _penyuluhPasswordCtrl),
                      ],
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
                          children: _desaList.map((desa) {
                            final status = _desaStatusMap[desa.villageName] ?? 'kosong';
                            // Kalau edit dan desa ini milik dia, jangan di-disable
                            final isOwner = penyuluhToEdit != null && penyuluhToEdit.managedVillages.contains(desa.villageName);
                            final isTerisi = status == 'terisi' && !isOwner;

                            return CheckboxListTile(
                              title: Text(
                                isTerisi ? '${desa.villageName} (Sudah Terisi)' : desa.villageName,
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.w600,
                                  color: isTerisi ? Colors.grey : const Color(0xFF1A1A2E),
                                ),
                              ),
                              value: selectedDesa[desa.id],
                              activeColor: const Color(0xFF7B1FA2),
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: isTerisi ? null : (bool? value) {
                                setSheetState(() {
                                  selectedDesa[desa.id] = value ?? false;
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
                    onPressed: () async {
                      final name = _penyuluhNameCtrl.text;
                      final username = _penyuluhUsernameCtrl.text;
                      final email = _penyuluhEmailCtrl.text;
                      final phone = _penyuluhPhoneCtrl.text;
                      final password = _penyuluhPasswordCtrl.text;
                      
                      final villages = selectedDesa.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();

                      if (penyuluhToEdit == null && (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty)) {
                        _showSnackBar('Harap lengkapi field yang wajib (Nama, Username, Email, Password)', isSuccess: false);
                        return;
                      } else if (penyuluhToEdit != null && (name.isEmpty || username.isEmpty || email.isEmpty)) {
                        _showSnackBar('Harap lengkapi field yang wajib (Nama, Username, Email)', isSuccess: false);
                        return;
                      }

                      String? errorMessage;
                      if (penyuluhToEdit == null) {
                        errorMessage = await AdminService.createPenyuluh(
                          name: name,
                          username: username,
                          email: email,
                          password: password,
                          noHp: phone,
                          villages: villages,
                        );
                      } else {
                        errorMessage = await AdminService.updatePenyuluh(
                          id: penyuluhToEdit.id,
                          name: name,
                          username: username,
                          email: email,
                          password: '',
                          noHp: phone,
                          villages: villages,
                        );
                      }

                      if (errorMessage == null) {
                        if (mounted) Navigator.pop(context);
                        _showSnackBar(penyuluhToEdit == null ? 'Penyuluh berhasil ditambahkan!' : 'Penyuluh berhasil diperbarui!', isSuccess: true);
                        _fetchPenyuluh();
                        _fetchDesaForPenyuluh();
                      } else {
                        _showSnackBar(errorMessage, isSuccess: false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      penyuluhToEdit == null ? 'Buat Akun & Tugaskan Desa' : 'Perbarui Akun',
                      style: const TextStyle(
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

  Widget _buildTextField(String label, String hint, {bool isPassword = false, TextEditingController? controller}) {
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
          controller: controller,
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
