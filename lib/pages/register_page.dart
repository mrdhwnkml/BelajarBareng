import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  Future<void> register() async {
    final supabase = Supabase.instance.client;
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
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
      final existingUsername = await supabase
          .from('profiles')
          .select('username')
          .eq('username', usernameController.text.trim())
          .maybeSingle();

      if (existingUsername != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Username sudah digunakan.",
              key: Key("snackbar_message"),
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        return;
      }

      await supabase.from('profiles').insert({
        'id': user.id,
        'username': usernameController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Register berhasil, silakan login",
            key: Key("snackbar_message"),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pop(context, true);
    } on AuthException catch (e) {
      String message;

      if (e.message.toLowerCase().contains("already registered") ||
          e.message.toLowerCase().contains("already")) {
        message = "Email sudah digunakan. Silakan login.";
      } else if (e.message.toLowerCase().contains("password")) {
        message = "Password minimal 6 karakter.";
      } else {
        message = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, key: const Key("snackbar_message")),
          backgroundColor: Colors.red,
        ),
      );
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Username sudah digunakan.",
              key: Key("snackbar_message"),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message, key: const Key("snackbar_message")),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan.", key: Key("snackbar_message")),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    vertical: 35,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF3B82F6),
                        child: Icon(
                          Icons.person_add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Daftar untuk mulai menggunakan aplikasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        key: const Key("register_username"),
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "Masukkan Username",
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.black),
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

                      const SizedBox(height: 10),

                      TextField(
                        key: const Key("register_email"),
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Masukkan Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.black),
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

                      const SizedBox(height: 10),

                      TextField(
                        key: const Key("register_password"),
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Masukkan Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.black),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          key: const Key("register_submit_button"),
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextButton(
                        key: const Key("back_to_login_button"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sudah punya akun? Login",
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.bold,
                          ),
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
