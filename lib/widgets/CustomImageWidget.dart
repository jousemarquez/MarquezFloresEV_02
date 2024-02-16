import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomImageWidget extends StatefulWidget {
  final String imageUrl;
  final String description;
  final IconData icon;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedShop;
  final String imagenUrlFrase;

  const CustomImageWidget(
      {super.key, required this.imageUrl,
      required this.description,
      required this.icon,
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
      // Realiza una solicitud GET al endpoint
      final http.Response response = await http.get(Uri.parse(apiurl));

      // Comprueba si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON en un mapa de Dart
        final Map<String, dynamic> data = json.decode(response.body);

        // Retorna los datos obtenidos del JSON
        return data;
      } else {
        // Si la solicitud no fue exitosa, lanza una excepción con un mensaje de error
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      // Llama a la función que obtiene los datos del JSON
      final Map<String, dynamic> data = await fetchDataFromJson();

      // Convierte los datos del JSON en objetos Item y los agrega a la lista
      List<User> fetchedItems = (data['users'] as List<dynamic>)
          .map((json) => User.fromJson(json))
          .toList();

      // Actualiza el estado con los nuevos objetos Item
      setState(() {
        jsonData = fetchedItems.isNotEmpty
            ? fetchedItems[0].username
            : 'No hay ningún usuario';
      });
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir al obtener los datos
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
          right: 10, // Ajuste a la parte superior derecha
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jsonData ?? 'jouse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              // Icon(
              //   widget.icon,
              //   color: Colors.white,
              //   size: 30,
              // ),
              CircleAvatar(
                backgroundImage: AssetImage(
                    'https://e7.pngegg.com/pngimages/722/101/png-clipart-computer-icons-user-profile-circle-abstract-miscellaneous-rim.png'),
              )
            ],
          ),
        ),
        Positioned(
          top: 10, // Ajuste a la parte superior
          left: 10, // Ajuste a la parte izquierda
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
                        color:
                            _isHomeSelected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: _isHomeSelected ? Colors.red : Colors.black,
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
                        color:
                            !_isHomeSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Shop',
                    style: TextStyle(
                      color: !_isHomeSelected ? Colors.blue : Colors.black,
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
              Image.network('assets/images/Letras/REBAJAS.png'),
              Image.network(widget.imagenUrlFrase),
              Image.network('assets/images/Letras/descuento.png'),
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
