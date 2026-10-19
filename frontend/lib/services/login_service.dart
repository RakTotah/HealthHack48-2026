import 'package:http/http.dart' as http;

class LoginService{
  String registerURL = "http://localhost:8080/register";
  String loginURL = "http://localhost:8080/login";
  String deregisterURL = "http://localhost:8080/deregister";

  Future<bool> attemptLogin(String username, String password) async{
    final response = await http.get(Uri.parse(loginURL));
  }
}