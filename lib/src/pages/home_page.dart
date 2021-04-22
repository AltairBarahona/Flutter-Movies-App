import 'package:flutter/material.dart';
import 'package:pelicula_app/src/providers/peliculas_provider.dart';
import 'package:pelicula_app/src/search/search_delegate.dart';
import 'package:pelicula_app/src/widgets/card_swiper_widget.dart';
import 'package:pelicula_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas en cines"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearch(),
                // query: "",
              );
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                _swiperTarjetas(),
                _footer(),
                // _swiperRecientes(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contact_mail),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Me llamo Altair Barahona"),
                      SizedBox(height: 20),
                      Text(
                          "Estoy apunto de graduarme en ingeniería de software de la UDLA."),
                      SizedBox(height: 20),
                      Container(
                          child: Text(
                              "Me interesa la capacidad de la tecnología para generar emociones. Conozco de todo un poco, pero me interesa principalmente:\n\n📱 El desarrollo móvil.\n🕹Aplicaciones interactivas.\n💎 Realidad aumentada (AR).\n🎴 Realidad virtual (VR).\n♦Desarrollo de video juegos.")),
                      SizedBox(height: 20),
                      Text("altair.profesional@gmail.com"),
                      Text("0992928557"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      // initialData: [],
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            listaPeliculas: snapshot.data,
          );
        } else {
          return Container(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footer() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              "Películas populares",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

  Widget _swiperRecientes() {
    return Container(
      child: Column(
        children: [
          Text("Películas recientes", style: TextStyle(fontSize: 30)),
          FutureBuilder(
            future: peliculasProvider.getPorVenir(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CardSwiper(listaPeliculas: snapshot.data);
              } else {
                return Container(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
