import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // ========== GREEN HEADER ==========
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF66BB6A),
                Color(0xFF43A047),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x332E7D32),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40, height: 40), // Spacer for balance
              
              // Tengah: Judul
              const Expanded(
                child: Text(
                  'Profil Saya',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              // Kanan: Empty Spacer
              const SizedBox(width: 40, height: 40),
            ],
          ),
        ),

        // ========== BODY ==========
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profil Info Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/gambartest.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Budi Santoso',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1B3A1B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@budi_santoso',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Banner Card (Petani Terverifikasi)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF66BB6A),
                        Color(0xFF388E3C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF388E3C).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Petani Terverifikasi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Nikmati layanan prioritas AI',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 3. Section Title
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Pengaturan Akun',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Settings List Container
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildListItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Informasi Akun',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildListItem(
                        icon: Icons.key_outlined,
                        title: 'Ubah Kata Sandi',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildListItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifikasi',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildListItem(
                        icon: Icons.logout_rounded,
                        title: 'Keluar',
                        isDestructive: true,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Footer
                Center(
                  child: Text(
                    'Photobug v2.1.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final color = isDestructive ? Colors.red.shade600 : const Color(0xFF1B3A1B);
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: color.withValues(alpha: 0.8),
              size: 24,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        color: Colors.grey.shade100,
        height: 1,
        thickness: 1,
      ),
    );
  }
}
