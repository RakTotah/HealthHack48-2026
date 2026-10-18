import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'pages/home_page.dart';
import 'pages/symptom_entry_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() {
  runApp (MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage(),
      'symptom_entry': (context) => const SymptomEntryPage(),
      'login': (context) => const LoginPage(),
      'register': (context) => const RegisterPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}