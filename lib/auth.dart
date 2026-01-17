import 'package:avodha_interview_test/view/authPages/login_page.dart';
import 'package:avodha_interview_test/view/pages/homepage/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  static const String sessionBoxName = 'sessionBox';

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sessionBox = Hive.box(sessionBoxName);
    final email = sessionBox.get('email');

    if (!mounted) return;

    if (email == null || email.toString().isEmpty) {
    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
