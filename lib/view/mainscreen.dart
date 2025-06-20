import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/worker.dart';
import '../myconfig.dart';

import 'loginscreen.dart';
import 'tasklistscreen.dart';
import 'submissionhistoryscreen.dart';
import 'profilescreen.dart';

class MainScreen extends StatefulWidget {
  final Worker worker;
  const MainScreen({super.key, required this.worker});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIdx = 0;

  final Color maroon = const Color(0xFF8E0038);
  final Color lightPink = const Color(0xFFFFF0F2);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    _pages = [
      TaskListScreen(worker: widget.worker),
      SubmissionHistoryScreen(worker: widget.worker),
      ProfileScreen(worker: widget.worker),
    ];
    _titles = ["Assigned Tasks", "Submission records", "My Profile"];
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // ────────── APP BAR ──────────
      appBar: AppBar(
        backgroundColor: maroon,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _titles[_selectedIdx],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ────────── DRAWER ──────────
      drawer: Drawer(
        backgroundColor: lightPink,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                color: maroon,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.grey, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.worker.workerUsername ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.worker.workerEmail ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ────────── MENU ──────────
            _drawerTile(Icons.assignment_turned_in, "Tasks", 0),
            _drawerTile(Icons.history, "History", 1),
            _drawerTile(Icons.person, "My Profile", 2),

            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black54),
              title: const Text("Logout"),
              onTap: _logout,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),

      // ────────── BODY ──────────
      body: _pages[_selectedIdx],
    );
  }

  ListTile _drawerTile(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIdx == index ? maroon : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIdx == index ? maroon : Colors.black87,
          fontWeight:
              _selectedIdx == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIdx == index,
      onTap: () {
        setState(() => _selectedIdx = index);
        Navigator.pop(context);
      },
    );
  }
}
