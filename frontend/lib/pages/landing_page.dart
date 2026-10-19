import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JohnKompot"),
      ),
      body: Center(
        child: Text("Welcome to john kompot"),
      ),
    );
  }
}