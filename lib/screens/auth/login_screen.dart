import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/auth/register_screen.dart';
import 'package:fe_photobug/screens/petani/petani_dashboard_screen.dart';
import 'package:fe_photobug/screens/penyuluh/penyuluh_dashboard_screen.dart';
import 'package:fe_photobug/screens/admin/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
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
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan kata sandi harus diisi!', Colors.red);
      return;
    }

    Widget? destination;

    if (email == 'petani@gmail.com') {
      destination = const PetaniDashboardScreen();
    } else if (email == 'penyuluh@gmail.com') {
      destination = const PenyuluhDashboardScreen();
    } else if (email == 'admin@gmail.com') {
      destination = const AdminDashboardScreen();
    }

    if (destination != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => destination!,
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      _showSnackBar('Email tidak terdaftar!', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: Column(
        children: [
          // ========== HEADER (proportional) ==========
          _buildHeader(screenHeight, topPadding),

          // ========== FORM BODY (fills remaining space) ==========
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight * 0.62,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bottom: Form fields
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.032),
                            // Greeting
                            const Text(
                              'Selamat Datang 👋',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4A148C),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Masuk ke akun Anda',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 14),
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
                                    Icons.info_outline_rounded,
                                    color: Color(0xFF7B1FA2),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Gunakan akun terdaftar untuk memantau dan melaporkan serangan hama wereng di sawah Anda.',
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
                            SizedBox(height: screenHeight * 0.032),

                            // Email Field
                            _buildLabel('Email'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'budi_santoso@gmail.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: screenHeight * 0.025),

                            // Password Field
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
                            const SizedBox(height: 10),

                            // Lupa Kata Sandi
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Navigate to forgot password
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Lupa Kata Sandi?',
                                  style: TextStyle(
                                    color: Color(0xFF7B1FA2),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Bottom: Button + Register link
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 20,
                          ),
                          child: Column(
                            children: [
                              // Masuk Button
                              _buildPrimaryButton(
                                label: 'Masuk',
                                onPressed: () {
                                  _handleLogin();
                                },
                              ),
                              const SizedBox(height: 20),

                              // Register link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun? ',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              const RegisterScreen(),
                                          transitionsBuilder:
                                              (_, anim, __, child) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                parent: anim,
                                                curve: Curves.easeOutCubic,
                                              )),
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Daftar Sekarang',
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

  // ========== IMPROVED HEADER ==========
  Widget _buildHeader(double screenHeight, double topPadding) {
    final headerHeight = screenHeight * 0.34;

    return Container(
      width: double.infinity,
      height: headerHeight,
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
          // Decorative circles
          Positioned(
            top: -30,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 20,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Decorative leaf shapes
          Positioned(
            bottom: 50,
            left: 20,
            child: Transform.rotate(
              angle: -0.3,
              child: Icon(
                Icons.eco_outlined,
                color: Colors.white.withValues(alpha: 0.07),
                size: 50,
              ),
            ),
          ),
          Positioned(
            top: topPadding + 40,
            right: 25,
            child: Transform.rotate(
              angle: 0.5,
              child: Icon(
                Icons.eco_outlined,
                color: Colors.white.withValues(alpha: 0.06),
                size: 35,
              ),
            ),
          ),

          // Main content centered
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding * 0.5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with glow effect
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Photobug',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Sistem Pelaporan Hama Wereng',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B1FA2),
          foregroundColor: Colors.white,
          elevation: 6,
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
    );
  }
}
