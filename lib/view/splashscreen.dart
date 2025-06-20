import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/worker.dart';
import '../myconfig.dart';
import 'loginscreen.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadWorkerCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9F9), Color(0xFFE35492)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/wtms.png", width: 500, height: 300),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadWorkerCredentials() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    bool remember = prefs.getBool('remember') ?? false;

    if (remember && email.isNotEmpty && password.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse("${MyConfig.myurl}/wtms/wtms/php/login_worker.php"),
          body: {"email": email, "password": password},
        );

        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            Worker worker = Worker.fromJson(jsondata['data'][0]);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen(worker: worker)),
            );
            return;
          }
        }
      } catch (_) {}
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
