import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/petani/laporan_hasil_screen.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  bool _hasImage = false;
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Column(
      children: [
        // Premium Header
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
                              Icons.camera_enhance_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deteksi Real-Time',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Text(
                                'Laporan Hama',
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
                ],
              ),
            ],
          ),
        ),

        // Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle moved from header
                const Text(
                  'Buat Laporan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4A148C),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Foto & deskripsikan hama yang ditemukan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Image Upload Section
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasImage = !_hasImage;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _hasImage
                          ? null
                          : Border.all(
                              color: const Color(0xFF7B1FA2).withValues(alpha: 0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: _hasImage
                          ? const DecorationImage(
                              image: AssetImage('assets/images/gambartest.png'),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _hasImage
                        ? Stack(
                            children: [
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B1FA2)
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Color(0xFF7B1FA2),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Sentuh untuk Ambil / Pilih Foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Format: PNG, JPG, JPEG, WEBP',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location Field
                      const Text(
                        'Lokasi Sawah',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFFE53935),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Ds. Sukamaju, Kec. Ciawi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'GPS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.check_rounded,
                                      size: 12, color: Color(0xFF2E7D32)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description Field
                      const Text(
                        'Deskripsi Kerusakan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descController,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C3E50),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Contoh: Daun padi banyak yang menguning kecoklatan, terdapat serangga kecil berwarna coklat di batang padi bagian bawah...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFF7B1FA2), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B1FA2).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LaporanHasilScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Deteksi dan Kirim Laporan ke Penyuluh',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
