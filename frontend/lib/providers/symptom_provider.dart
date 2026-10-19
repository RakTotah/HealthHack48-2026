import 'package:flutter/foundation.dart';
import '../models/symptom.dart';
import '../models/User.dart';
import '../services/symptom_service.dart';
import '../services/login_service.dart';

class SymptomProvider with ChangeNotifier {
  final SymptomService _symptomService = SymptomService();
  final LoginService _userService = LoginService();
  List<String> _symptomNames = [];
  List<Symptom> _symptoms = [];
  List<Symptom> get symptoms => _symptoms;
  List<String> get symptomNames => _symptomNames;
  User _user = User((username: "LoggedOut", password: "Default"));


  Future<void> registerUser(String username, String password) {
    try {
      _user = await _userService.register(username, password);
      notifyListeners();
    } catch (e) {
      print ('Error registering: $e');
    }
  }

  Future<void> getSymptomsByDate(String date) async {
    try {
      _symptoms = await _symptomService.getSymptomsByDate(date);
      notifyListeners();
    } catch (e) {
      print('Error get symptoms: $e');
    }
  }

  Future<void> fetchSymptomsBySymptom(String symptomName) async {
    try {
      _symptoms = await _symptomService.fetchSymptomsBySymptom(symptomName);
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

  Future<void> deleteSymptomLog(int id) async {
    try {
      await _symptomService.deleteSymptomLog(id);
      _symptoms.removeWhere((symptom) => symptom.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting symptom: $e');
    }
  }
}