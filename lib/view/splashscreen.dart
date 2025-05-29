import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/model/worker.dart';
import 'package:wtms/myconfig.dart';
import 'package:wtms/view/profilescreen.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/view/loginscreen.dart';

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
            colors: [
              Color.fromARGB(255, 247, 249, 249),
              Color.fromARGB(255, 227, 84, 146),
             
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/wtms.png",
                width: 500,
                height: 300,
              ),
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
    // so delay splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    bool remember = prefs.getBool('remember') ?? false;

    if (remember && email.isNotEmpty && password.isNotEmpty) {
      http.post(
        Uri.parse("${MyConfig.myurl}/wtms_api/login_worker.php"),
        body: {
          "email": email,
          "password": password,
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            var data = jsondata['data'];
            Worker worker = Worker.fromJson(data);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(worker: worker)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }).catchError((error) {
        // this for if HTTP error, go to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
