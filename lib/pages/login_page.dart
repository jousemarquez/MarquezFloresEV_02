import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clothing_shop/pages/botton_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _keepLoggedIn = false;
  String _errorMessage = '';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final String response = await rootBundle.loadString('assets/users.json');
    List<dynamic> usersData = jsonDecode(response);
    return List<Map<String, dynamic>>.from(usersData);
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        print('Google Sign-In successful! User: ${account.displayName}');
        _navigateToBotonPages();
      } else {
        print('Google Sign-In cancelled.');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  void _navigateToBotonPages() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BotonPages(),
      ),
    );
  }

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

    if (isValidUser) {
      print('Login successful');
      _navigateToBotonPages();
    } else {
      print('Login failed');
      setState(() {
        _keepLoggedIn = false;
        _errorMessage = 'Wrong password. Please, try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/clothing_store_logo.png',
                        width: 245,
                        height: 137,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: Image.asset(
                      'assets/images/logo_google.png',
                      height: 32,
                    ),
                    label: Text('Login with Google'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _userController,
                            decoration: InputDecoration(labelText: 'User'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
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
                              SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '#');
                                },
                                child: Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 81, 81, 81),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _validateLogin();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF39810D),
                            minimumSize: Size(345, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
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
