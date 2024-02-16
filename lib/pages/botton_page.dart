import 'package:flutter/material.dart';
import 'package:clothing_shop/pages/products_women_page.dart';
import 'package:clothing_shop/pages/products_men_page.dart';

class BotonPages extends StatelessWidget {
  const BotonPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/mujer.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Acción cuando se hace clic en el primer contenedor
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsWomenComponent()));
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/hombre.png'), // Imagen de fondo para el segundo Expanded
                  fit: BoxFit.cover,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Acción cuando se hace clic en el segundo contenedor
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsManComponent()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
