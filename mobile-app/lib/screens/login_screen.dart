import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      print('Form validated, attempting login...');
      final authService = Provider.of<AuthService>(context, listen: false);

      final success = await authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      print('Login result: $success');

      if (success && mounted) {
        print('Login successful, navigating to home...');
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        print('Login failed, showing error message');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background with radial effect (matching signup)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.5,
                colors: [
                  Color(0xFFE0F2FE), // Light blue
                  Color(0xFFF0FDFA), // Light teal
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Decorative blur circles (matching signup)
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                color: const Color(0xFFFBCFE8).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(),
              ),
            ),
          ),

          // Main Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 60,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),

                          // Drag Handle
                          Center(
                            child: Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Title
                          const Text(
                            'Welcome to Kidflavor!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          const Text(
                            'Where fun begins! Log in to continue.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Username Field
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _usernameController,
                            hintText: 'nguyenvana123',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên đăng nhập';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),

                          // Password Field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: '••••••••',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: const Color(0xFF8B8B8B),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle forgot password
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1EB5D9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Login Button
                          GradientButton(
                            text: 'Log In',
                            isLoading: authService.isLoading,
                            onPressed: _handleLogin,
                          ),
                          const SizedBox(height: 30),

                          // Divider with text
                          const Row(
                            children: [
                              Expanded(
                                  child: Divider(color: Color(0xFFE0E0E0))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8B8B8B),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Divider(color: Color(0xFFE0E0E0))),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialLoginButton(
                                icon: Icons.g_mobiledata_rounded,
                                backgroundColor: const Color(0xFFF5F5F5),
                                iconColor: const Color(0xFF4285F4),
                                onPressed: () {
                                  // TODO: Handle Google login
                                },
                              ),
                              const SizedBox(width: 20),
                              SocialLoginButton(
                                icon: Icons.apple_rounded,
                                backgroundColor: const Color(0xFF2D2D2D),
                                iconColor: Colors.white,
                                onPressed: () {
                                  // TODO: Handle Apple login
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8B8B8B),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1EB5D9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
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
}

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF2D2D2D),
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFB8B8B8),
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
    );
  }
}

// Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1EB5D9), // Cyan
            Color(0xFF4DD0E1), // Light cyan
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1EB5D9).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Social Login Button Widget
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
