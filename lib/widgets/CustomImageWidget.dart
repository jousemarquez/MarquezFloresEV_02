import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomImageWidget extends StatefulWidget {
  final String imageUrl;
  final String description;

  final VoidCallback onPressedHome;
  final VoidCallback onPressedShop;
  final String imagenUrlFrase;

  const CustomImageWidget(
      {super.key,
      required this.imageUrl,
      required this.description,
      required this.onPressedHome,
      required this.onPressedShop,
      required this.imagenUrlFrase});

  @override
  _CustomImageWidgetState createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {
  bool _isHomeSelected = true;
  String? jsonData;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<Map<String, dynamic>> fetchDataFromJson() async {
    const String apiurl = 'assets/users.json';
    try {
      final http.Response response = await http.get(Uri.parse(apiurl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final Map<String, dynamic> data = await fetchDataFromJson();
      List<User> fetchedItems = (data['users'] as List<dynamic>)
          .map((json) => User.fromJson(json))
          .toList();
      setState(() {
        jsonData = fetchedItems.isNotEmpty
            ? fetchedItems[0].username
            : 'No hay ningún usuario';
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jsonData ?? 'JOSÉ ANTONIO MÁRQUEZ FLORES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHomeSelected = true;
                  });
                  widget.onPressedHome();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _isHomeSelected
                            ? Color(0xFF626262)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: _isHomeSelected ? Color(0xFF626262) : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHomeSelected = false;
                  });
                  widget.onPressedShop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: !_isHomeSelected
                            ? Color(0xFF626262)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Shop',
                    style: TextStyle(
                      color:
                          !_isHomeSelected ? Color(0xFF626262) : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: Image.network('assets/images/Letras/REBAJAS.png'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: Image.network(widget.imagenUrlFrase),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: Image.network('assets/images/Letras/descuento.png'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class User {
  final String username;

  User({
    required this.username,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username']);
  }
}
