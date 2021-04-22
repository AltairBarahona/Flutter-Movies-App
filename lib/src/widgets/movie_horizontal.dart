import 'package:flutter/material.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  final _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.3,
  );

  MovieHorizontal({Key key, @required this.peliculas, this.siguientePagina})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent) {
        print("final de lista2");
        siguientePagina();
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        // color: Colors.red,
        margin: EdgeInsets.only(top: 15),
        height: _screenSize.height * 0.28,
        // width: _screenSize.width * 0.4,
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas.length,
          itemBuilder: (context, index) {
            return _tarjetaIndividual(context, peliculas[index]);
          },
        ),
      ),
    );
  }

  Widget _tarjetaIndividual(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = pelicula.id.toString() + "populares";
    final tarjetaIndividual = Container(
      color: Colors.white,
      //height: 100,
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Hero(
            tag: pelicula.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/img/img/no-image.jpg"),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 155,
                // width: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              pelicula.title,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjetaIndividual,
      onTap: () {
        print("Nombre de película: " + pelicula.title);
        Navigator.pushNamed(
          context,
          "detalle",
          arguments: pelicula,
        );
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        color: Colors.white,
        // height: 100,
        margin: EdgeInsets.only(right: 15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/img/img/no-image.jpg"),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 155,
                // width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                pelicula.title,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
