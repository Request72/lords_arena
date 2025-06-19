import 'package:flutter/material.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../../core/storage/hive_storage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  final hiveStorage = HiveStorage();
  final _authApi = AuthRemoteDataSource();

  void signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email and password (6+ chars)"),
        ),
      );
      return;
    }

    final userId = await _authApi.signup(email, password);
    if (!mounted) return;

    if (userId != null) {
      hiveStorage.saveUser(email, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Logging in...")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. User may already exist.")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          Container(color: Colors.black.withAlpha((0.7 * 255).toInt())),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Image.asset('assets/images/lordsarena.png', height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    "CREATE YOUR SOLDIER",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 1.2,
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
                    child: ElevatedButton.icon(
                      onPressed: signup,
                      icon: const Icon(Icons.person_add),
                      label: const Text("Create Account"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
