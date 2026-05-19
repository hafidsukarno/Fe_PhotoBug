import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _desaController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _desaController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: Column(
        children: [
          // ========== HEADER ==========
          _buildHeader(context, topPadding),

          // ========== FORM BODY ==========
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight * 0.78,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top: Form fields
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.024),

                              // Info paragraph
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B1FA2).withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.eco_rounded,
                                      color: Color(0xFF7B1FA2),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Daftar untuk mulai memantau, melaporkan, dan mengelola serangan hama wereng di area persawahan Anda.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color(0xFF4A148C).withValues(alpha: 0.8),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.024),

                              // Username
                              _buildLabel('Username'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _usernameController,
                              hint: 'budi_santoso',
                              icon: Icons.alternate_email_rounded,
                            ),
                            SizedBox(height: screenHeight * 0.022),

                            // Email
                            _buildLabel('Email'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'budi_santoso@gmail.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: screenHeight * 0.022),

                            // Password
                            _buildLabel('Kata Sandi'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _passwordController,
                              hint: '••••••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade500,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.022),

                            // Desa / Kelurahan
                            _buildLabel('Desa / Kelurahan'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _desaController,
                              hint: 'Desa Hergamanah',
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                'Desa yang terdaftar dalam sistem Photobug',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.022),

                            // Terms & Conditions
                            _buildTermsCheckbox(),
                          ],
                        ),

                        // Bottom: Button + Login link
                        Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).padding.bottom + 20,
                            top: 16,
                          ),
                          child: Column(
                            children: [
                              _buildPrimaryButton(
                                label: 'Buat Akun Sekarang',
                                onPressed: _agreeTerms
                                    ? () {
                                        // TODO: Handle register
                                      }
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // Login link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Color(0xFF7B1FA2),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== HEADER WITH DECORATIVE ELEMENTS ==========
  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 14, 20, 22),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A148C),
            Color(0xFF7B1FA2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x444A148C),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A148C),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1BEE7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B1FA2).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A148C),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF9C27B0), size: 22),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _agreeTerms = !_agreeTerms;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: _agreeTerms ? const Color(0xFF7B1FA2) : Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: _agreeTerms
                    ? const Color(0xFF7B1FA2)
                    : const Color(0xFFE1BEE7),
                width: 2,
              ),
            ),
            child: _agreeTerms
                ? const Icon(Icons.check_rounded,
                    size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4A4A4A),
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Saya menyetujui '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' Photobug'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.5,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
            elevation: isEnabled ? 6 : 0,
            shadowColor: const Color(0xFF7B1FA2).withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
