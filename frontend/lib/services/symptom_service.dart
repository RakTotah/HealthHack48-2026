import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/symptom.dart';

class SymptomService {
  final String apiUrl = 'http://localhost:8080/symptoms';

  Future<List<Symptom>> fetchSymptoms() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Symptom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load symptoms');
    }
  }

  Future<Symptom> addSymptom(Symptom symptom) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(symptom.toJson()),
    );

    if (response.statusCode == 201) {
      throw Exception('Failed to add symptom');
    }
    return symptom;
  }

  Future<void> deleteSymptom(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete symptom');
    }
  }

  Future<List<Symptom>> fetchSymptomsByDate(DateTime date, int range) async {
    final response = await http.get(Uri.parse('$apiUrl?date=${date.toIso8601String()}&range=$range'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Symptom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load symptoms for the specified dates');
    }
  }

  Future<List<Symptom>> fetchSymptomsBySymptom(String symptomName) async {
    final response = await http.get(Uri.parse('$apiUrl?symptomName=$symptomName'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Symptom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load symptoms for the specified symptom');
    }
  }

  Future<Symptom> updateSymptom(Symptom symptom) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${symptom.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(symptom.toJson()),
    );

    if (response.statusCode == 200) {
      return Symptom.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update symptom');
    }
  }
}