import 'package:http/http.dart' as http;

class LoginService{
  String registerURL = "http://localhost:8080/register";
  String loginURL = "http://localhost:8080/login";
  String deregisterURL = "http://localhost:8080/deregister";

  Future<bool> attemptLogin(String username, String password) async{
    final response = await http.get(
      Uri.parse(loginURL),
      headers: {
        "content": "application.json",
        "username": username,
        "password": password
      });

    if (response.statusCode != 202){
      throw Exception(response.body);
    }
    return true;
  }

  Future<bool> register(String username, String password) async{
    final response = await http.post(
        Uri.parse(registerURL),
        headers: {
          "content": "application.json"
        },
      body: {
          "username": username,
          "password": password
        }
    );

    if (response.statusCode != 201){
      throw Exception(response.body);
    }
    return true;
  }

  Future<bool> deregister(String username, String password) async{
    final response = await http.delete(
        Uri.parse(deregisterURL),
        headers: {
          "content": "application.json",
          "username": username,
          "password": password
        },
    );

    if (response.statusCode != 201){
      throw Exception(response.body);
    }
    return true;
  }
}