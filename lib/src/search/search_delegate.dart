import 'package:flutter/material.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';
import 'package:pelicula_app/src/providers/peliculas_provider.dart';

class MovieSearch extends SearchDelegate {
  String get searchFieldLabel => 'Buscar...';
  final peliculasProvider = PeliculasProvider();
  String seleccion = "";
  final peliculas = [
    "spiderman",
    "ironman",
    "capitán américa",
    "Shazam",
    "Ant",
    "movie 6",
    "movie 7",
    "movie 8",
  ];

  final peliculasRecientes = [
    "mR 1",
    "mR 2",
    "mR 3",
    "mR 4",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones derechas del "appBar"
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          print("Click");
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Acciones izquierdas del "appBar"
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Instruccion que crea resultados a mostrar
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.cyanAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias mientras se escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.getBuscarPelicula(query),
      builder: (context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map<Widget>((p) {
              return ListTile(
                title: Text(p.title),
                leading: FadeInImage(
                  placeholder: AssetImage("assets/img/img/no-image.jpg"),
                  image: NetworkImage(p.getPosterImg()),
                  width: 50,
                  fit: BoxFit.contain,
                ),
                subtitle: Text(p.originalTitle),
                onTap: () {
                  close(context, "");
                  p.uniqueId = "";
                  Navigator.pushNamed(context, "detalle", arguments: p);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*@override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen mientras se escribe

    final listaSugerencias = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerencias.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerencias[index].toString()),
          onTap: () {
            seleccion = listaSugerencias[index].toString();
            showResults(context);
          },
        );
      },
    );
  }*/
}
