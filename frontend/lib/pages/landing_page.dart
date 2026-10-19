import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JohnKompot"),
        leading: Column (
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              child: Text("Login")
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'register');
              },
              child: Text("Register")
            ),
          ],
        )
      ),
      body: Center(
        child: Text(""),
      ),
    );
  }
}