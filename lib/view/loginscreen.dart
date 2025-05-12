import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/worker.dart';
import '../myconfig.dart';
import 'profilescreen.dart';
import 'registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isChecked = false;

  static const Color mainColor = Color(0xFF8E0038);
  static const Color gradientTop = Color(0xFFD81B60);
  static const Color gradientBottom = Color(0xFFF8EAF6);
  static const Color cardColor = Color(0xFFFDF3F6);

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientTop, gradientBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/wtms.png",
                  height: 100, // logo kecil
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Login to keep manage your task",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                buildLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            buildTextField(
              controller: emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: passwordController,
              label: "Password",
              icon: Icons.lock_outline,
              obscure: true,
            ),
            const SizedBox(height: 12),
            buildRememberMe(),
            const SizedBox(height: 20),
            buildStyledLoginButton(),
            const SizedBox(height: 14),
            buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: mainColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() => isChecked = value!);
            storeCredentials(
              emailController.text,
              passwordController.text,
              isChecked,
            );
          },
          activeColor: mainColor,
        ),
        const Text("Remember Me"),
      ],
    );
  }

  Widget buildStyledLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: loginUser,
        icon: const Icon(Icons.login, color: Colors.white),
        label: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 5,
          shadowColor: Colors.black45,
        ),
      ),
    );
  }

  Widget buildBottomActions() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Add Forgot Password navigation
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: const Text(
            "New user? Register →",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Please fill all fields", isError: true);
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("${MyConfig.myurl}/wtms/wtms/php/login_worker.php"),
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          Worker worker = Worker.fromJson(data['data'][0]);
          showMessage("Welcome ${worker.workerName}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen(worker: worker)),
          );
        } else {
          showMessage("Login failed. Please check your email/password.", isError: true);
        }
      } else {
        showMessage("Server error: ${response.statusCode}", isError: true);
      }
    } catch (e) {
      showMessage("Error: $e", isError: true);
    }
  }

  void showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : const Color.fromARGB(255, 175, 78, 76),
      ),
    );
  }

  Future<void> storeCredentials(String email, String password, bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('remember', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('pass');
      await prefs.remove('remember');
    }
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? "";
      passwordController.text = prefs.getString('pass') ?? "";
      isChecked = prefs.getBool('remember') ?? false;
    });
  }
}
