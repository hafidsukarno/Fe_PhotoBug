import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../utils/dialog_utils.dart';

class KelolaDesaAdminView extends StatefulWidget {
  final double topPadding;

  const KelolaDesaAdminView({super.key, required this.topPadding});

  @override
  State<KelolaDesaAdminView> createState() => KelolaDesaAdminViewState();
}

class KelolaDesaAdminViewState extends State<KelolaDesaAdminView> {
  List<Village> _desaList = [];
  Map<String, String> _desaStatusMap = {};
  bool _isLoadingDesa = true;

  final TextEditingController _desaNameCtrl = TextEditingController();
  final TextEditingController _desaDistrictCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDesa();
  }

  Future<void> _fetchDesa({bool isSilent = false}) async {
    if (!isSilent || _desaList.isEmpty) {
      setState(() => _isLoadingDesa = true);
    }
    final villages = await AdminService.getVillages();
    final statusMap = await AdminService.getVillagesStatus();
    if (mounted) {
      setState(() {
        _desaList = villages;
        _desaStatusMap = statusMap;
        _isLoadingDesa = false;
      });
    }
  }

  void silentRefresh() {
    _fetchDesa(isSilent: true);
  }

  @override
  void dispose() {
    _desaNameCtrl.dispose();
    _desaDistrictCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildTabDesa(),
        ),
      ],
    );
  }

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
                      'Kelola Desa',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manajemen data desa binaan',
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

  Widget _buildTabDesa() {
    if (_isLoadingDesa) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2)));
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Button Tambah Desa
        GestureDetector(
          onTap: () => _showAddDesaSheet(),
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
                        desa.villageName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desa.district,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  color: Colors.grey.shade400,
                  onPressed: () => _showAddDesaSheet(desaToEdit: desa),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: Colors.red.shade400,
                  onPressed: () {
                    _showDeleteConfirmation(
                      title: 'Hapus Desa',
                      content: 'Apakah Anda yakin ingin menghapus desa ${desa.villageName}? Aksi ini tidak dapat dibatalkan.',
                      onConfirm: () => _deleteDesa(desa.id),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

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

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 24),
            const SizedBox(width: 8),
            const Text('Gagal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
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

  Future<void> _deleteDesa(int id) async {
    final errorMessage = await AdminService.deleteVillage(id);
    if (errorMessage == null) {
      _showSnackBar('Desa berhasil dihapus', isSuccess: true);
      _fetchDesa();
    } else {
      _showSnackBar(errorMessage, isSuccess: false);
    }
  }

  void _showAddDesaSheet({Village? desaToEdit}) {
    _desaNameCtrl.text = desaToEdit?.villageName ?? '';
    _desaDistrictCtrl.text = desaToEdit?.district ?? '';

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
            Text(
              desaToEdit == null ? 'Tambah Desa Baru' : 'Edit Desa',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nama Desa', 'Masukkan nama desa (mis. Ds. Sukamaju)', controller: _desaNameCtrl),
            const SizedBox(height: 16),
            _buildTextField('Kecamatan / Distrik', 'Masukkan kecamatan/distrik', controller: _desaDistrictCtrl),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final name = _desaNameCtrl.text;
                  final dist = _desaDistrictCtrl.text;
                  
                  final cleanedName = name.trim();
                  final cleanedDist = dist.trim();

                  if (cleanedName.isEmpty || cleanedDist.isEmpty) {
                    _showErrorDialog('Harap lengkapi semua field (Nama Desa dan Kecamatan)');
                    return;
                  }

                  if (cleanedName.length < 3) {
                    _showErrorDialog('Nama desa minimal harus 3 karakter');
                    return;
                  }

                  if (cleanedDist.length < 3) {
                    _showErrorDialog('Nama kecamatan/distrik minimal harus 3 karakter');
                    return;
                  }

                  String? errorMessage;
                  if (desaToEdit == null) {
                    errorMessage = await AdminService.createVillage(cleanedName, cleanedDist);
                  } else {
                    errorMessage = await AdminService.updateVillage(desaToEdit.id, cleanedName, cleanedDist);
                  }

                  if (errorMessage == null) {
                    if (mounted) Navigator.pop(context);
                    _showSnackBar(desaToEdit == null ? 'Desa berhasil ditambahkan' : 'Desa berhasil diperbarui', isSuccess: true);
                    _fetchDesa();
                  } else {
                    _showErrorDialog(errorMessage);
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
                  desaToEdit == null ? 'Simpan Desa' : 'Perbarui Desa',
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
