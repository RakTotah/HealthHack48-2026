import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/symptom.dart';

class SymptomService {
  final String baseUrl = 'http://localhost:8080';

  Future<List<Symptom>> getUserSymptoms() async{

    if (response.statusCode == 200) {
      return ;
    } 
    else {
      throw Exception("Failed to get user's symptoms");
    }
  }

  Future<Symptom> getSymptomByID(String symptomID) async{

    if (response.statusCode == 200) {
      return ;
    } 
    else {
      throw Exception("Failed to get symptoms by ID");
    }
  }

  Future<List<Symptom>>getSymptomsByDate(String date) async{
    
    if (response.statusCode == 200) {
      return ;
    } 
    else {
      throw Exception("Failed to get symptoms by date");
    }
  }

  Future<Symptom> logSymptom(Symptom symptom) async{
    final response = await http.post(Uri.parse())
    if (response.statusCode == 201) {
      return Symptom.fromJson(json.decode(response.body));
    } 
    else {
      throw Exception('Failed to log symptom');
    }
  }

  Future<Void> deleteSymptomLog(int id) async{
    final response = await http.delete(Uri.parse('$baseUrl/symptoms/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete tsymptom');
    }
  } 
}