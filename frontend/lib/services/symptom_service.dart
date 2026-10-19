import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/symptom.dart';

class SymptomService {
  final String baseUrl = 'http://localhost:8080/symptoms';

  List<Symptom> fromJSON(http.Response response){
    final List temp = json.decode(response.body);
    final List<Symptom> symptomLst =
    temp.map((item) => Symptom.fromJson(item)).toList();
    return symptomLst;
  }

  Future<List<Symptom>> getUserSymptoms(String username, String password) async{
    final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        }
    )
    if (response.statusCode == 200) {
      return this.fromJSON(response);
    } 
    else {
      throw Exception(response.body);
    }
  }

  Future<Symptom> getSymptomByID(String symptomID, String username, String password) async{

    final response = await http.get(
        Uri.parse("$baseUrl/$symptomID"),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        }
    )
    if (response.statusCode == 200) {
      return Symptom.fromJson(json.decode(response.body));
    }
    else {
      throw Exception(response.body);
    }
  }

  Future<List<Symptom>>getSymptomsByDate(String date, String username, String password) async{
    final response = await http.get(
        Uri.parse("$baseUrl/$date"),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        }
    )
    if (response.statusCode == 200) {
      return this.fromJSON(response);
    }
    else {
      throw Exception(response.body);
    }
  }

  Future<Symptom> logSymptom(Symptom symptom, String username, String password) async{
    final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        },
      body: symptom.toJson()
    );

    if (response.statusCode == 201) {
      return Symptom.fromJson(json.decode(response.body));
    } 
    else {
      throw Exception('Failed to log symptom');
    }
  }

  Future<Void> deleteSymptomLog(String id, String username, String password) async{
    final response = await http.delete(
        Uri.parse('$baseUrl/symptoms/$id'),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        }
    );
    if (response.statusCode != 204) {
      throw Exception(response.body);
    }
  } 
}