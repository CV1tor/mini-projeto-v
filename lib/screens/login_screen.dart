import 'package:f07_recursos_nativos/models/user.dart';
import 'package:f07_recursos_nativos/provider/user_controller.dart';
import 'package:f07_recursos_nativos/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorText = '';

  _login(BuildContext context) async {
    setState(() {
      errorText = '';
    });
    bool loginSucess = false;
    List<User> users = await UserController.loadUsers();

    users.forEach((element) {
      print(element);
      if (element.username == _usernameController.text &&
          element.password == _passwordController.text) {
        loginSucess = true;
        Navigator.of(context).pushNamed(AppRoutes.PLACES_LIST);
        return;
      }
    });

    if (!loginSucess) {
      setState(() {
        errorText = 'Usuário ou senha estão incorretos!';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: SizedBox(
        height: 300,
        width: 250,
        child: Card(
          color: Colors.indigo,
          elevation: 20,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          filled: true,
                          fillColor: Colors.white,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.white),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      errorText,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          child: Text("Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber),
                        )),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    ));
  }
}
