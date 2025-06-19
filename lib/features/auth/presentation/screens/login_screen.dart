import 'package:flutter/material.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../../core/storage/hive_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  final HiveStorage hiveStorage = HiveStorage();
  final AuthRemoteDataSource _authApi = AuthRemoteDataSource();

  @override
  void initState() {
    super.initState();

    if (hiveStorage.isLoggedIn()) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final userId = await _authApi.login(email, password);
    if (!mounted) return;

    if (userId != null) {
      hiveStorage.saveUser(email, userId: userId);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withAlpha((0.75 * 255).toInt())),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Image.asset('assets/images/lordsarena.png', height: 140),
                  const SizedBox(height: 12),
                  const Text(
                    "LORDS ARENA",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    obscure: obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "ENTER THE ARENA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.amber),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.black.withAlpha((0.3 * 255).toInt()),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
