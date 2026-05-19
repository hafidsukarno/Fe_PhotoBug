import 'package:flutter/material.dart';

class DetailLaporanAdminScreen extends StatelessWidget {
  final String hama;
  final String image;
  final String tanggal;
  final String status;
  final String petani;
  final String desa;
  final String akurasi;
  final String penyuluh;

  const DetailLaporanAdminScreen({
    super.key,
    required this.hama,
    required this.image,
    required this.tanggal,
    required this.status,
    required this.petani,
    required this.desa,
    required this.akurasi,
    required this.penyuluh,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isPending = status == 'Pending';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: Column(
        children: [
          // ========== PURPLE HEADER ==========
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x444A148C),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
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

                // Title
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

                // Admin icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 20,
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
                children: [
                  // Status & Tanggal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPending
                              ? Colors.orange.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPending
                                ? Colors.orange.shade200
                                : Colors.green.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPending
                                  ? Icons.hourglass_empty_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: isPending
                                  ? Colors.orange.shade800
                                  : Colors.green.shade800,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                color: isPending
                                    ? Colors.orange.shade800
                                    : Colors.green.shade800,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        tanggal,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ===== HAMA CARD =====
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
                                  image,
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
                                  color: isPending
                                      ? const Color(0xFFF57C00)
                                      : const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPending
                                          ? Icons.hourglass_top_rounded
                                          : Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      status,
                                      style: const TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Circular AI accuracy
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
                                        value: double.parse(
                                                akurasi.replaceAll('%', '')) /
                                            100,
                                        strokeWidth: 8,
                                        backgroundColor: Colors.grey.shade200,
                                        color: const Color(0xFF7B1FA2),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          akurasi,
                                          style: const TextStyle(
                                            fontSize: 18,
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
                                    Text(
                                      hama,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A1A2E),
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Dilaporkan oleh $petani',
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
                  const SizedBox(height: 16),

                  // ===== INFO LAPORAN CARD =====
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
                          'Info Laporan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Petani
                        _buildInfoRow(
                          icon: Icons.person_rounded,
                          iconColor: const Color(0xFF7B1FA2),
                          label: 'Petani',
                          value: petani,
                        ),
                        const SizedBox(height: 14),
                        Container(height: 1, color: Colors.grey.shade100),
                        const SizedBox(height: 14),

                        // Lokasi
                        _buildInfoRow(
                          icon: Icons.location_on_rounded,
                          iconColor: const Color(0xFFE53935),
                          label: 'Lokasi',
                          value: desa,
                        ),
                        const SizedBox(height: 14),
                        Container(height: 1, color: Colors.grey.shade100),
                        const SizedBox(height: 14),

                        // Penyuluh
                        _buildInfoRow(
                          icon: Icons.support_agent_rounded,
                          iconColor: const Color(0xFF1565C0),
                          label: 'Penyuluh Bertugas',
                          value: penyuluh,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== REKOMENDASI AI CARD =====
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
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: Color(0xFFE65100), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Rekomendasi Awal AI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
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
                              color: const Color(0xFF7B1FA2)
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            'Berdasarkan analisis gambar, terdeteksi serangan $hama. '
                            'Disarankan untuk segera melakukan pemantauan lapangan dan '
                            'berkoordinasi dengan penyuluh untuk penanganan lebih lanjut. '
                            'Pantau kondisi tanaman setiap 2 hari sekali.',
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
                  const SizedBox(height: 16),

                  // ===== STATUS BALASAN CARD =====
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
                            Icon(
                              isPending
                                  ? Icons.access_time_rounded
                                  : Icons.chat_bubble_rounded,
                              color: isPending
                                  ? const Color(0xFFF57C00)
                                  : const Color(0xFF2E7D32),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isPending
                                  ? 'Menunggu Respons'
                                  : 'Instruksi Penyuluh',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isPending
                                ? const Color(0xFFFFF8E1)
                                : const Color(0xFFF1F8F1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (isPending
                                      ? const Color(0xFFF57C00)
                                      : const Color(0xFF2E7D32))
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            isPending
                                ? 'Laporan telah diterima dan sedang dalam antrean untuk direspons oleh $penyuluh.'
                                : 'Segera lakukan penyemprotan insektisida yang sesuai pada waktu pagi hari. '
                                    'Ulangi setiap 5 hari dan pantau perkembangan populasi hama.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
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
    );
  }
}
