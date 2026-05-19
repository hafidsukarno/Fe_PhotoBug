import 'package:flutter/material.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final String hama;
  final String image;
  final String date;
  final String status;
  final String description;
  final String aiRecommendation;
  final String aiAccuracy;
  final String? penyuluhReply;
  final String? penyuluhName;
  final String? jumlahHama;

  const RiwayatDetailScreen({
    super.key,
    required this.hama,
    required this.image,
    required this.date,
    required this.status,
    required this.description,
    required this.aiRecommendation,
    required this.aiAccuracy,
    this.penyuluhReply,
    this.penyuluhName,
    this.jumlahHama,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isWaiting = status == 'Menunggu';
    final String pestCount = jumlahHama ?? (
      hama.toLowerCase().contains('wereng') ? '15 Ekor' :
      hama.toLowerCase().contains('belalang') ? '8 Ekor' : '12 Ekor'
    );

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
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
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
                    'Detail Laporan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Kanan: Profile Placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
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
              ],
            ),
          ),

          // ========== CONTENT ==========
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainTitleAndStatus(isWaiting),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Hasil Analisis Foto', Icons.photo_camera_front_rounded),
                  const SizedBox(height: 8),
                  
                  // HAMA CARD
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A148C).withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                          ),
                          child: SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image, color: Colors.grey, size: 40),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                        value: double.parse(aiAccuracy.replaceAll('%', '')) / 100,
                                        strokeWidth: 8,
                                        backgroundColor: Colors.grey.shade100,
                                        color: const Color(0xFF7B1FA2),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          aiAccuracy,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF7B1FA2),
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          'Akurasi',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HAMA TERIDENTIFIKASI',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey.shade400,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            hama,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF4A148C),
                                              height: 1.1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFF7B1FA2).withValues(alpha: 0.15),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            pestCount,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF7B1FA2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
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

                  _buildSectionTitle('Informasi Laporan', Icons.info_outline_rounded),
                  const SizedBox(height: 8),
                  
                  // INFO PENANGANAN CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A148C).withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on_rounded, color: Color(0xFF9C27B0), size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Ds. Sukamaju, Kec. Ciawi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: Colors.grey.shade100),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_today_rounded, color: Color(0xFF9C27B0), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal Kirim',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: Colors.grey.shade100),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.assignment_ind_rounded, color: Color(0xFF9C27B0), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Penyuluh Lapangan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isWaiting ? 'Menunggu Konfirmasi' : (penyuluhName ?? 'Pak Irwan'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Rekomendasi Awal AI', Icons.auto_awesome_rounded),
                  const SizedBox(height: 8),
                  
                  // REKOMENDASI AI CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A148C).withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E5F5).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF7B1FA2).withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        aiRecommendation,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Tanggapan Penyuluh', Icons.rate_review_rounded),
                  const SizedBox(height: 8),
                  
                  // BALASAN PENYULUH CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A148C).withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isWaiting ? const Color(0xFFFFF8E1) : const Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (isWaiting ? const Color(0xFFF57C00) : const Color(0xFF7B1FA2))
                              .withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        isWaiting
                            ? 'Laporan Anda sudah diterima dan sedang dalam antrean untuk direspons oleh penyuluh lapangan kami.'
                            : penyuluhReply ?? 'Tidak ada pesan.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildMainTitleAndStatus(bool isWaiting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Laporan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4A148C),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isWaiting ? const Color(0xFFFFF3E0) : const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isWaiting
                      ? const Color(0xFFFFB74D).withValues(alpha: 0.3)
                      : const Color(0xFFBA68C8).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isWaiting ? Icons.hourglass_empty_rounded : Icons.check_circle_outline_rounded,
                    color: isWaiting ? const Color(0xFFE65100) : const Color(0xFF7B1FA2),
                    size: 11,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      color: isWaiting ? const Color(0xFFE65100) : const Color(0xFF7B1FA2),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '•',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_rounded,
              size: 12,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF7B1FA2),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7B1FA2),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildGridInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF4A148C),
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ========== BOTTOM NAV (3 ITEMS - PURPLE THEME) ==========
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Beranda', false, () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.description_rounded, 'Laporan', false, () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.history_rounded, 'Riwayat', true, () {}),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
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
