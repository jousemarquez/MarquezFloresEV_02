import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clothing_shop/pages/botton_page.dart';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _keepLoggedIn = false;

  // Método para obtener la ruta local de almacenamiento
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Método para cargar y decodificar el JSON de usuarios
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final String response = await rootBundle.loadString('assets/users.json');
    List<dynamic> usersData = jsonDecode(response);
    return List<Map<String, dynamic>>.from(usersData);
  }

  Future<void> _loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        print('Google Sign-In successful! User: ${account.displayName}');
      } else {
        print('Google Sign-In cancelled.');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  // Método para validar el inicio de sesión
  Future<void> _validateLogin() async {
    List<Map<String, dynamic>> users = await _fetchUsers();
    String enteredUsername = _userController.text.trim();
    String enteredPassword = _passwordController.text.trim();
    bool isValidUser = false;

    for (var user in users) {
      if (user['username'] == enteredUsername &&
          user['password'] == enteredPassword) {
        isValidUser = true;
        break;
      }
    }

    setState(() {
      _keepLoggedIn = !isValidUser;
    });

    if (isValidUser) {
      print('Login successful');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BotonPages()));
    } else {
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/flutter-logo.png',
                      width: 245,
                      height: 137,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: Icon(Icons.login),
                    label: Text('Login with Google')),
                // Login Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _userController,
                          decoration: InputDecoration(labelText: 'User'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _keepLoggedIn,
                              onChanged: (value) {
                                setState(() {
                                  _keepLoggedIn = value!;
                                });
                              },
                            ),
                            Text('Keep me logged in'),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _validateLogin();
                            }
                          },
                          child: Text('Log in'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
