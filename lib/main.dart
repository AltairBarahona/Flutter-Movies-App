import 'package:flutter/material.dart';
import 'package:pelicula_app/src/pages/home_page.dart';
import 'package:pelicula_app/src/pages/detallePelicula_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PeliculasApp',
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "detalle": (context) => DetallePelicula(),
      },
    );
  }
}
