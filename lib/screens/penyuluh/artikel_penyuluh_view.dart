import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../services/penyuluh_service.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../utils/dialog_utils.dart';

class ArtikelPenyuluhView extends StatefulWidget {
  final double topPadding;

  const ArtikelPenyuluhView({super.key, required this.topPadding});

  @override
  State<ArtikelPenyuluhView> createState() => ArtikelPenyuluhViewState();
}

class ArtikelPenyuluhViewState extends State<ArtikelPenyuluhView> {
  List<ArticleItem> _articlesList = [];
  List<ArticleItem> _filteredList = [];
  bool _isLoading = true;
  final TextEditingController _searchCtrl = TextEditingController();

  // Controllers for Add/Edit Form
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _authorCtrl = TextEditingController();
  final TextEditingController _themeCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _themeCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchArticles({bool isSilent = false}) async {
    if (!isSilent || _articlesList.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    final articles = await PenyuluhService.getArticles();

    if (mounted) {
      setState(() {
        _articlesList = articles;
        _filteredList = articles;
        _isLoading = false;
      });
    }
  }

  void silentRefresh() {
    _fetchArticles(isSilent: true);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredList = _articlesList.where((article) {
        final matchesTitle = article.title.toLowerCase().contains(query);
        final matchesTheme = article.theme.toLowerCase().contains(query);
        return matchesTitle || matchesTheme;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7B1FA2),
                    ),
                  )
                : _buildArticlesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddArticleSheet(),
        backgroundColor: const Color(0xFF7B1FA2),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
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
            color: Color(0x224A148C),
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
            'Edukasi & Artikel',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelola artikel edukasi dan tips pengendalian hama',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          // Search Field
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari artikel atau tema...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF7B1FA2),
                  size: 20,
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        color: Colors.grey.shade400,
                        onPressed: () {
                          _searchCtrl.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    if (_filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 54, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Belum ada artikel ditemukan',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchArticles(isSilent: true),
      color: const Color(0xFF7B1FA2),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) {
          final article = _filteredList[index];
          return _buildArticleCard(article);
        },
      ),
    );
  }

  Widget _buildArticleCard(ArticleItem article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showArticleDetail(article),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  child: Container(
                    width: 100,
                    height: 115,
                    color: Colors.grey.shade50,
                    child: article.imageUrl != null
                        ? Image.network(
                            article.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey.shade100,
                              child: Icon(Icons.broken_image_rounded, color: Colors.grey.shade400, size: 28),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: Icon(Icons.image_rounded, color: Colors.grey.shade400, size: 28),
                          ),
                  ),
                ),
                // Info Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Theme Tag & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3E5F5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                article.theme,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7B1FA2),
                                ),
                              ),
                            ),
                            Text(
                              _formatDateString(article.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Author
                        Text(
                          'Penulis: ${article.authorName}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Actions Column
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: Colors.grey.shade500,
                        onPressed: () => _showAddArticleSheet(articleToEdit: article),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        color: Colors.red.shade400,
                        onPressed: () => _confirmDeleteArticle(article),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showArticleDetail(ArticleItem article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  children: [
                    if (article.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          article.imageUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.image_rounded, size: 48, color: Colors.grey),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.theme,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7B1FA2),
                            ),
                          ),
                        ),
                        Text(
                          _formatDateString(article.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Oleh: ${article.authorName}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF424242),
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddArticleSheet({ArticleItem? articleToEdit}) {
    final isEdit = articleToEdit != null;
    
    if (isEdit) {
      _titleCtrl.text = articleToEdit.title;
      _authorCtrl.text = articleToEdit.authorName;
      _themeCtrl.text = articleToEdit.theme;
      _contentCtrl.text = articleToEdit.content;
    } else {
      _titleCtrl.clear();
      _authorCtrl.text = AuthService.userName ?? '';
      _themeCtrl.clear();
      _contentCtrl.clear();
    }
    
    _selectedImageBytes = null;
    _selectedImageName = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage() async {
              try {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (image != null) {
                  final bytes = await image.readAsBytes();
                  setModalState(() {
                    _selectedImageBytes = bytes;
                    _selectedImageName = image.name;
                  });
                }
              } catch (e) {
                _showErrorDialog(context, 'Gagal mengambil gambar: $e');
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      children: [
                        Text(
                          isEdit ? 'Edit Artikel' : 'Tambah Artikel Baru',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Title Form Field
                        _buildLabel('Judul Artikel'),
                        _buildTextField(_titleCtrl, 'Masukkan judul artikel'),
                        
                        // Author Form Field
                        _buildLabel('Penulis'),
                        _buildTextField(_authorCtrl, 'Masukkan nama penulis'),
                        
                        // Theme/Category Form Field
                        _buildLabel('Tema / Kategori'),
                        _buildTextField(_themeCtrl, 'Contoh: Hama Wereng, Tips Tanaman'),
                        
                        // Content Form Field
                        _buildLabel('Konten / Isi Artikel'),
                        _buildTextField(_contentCtrl, 'Tulis konten artikel di sini...', maxLines: 6),
                        
                        // Image Upload Block
                        _buildLabel('Gambar Cover Artikel'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                            ),
                            child: _selectedImageBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                                        Container(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          child: const Center(
                                            child: Icon(Icons.cached_rounded, color: Colors.white, size: 28),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : isEdit && articleToEdit.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(articleToEdit.imageUrl!, fit: BoxFit.cover),
                                            Container(
                                              color: Colors.black.withValues(alpha: 0.3),
                                              child: const Center(
                                                child: Icon(Icons.cached_rounded, color: Colors.white, size: 28),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey.shade400),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Pilih File Gambar',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        if (_selectedImageName != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Terpilih: $_selectedImageName',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                          ),
                        ],
                        const SizedBox(height: 32),
                        
                        // Submit Button
                        ElevatedButton(
                          onPressed: _isSubmitting 
                              ? null 
                              : () => _handleSubmitArticle(articleToEdit, setModalState),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B1FA2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  isEdit ? 'Simpan Perubahan' : 'Terbitkan Artikel',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                        ),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF1A1A2E),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleSubmitArticle(ArticleItem? articleToEdit, StateSetter setModalState) async {
    final title = _titleCtrl.text.trim();
    final author = _authorCtrl.text.trim();
    final theme = _themeCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (title.isEmpty || author.isEmpty || theme.isEmpty || content.isEmpty) {
      _showErrorDialog(context, 'Semua kolom form harus diisi lengkap!');
      return;
    }

    setModalState(() => _isSubmitting = true);

    String? errorMsg;
    if (articleToEdit != null) {
      errorMsg = await PenyuluhService.updateArticle(
        id: articleToEdit.id,
        title: title,
        authorName: author,
        theme: theme,
        content: content,
        imageBytes: _selectedImageBytes,
        imageName: _selectedImageName,
      );
    } else {
      errorMsg = await PenyuluhService.createArticle(
        title: title,
        authorName: author,
        theme: theme,
        content: content,
        imageBytes: _selectedImageBytes,
        imageName: _selectedImageName,
      );
    }

    if (mounted) {
      setModalState(() => _isSubmitting = false);
      if (errorMsg != null) {
        _showErrorDialog(context, errorMsg);
      } else {
        Navigator.pop(context); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(articleToEdit != null 
                ? 'Artikel berhasil diperbarui' 
                : 'Artikel berhasil diterbitkan'),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _fetchArticles(isSilent: true);
      }
    }
  }

  void _confirmDeleteArticle(ArticleItem article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Hapus Artikel',
          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus artikel "${article.title}"?',
          style: const TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              setState(() => _isLoading = true);
              final errorMsg = await PenyuluhService.deleteArticle(article.id);
              if (mounted) {
                setState(() => _isLoading = false);
                if (errorMsg != null) {
                  _showErrorDialog(context, errorMsg);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Artikel berhasil dihapus'),
                      backgroundColor: const Color(0xFFC62828),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  _fetchArticles(isSilent: true);
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}
