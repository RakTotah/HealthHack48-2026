import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/symptom_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(
      builder: (context, provider, child) {
        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Username:"),
              Container(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    _username = value;
                  },
                ),
              ),

              SizedBox(height: 10),
              Text("Password:"),
              Container(
                width: 400,
                child:TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    _password = value;
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  provider.loginUser(_username, _password);
                  Navigator.pushReplacementNamed(context, 'home_page');
                },
                child: Text("Submit")
              )
            ],
          ),
        );
      },
    );
  }
}