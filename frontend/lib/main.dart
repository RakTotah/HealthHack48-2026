import 'package:flutter/material.dart';
import 'package:frontend/providers/symptom_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'pages/home_page.dart';
import 'pages/symptom_entry_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/landing_page.dart';

void main() {
  runApp (
    ChangeNotifierProvider(
      create:(context) => SymptomProvider(),
      child: SymptomApp()
    )
  );
}

class SymptomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const LandingPage(),
      'home'
      'symptom_entry': (context) => const SymptomEntryPage(),
      'login': (context) => const LoginPage(),
      'register': (context) => const RegisterPage(),
    },
    debugShowCheckedModeBanner: false,
    );
  }
}