import 'package:flutter/material.dart';

class LaporanDetailPenyuluhScreen extends StatelessWidget {
  final bool isWaiting;

  const LaporanDetailPenyuluhScreen({
    super.key,
    required this.isWaiting,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8), // Light background matching dashboard
      bottomNavigationBar: _buildBottomNav(context),
      body: Column(
        children: [
          _buildHeader(context, topPadding),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainTitleAndStatus(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Informasi Pelapor', Icons.person_pin_rounded),
                  const SizedBox(height: 8),
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Detail Laporan Hama', Icons.analytics_rounded),
                  const SizedBox(height: 8),
                  _buildReportDetailsCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Rekomendasi Penanganan', Icons.rate_review_rounded),
                  const SizedBox(height: 8),
                  _buildActionCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTitleAndStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Laporan Hama',
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
                    isWaiting ? 'PENDING' : 'SELESAI',
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
              '12 Apr 2026',
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

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
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
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 80,
              height: 80,
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
                  'Detail Laporan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              // Kanan: Profile Avatar
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
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/gambartest.png'), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budi Santoso',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4A148C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Petani · @budi_santoso',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF7B1FA2)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Ds. Sukamaju, Kec.\nKarangtengah',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.3,
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
    );
  }

  Widget _buildReportDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                '12 Apr 2026 · 08:47',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Deskripsi
          Text(
            'DESKRIPSI PETANI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '"Daun padi menguning dan terdapat bercak coklat, banyak hama kecil berwarna coklat di batang. Serangan di 3 petak sawah."',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          const SizedBox(height: 20),

          // Foto Laporan & Deteksi
          Text(
            'HASIL DETEKSI HAMA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/gambartest.png', // Placeholder map
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wereng Coklat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jumlah terdeteksi: 15 ekor',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Akurasi: 94%',
                  style: TextStyle(
                    color: Color(0xFF7B1FA2),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          const SizedBox(height: 20),

          // Rekomendasi AI
          Text(
            'REKOMENDASI AI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF7FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Drainase sawah 5-7 hari & semprot Buprofezin 25 WP dosis 1-2 L/ha. Monitor 3 hari sekali.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4A148C),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Color(0xFF7B1FA2), size: 16),
              ),
              const SizedBox(width: 12),
              const Text(
                'Rekomendasi Akhir Penyuluh',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4A148C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Rekomendasi Penanganan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isWaiting ? const Color(0xFFFAFAFA) : const Color(0xFFFBF7FC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isWaiting ? Colors.grey.shade300 : const Color(0xFF7B1FA2).withValues(alpha: 0.15),
              ),
            ),
            child: isWaiting
                ? TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Ketikkan langkah penanganan tambahan untuk petani...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                  )
                : const Text(
                    'Laporan telah diselesaikan. Rekomendasi yang diberikan: Lakukan drainase sawah selama 5-7 hari dan pastikan penyemprotan dilakukan tepat waktu sesuai takaran.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF4A148C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          if (isWaiting) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A148C).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.near_me_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Kirim Rekomendasi ke Petani',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== BOTTOM NAV (SIMPLE) ==========
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
              _buildNavItem(Icons.person_outline_rounded, 'Profil', false, () => Navigator.pop(context)),
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
