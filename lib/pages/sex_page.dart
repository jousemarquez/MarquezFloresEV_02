import 'package:flutter/material.dart';

class GenderPage extends StatelessWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona tu género'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Acción cuando se presiona el botón "Mujeres"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Color de fondo del botón "Mujeres"
                padding: EdgeInsets.symmetric(vertical: 20), // Padding del botón
              ),
              child: Text(
                'Mujeres',
                style: TextStyle(fontSize: 24), // Tamaño de texto
              ),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                // Acción cuando se presiona el botón "Hombres"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo del botón "Hombres"
                padding: EdgeInsets.symmetric(vertical: 20), // Padding del botón
              ),
              child: Text(
                'Hombres',
                style: TextStyle(fontSize: 24), // Tamaño de texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}