import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Animation controllers for floating effect
  late AnimationController _robotController;
  late AnimationController _rocketController;
  late AnimationController _puzzleController;

  // Animations for floating movement
  late Animation<double> _robotAnimation;
  late Animation<double> _rocketAnimation;
  late Animation<double> _puzzleAnimation;

  @override
  void initState() {
    super.initState();

    // Robot animation - 2 seconds, 6px amplitude (reduced)
    _robotController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _robotAnimation = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(
      parent: _robotController,
      curve: Curves.easeInOut,
    ));
    _robotController.repeat(reverse: true);

    // Rocket animation - 2.5 seconds, 10px amplitude, delayed start
    _rocketController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _rocketAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _rocketController,
      curve: Curves.easeInOut,
    ));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _rocketController.repeat(reverse: true);
      }
    });

    // Puzzle animation - 3 seconds, 15px amplitude, delayed start
    _puzzleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _puzzleAnimation = Tween<double>(
      begin: -15.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _puzzleController,
      curve: Curves.easeInOut,
    ));
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _puzzleController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _robotController.dispose();
    _rocketController.dispose();
    _puzzleController.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF0F0), // Light pink
                  Color(0xFFE8F4F8), // Light blue
                ],
              ),
            ),
          ),

          // Decorative Icons - Balanced Visual Cluster
          // Robot bubble (Primary - Main focus)
          Positioned(
            top: screenHeight * 0.07,
            left: screenWidth * 0.15,
            child: _buildAnimatedIcon(
              _robotAnimation,
              Icons.smart_toy_rounded,
              const Color(0xFFD4820E),
              105,
              55,
            ),
          ),
          // Rocket bubble (Secondary 1 - Balance right)
          Positioned(
            top: screenHeight * 0.10,
            right: screenWidth * 0.15,
            child: _buildAnimatedIcon(
              _rocketAnimation,
              Icons.rocket_launch_rounded,
              const Color(0xFF4FB3E3),
              85,
              45,
            ),
          ),
          // Puzzle bubble (Secondary 2 - Center bottom, creates triangle)
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: _buildAnimatedIcon(
                _puzzleAnimation,
                Icons.extension_rounded,
                const Color(0xFFFA8989),
                75,
                40,
              ),
            ),
          ),

          // Main Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Title
                      const Text(
                        'Welcome to ToyWorld!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'Where fun begins! Log in to continue.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8B8B8B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Email/Username Field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _usernameController,
                        hintText: 'parent@example.com',
                        keyboardType: TextInputType.emailAddress,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
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
                          Expanded(child: Divider(color: Color(0xFFE0E0E0))),
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
                          Expanded(child: Divider(color: Color(0xFFE0E0E0))),
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
                              // TODO: Navigate to signup
                            },
                            child: const Text(
                              'Signup',
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
        ],
      ),
    );
  }

  // Animated wrapper for floating effect
  Widget _buildAnimatedIcon(
    Animation<double> animation,
    IconData icon,
    Color color,
    double bubbleSize,
    double iconSize,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: _buildFloatingIcon(icon, color, bubbleSize, iconSize),
    );
  }

  Widget _buildFloatingIcon(
    IconData icon,
    Color color,
    double bubbleSize,
    double iconSize,
  ) {
    return Container(
      width: bubbleSize,
      height: bubbleSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        shape: BoxShape.circle,
        boxShadow: [
          // Soft floating shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
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
