import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../utils/dialog_utils.dart';

class KelolaArtikelAdminView extends StatefulWidget {
  final double topPadding;

  const KelolaArtikelAdminView({super.key, required this.topPadding});

  @override
  State<KelolaArtikelAdminView> createState() => KelolaArtikelAdminViewState();
}

class KelolaArtikelAdminViewState extends State<KelolaArtikelAdminView> {
  List<ArticleItem> _articleList = [];
  bool _isLoadingArticles = true;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _authorCtrl = TextEditingController();
  final TextEditingController _themeCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles({bool isSilent = false}) async {
    if (!isSilent || _articleList.isEmpty) {
      setState(() => _isLoadingArticles = true);
    }
    final articles = await AdminService.getArticles();
    if (mounted) {
      setState(() {
        _articleList = articles;
        _isLoadingArticles = false;
      });
    }
  }

  void silentRefresh() {
    _fetchArticles(isSilent: true);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _themeCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildTabArticles(),
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
                      'Kelola Artikel',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manajemen artikel dan informasi pertanian',
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

  Widget _buildTabArticles() {
    if (_isLoadingArticles) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2)));
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Button Tambah Artikel
        GestureDetector(
          onTap: () => _showAddArticleSheet(),
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
                  'Tambah Artikel Baru',
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
          'Daftar Artikel (${_articleList.length})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),

        // List Item Artikel
        if (_articleList.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.article_outlined, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada artikel',
                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        else
          ..._articleList.map((article) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade100,
                      child: article.imageUrl != null
                          ? Image.network(
                              article.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                            )
                          : const Icon(Icons.image_rounded, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category/Theme Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.theme,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7B1FA2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Title
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Author Name
                        Text(
                          'Penulis: ${article.authorName}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 20),
                        color: Colors.grey.shade400,
                        onPressed: () => _showAddArticleSheet(articleToEdit: article),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        color: Colors.red.shade400,
                        onPressed: () {
                          _showDeleteConfirmation(
                            title: 'Hapus Artikel',
                            content: 'Apakah Anda yakin ingin menghapus artikel "${article.title}"?',
                            onConfirm: () => _deleteArticle(article.id),
                          );
                        },
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

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = image.name;
        });
        _showSnackBar('Gambar "${image.name}" terpilih');
      }
    } catch (e) {
      _showErrorDialog('Gagal mengambil gambar: $e');
    }
  }

  void _showAddArticleSheet({ArticleItem? articleToEdit}) {
    final isEdit = articleToEdit != null;
    
    if (isEdit) {
      _titleCtrl.text = articleToEdit.title;
      _authorCtrl.text = articleToEdit.authorName;
      _themeCtrl.text = articleToEdit.theme;
      _contentCtrl.text = articleToEdit.content;
      _selectedImageBytes = null;
      _selectedImageName = null;
    } else {
      _titleCtrl.clear();
      // Default author to logged in admin's name
      _authorCtrl.text = AuthService.userName ?? '';
      _themeCtrl.clear();
      _contentCtrl.clear();
      _selectedImageBytes = null;
      _selectedImageName = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Edit Artikel' : 'Tambah Artikel Baru',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Title Field
                    _buildTextField(
                      controller: _titleCtrl,
                      label: 'Judul Artikel',
                      hint: 'Masukkan judul artikel',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 14),
                    // Theme Field
                    _buildTextField(
                      controller: _themeCtrl,
                      label: 'Tema/Kategori',
                      hint: 'Misal: Tips Bertani, Info Hama',
                      icon: Icons.category_rounded,
                    ),
                    const SizedBox(height: 14),
                    // Author Field
                    _buildTextField(
                      controller: _authorCtrl,
                      label: 'Nama Penulis',
                      hint: 'Masukkan nama penulis',
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 14),
                    // Content Field
                    _buildTextField(
                      controller: _contentCtrl,
                      label: 'Konten Lengkap',
                      hint: 'Tulis isi artikel di sini...',
                      icon: Icons.article_rounded,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    // Image Picker Section
                    const Text(
                      'Foto/Gambar Artikel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                            if (image != null) {
                              final bytes = await image.readAsBytes();
                              setSheetState(() {
                                _selectedImageBytes = bytes;
                                _selectedImageName = image.name;
                              });
                            }
                          },
                          icon: const Icon(Icons.image_search_rounded, size: 18),
                          label: const Text('Pilih Gambar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: const Color(0xFF7B1FA2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            _selectedImageName ??
                                (isEdit && articleToEdit.imagePath != null
                                    ? 'Gambar saat ini: ${articleToEdit.imagePath!.split('/').last}'
                                    : 'Belum ada gambar terpilih'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Preview Image Bytes if selected
                    if (_selectedImageBytes != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _selectedImageBytes!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleCtrl.text.trim().isEmpty ||
                              _authorCtrl.text.trim().isEmpty ||
                              _themeCtrl.text.trim().isEmpty ||
                              _contentCtrl.text.trim().isEmpty) {
                            _showSnackBar('Semua field teks harus diisi!', isSuccess: false);
                            return;
                          }
                          Navigator.pop(context);
                          _saveArticle(articleToEdit: articleToEdit);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isEdit ? 'Simpan Perubahan' : 'Tambah Artikel',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF7B1FA2)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF7B1FA2)),
            ),
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
        ),
      ],
    );
  }

  Future<void> _saveArticle({ArticleItem? articleToEdit}) async {
    setState(() => _isLoadingArticles = true);
    
    final isEdit = articleToEdit != null;
    String? error;

    if (isEdit) {
      error = await AdminService.updateArticle(
        id: articleToEdit.id,
        title: _titleCtrl.text.trim(),
        authorName: _authorCtrl.text.trim(),
        theme: _themeCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        imageBytes: _selectedImageBytes,
        imageName: _selectedImageName,
      );
    } else {
      error = await AdminService.createArticle(
        title: _titleCtrl.text.trim(),
        authorName: _authorCtrl.text.trim(),
        theme: _themeCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        imageBytes: _selectedImageBytes,
        imageName: _selectedImageName,
      );
    }

    if (error == null) {
      _showSnackBar(isEdit ? 'Artikel berhasil diperbarui' : 'Artikel berhasil ditambahkan');
      _fetchArticles(isSilent: true);
    } else {
      setState(() => _isLoadingArticles = false);
      _showErrorDialog(error);
    }
  }

  Future<void> _deleteArticle(int id) async {
    setState(() => _isLoadingArticles = true);
    final error = await AdminService.deleteArticle(id);
    if (error == null) {
      _showSnackBar('Artikel berhasil dihapus');
      _fetchArticles(isSilent: true);
    } else {
      setState(() => _isLoadingArticles = false);
      _showErrorDialog(error);
    }
  }

  void _showDeleteConfirmation({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1A1A2E)),
          ),
          content: Text(
            content,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
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
        content: Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
