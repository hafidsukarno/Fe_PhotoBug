import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class LaporanHasilScreen extends StatelessWidget {
  const LaporanHasilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      bottomNavigationBar: _buildBottomNav(context),
      body: Column(
        children: [
          // ========== PREMIUM PURPLE HEADER ==========
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 16),
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
                  offset: Offset(0, 6),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Kiri: Tombol Back
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tengah: Judul
                    const Expanded(
                      child: Text(
                        'Hasil Deteksi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),

                    // Kanan: Profile Dropdown
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
                        width: 40,
                        height: 40,
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
                                size: 20,
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
          ),

          // ========== CONTENT ==========
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Status Info (Moved from header)
                  const Text(
                    'Laporan Terkirim!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI telah menganalisis foto Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      'ID: RPT-2026-0412-049 · 12 Apr 2026',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // HAMA CARD
                  Container(
                    width: double.infinity,
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
                      children: [
                        // Image with Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/gambartest.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(Icons.image,
                                          color: Colors.grey, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF5350),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Hama Terdeteksi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Details
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Circular Progress
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CircularProgressIndicator(
                                        value: 0.94,
                                        strokeWidth: 8,
                                        backgroundColor:
                                            Colors.grey.shade200,
                                        color: const Color(0xFF7B1FA2),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '94%',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF7B1FA2),
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          'Akurasi',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NAMA HAMA TERIDENTIFIKASI',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey.shade400,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Wereng Coklat',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF4A148C),
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Nilaparvata lugens',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF3E0),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Jumlah Hama: 4 Ekor',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFE65100),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Color(0xFFE65100),
                                            size: 14),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'AI Photobug · Akurasi 94%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFFE65100),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // INFO PENANGANAN CARD
                  Container(
                    width: double.infinity,
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
                          'Tujuan Laporan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4A148C),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on_rounded, color: Color(0xFFE53935), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lokasi Terdeteksi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Text(
                                        'Ds. Sukamaju, Kec. Ciawi',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'GPS',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF2E7D32),
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
                        const SizedBox(height: 16),
                        Container(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.support_agent_rounded, color: Color(0xFF1565C0), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Diteruskan ke Penyuluh',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Ahmad Penyuluh',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF7B1FA2), size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // REKOMENDASI CARD
                  Container(
                    width: double.infinity,
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
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                color: Color(0xFF7B1FA2), size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Rekomendasi AI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4A148C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E5F5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF7B1FA2).withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            'Berdasarkan hasil analisis gambar, hama yang menyerang lahan Anda teridentifikasi sebagai Wereng Coklat. Untuk mengendalikan populasi hama ini secara efektif, disarankan agar Anda segera melakukan pengeringan lahan sawah selama 5 hingga 7 hari. Tindakan drainase ini sangat penting untuk memutus siklus hidup hama. Selain itu, Anda perlu mengaplikasikan insektisida berbahan aktif Buprofezin (misal: 25 WP) dengan dosis 1-2 liter per hektar, dengan penyemprotan difokuskan pada bagian pangkal batang padi. Lakukan pemantauan rutin setiap 2 hari sekali dan bersihkan gulma di sekitar pematang untuk menghilangkan sarang alternatif. Untuk musim tanam berikutnya, pertimbangkan menggunakan varietas bibit padi yang lebih tahan hama seperti Inpari 33.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== BOTTOM NAV ==========
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Beranda', false, () => Navigator.pop(context)),
              _buildNavItem(Icons.description_outlined, 'Laporan', true, () {}),
              _buildNavItem(Icons.history_rounded, 'Riwayat', false, () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF7B1FA2)
                  : Colors.grey.shade400,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF7B1FA2)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
