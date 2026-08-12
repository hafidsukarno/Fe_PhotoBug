import 'package:flutter/material.dart';
import 'package:fe_photobug/services/detection_service.dart';

class RiwayatDetailScreen extends StatefulWidget {
  final int detectionId;

  const RiwayatDetailScreen({
    super.key,
    required this.detectionId,
  });

  @override
  State<RiwayatDetailScreen> createState() => _RiwayatDetailScreenState();
}

class _RiwayatDetailScreenState extends State<RiwayatDetailScreen> {
  Future<DetectionResponse>? _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = DetectionService.getDetectionDetail(widget.detectionId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetectionResponse>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F4F8),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2))),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.success) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F4F8),
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text(
                snapshot.error?.toString() ?? snapshot.data?.message ?? 'Gagal memuat detail',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final detection = snapshot.data!.detection!;
        final penyuluhName = snapshot.data!.penyuluhName ?? 'Penyuluh';
        final totalPests = snapshot.data!.totalPests ?? 0;

        // Map data
        final hama = detection.getHighestConfidenceResult()?.pestName ?? 'Tidak Terdeteksi';
        final image = 'http://127.0.0.1:8000/api/image/${detection.imagePath}';
        
        final date = _formatDate(detection.detectedAt);
        final status = detection.status == 'pending' ? 'Menunggu' : 'Selesai';
        final description = detection.description.isNotEmpty ? detection.description : 'Tidak ada deskripsi';
        
        String aiRecText = 'Belum ada rekomendasi';
        String? penyuluhRecText;
        
        for (var rec in detection.recommendations) {
          if (rec.source.toLowerCase() == 'ai') {
            aiRecText = rec.recommendationText;
          } else if (rec.source.toLowerCase() == 'penyuluh') {
            penyuluhRecText = rec.recommendationText;
          }
        }
        
        final aiRecommendation = aiRecText;
        final aiAccuracy = '${detection.getHighestConfidenceResult()?.getConfidencePercent() ?? 0}%';
        
        final penyuluhReply = detection.status == 'pending' 
            ? null 
            : (penyuluhRecText ?? 'Laporan telah ditindaklanjuti. Silakan ikuti rekomendasi penanganan.');
        
        final jumlahHama = '$totalPests Ekor';

        final topPadding = MediaQuery.of(context).padding.top;
        final isWaiting = status == 'Menunggu';

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
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24,
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
                      _buildMainTitleAndStatus(isWaiting, status, date),
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
                                child: Image.network(
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
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFF3E0),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'Jumlah: $jumlahHama',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFFE65100),
                                                ),
                                              ),
                                            ),
                                            if (detection.ricePhase != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE1F5FE),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Fase: ${_getDisplayRicePhase(detection.ricePhase)}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0288D1),
                                                  ),
                                                ),
                                              ),
                                            if (detection.hazardLevel != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getHazardColor(detection.hazardLevel).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Status: ${detection.hazardLevel!.toUpperCase()}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: _getHazardColor(detection.hazardLevel),
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
                            // Lokasi Desa Binaan
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.home_work_rounded, color: Color(0xFF9C27B0), size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Lokasi Desa Binaan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        detection.villageName ?? 'Tidak Diketahui',
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
                                        'Lokasi',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              detection.gpsAddress != null && detection.gpsAddress!.isNotEmpty
                                                  ? detection.gpsAddress!
                                                  : (detection.villageName != null ? 'Ds. ${detection.villageName}' : 'Lokasi Tidak Diketahui'),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF2C3E50),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (detection.latitude != null && detection.longitude != null) ...[
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
                                        ],
                                      ),
                                      if (detection.latitude != null && detection.longitude != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Koordinat: ${detection.latitude}, ${detection.longitude}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
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
                                        isWaiting ? 'Menunggu Konfirmasi' : penyuluhName,
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

                      _buildSectionTitle('Rekomendasi Awal Penanganan', Icons.auto_awesome_rounded),
                      const SizedBox(height: 8),
                      
                      // REKOMENDASI PENANGANAN CARD
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
      },
    );
  }

  Widget _buildMainTitleAndStatus(bool isWaiting, String status, String date) {
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
                Navigator.popUntil(context, (route) => route.isFirst);
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

  String _formatDate(DateTime date) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getHazardColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'tidak bahaya':
        return const Color(0xFF2E7D32);
      case 'bahaya':
        return const Color(0xFFE65100);
      case 'sangat bahaya':
        return const Color(0xFFC62828);
      default:
        return Colors.grey.shade600;
    }
  }

  String _getDisplayRicePhase(String? phase) {
    switch (phase?.toLowerCase()) {
      case 'vegetatif':
        return 'Vegetatif (< 40 HST)';
      case 'generatif':
        return 'Generatif (~40-60 HST)';
      case 'pematangan':
        return 'Pematangan (~60-90+ HST)';
      default:
        return phase ?? '-';
    }
  }
}
