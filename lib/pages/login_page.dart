import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semua field wajib diisi.",
            key: Key("snackbar_message"),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil", key: Key("success_message")),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on AuthException catch (e) {
      String message;

      if (e.message.toLowerCase().contains("invalid login credentials")) {
        message = "Email atau password yang Anda masukkan salah.";
      } else if (e.message.toLowerCase().contains("email not confirmed")) {
        message = "Silakan verifikasi email Anda terlebih dahulu.";
      } else {
        message = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, key: const Key("snackbar_message")),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Terjadi kesalahan. Silakan coba lagi.",
            key: Key("snackbar_message"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [Color(0xFF3B82F6), Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Card(
                elevation: 15,

                shadowColor: Colors.black26,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // Logo
                      Transform.translate(
                        offset: const Offset(0, -5),

                        child: Image.asset(
                          'assets/images/poop.png',
                          width: 180,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Transform.translate(
                        offset: const Offset(0, -30),

                        child: Column(
                          children: [
                            const Text(
                              "Belajar Bareng",

                              style: TextStyle(
                                fontSize: 28,

                                fontWeight: FontWeight.bold,

                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Email
                            Semantics(
                              identifier: 'email_input',
                              child: TextField(
                                key: const Key("login_email"),
                                controller: emailController,

                                decoration: InputDecoration(
                                  hintText: "Masukkan Email",

                                  prefixIcon: const Icon(Icons.email_outlined),

                                  filled: true,

                                  fillColor: Colors.white,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),

                                    borderSide: const BorderSide(
                                      color: Colors.black,

                                      width: 1.2,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),

                                    borderSide: const BorderSide(
                                      color: Color(0xFF3B82F6),

                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Password
                            Semantics(
                              identifier: 'password_input',
                              child: TextField(
                                key: const Key("login_password"),
                                controller: passwordController,

                                //obscureText: true,
                                obscureText: _obscurePassword,

                                decoration: InputDecoration(
                                  hintText: "Masukkan Password",

                                  prefixIcon: const Icon(Icons.lock_outline),

                                  suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                         onPressed: () {
                                    setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),

                                  filled: true,

                                  fillColor: Colors.white,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),

                                    borderSide: const BorderSide(
                                      color: Colors.black,

                                      width: 1.2,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),

                                    borderSide: const BorderSide(
                                      color: Color(0xFF3B82F6),

                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Login Button
                            SizedBox(
                              width: double.infinity,

                              height: 55,

                              child: ElevatedButton(
                                key: const Key("login_button"),
                                onPressed: login,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),

                                  foregroundColor: Colors.white,

                                  elevation: 8,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),

                                child: const Text(
                                  "Login",

                                  style: TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextButton(
                              key: const Key("register_button"),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },

                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black87),

                                  children: [
                                    TextSpan(text: "Belum punya akun? "),

                                    TextSpan(
                                      text: "Register",

                                      style: TextStyle(
                                        color: Color(0xFF3B82F6),

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
