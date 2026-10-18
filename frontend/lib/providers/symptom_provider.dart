import 'package:flutter/foundation.dart';
import '../models/symptom.dart';
import '../services/symptom_service.dart';

class SymptomProvider with ChangeNotifier {
  final SymptomService _symptomService = SymptomService();
  List<Symptom> _symptoms = [];

  List<Symptom> get symptoms => _symptoms;

  Future<void> fetchSymptoms() async {
    try {
      _symptoms = await _symptomService.fetchSymptomsByDate(DateTime.now(), 1);
      notifyListeners();
    } catch (e) {
      print('Error fetching symptoms: $e');
    }
  }

  Future<void> addSymptom(Symptom symptom) async {
    try {
      final newSymptom = await _symptomService.addSymptom(symptom);
      _symptoms.add(newSymptom);
      notifyListeners();
    } catch (e) {
      print('Error adding symptom: $e');
    }
  }

  Future<void> updateSymptom(Symptom symptom) async {
    try {
      final updatedSymptom = await _symptomService.updateSymptom(symptom);
      final index = _symptoms.indexWhere((s) => s.id == updatedSymptom.id);
      if (index != -1) {
        _symptoms[index] = updatedSymptom;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating symptom: $e');
    }
  }

  Future<void> deleteSymptom(int id) async {
    try {
      await _symptomService.deleteSymptom(id);
      _symptoms.removeWhere((symptom) => symptom.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting symptom: $e');
    }
  }
}