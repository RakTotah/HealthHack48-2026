import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/symptom.dart';
import '../providers/symptom_provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Text("Registration Form Goes Here"),
      ),
    );
  }
}