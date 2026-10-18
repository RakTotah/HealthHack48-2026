import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/symptom.dart';
import '../providers/symptom_provider.dart';

class SymptomEntryPage extends StatelessWidget {
  const SymptomEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Symptom Entry"),
      ),
      body: Center(
        child: SymptomEntryForm()
      ),
    );
  }
}

class SymptomEntryForm extends StatefulWidget {
  const SymptomEntryForm({super.key});

  @override
  State<SymptomEntryForm> createState() => _SymptomEntryFormState();
}

class _SymptomEntryFormState extends State<SymptomEntryForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Form fields go here
        ],
      ),
    );
  }
}