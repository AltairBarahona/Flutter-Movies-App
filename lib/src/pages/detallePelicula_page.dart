import 'package:flutter/material.dart';
import 'package:pelicula_app/src/models/actores_model.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';
import 'package:pelicula_app/src/providers/peliculas_provider.dart';

class DetallePelicula extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _crearAppBar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate(
          [
            SizedBox(height: 20),
            _posterTitulo(pelicula, context),
            SizedBox(height: 20),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _crearCasting(pelicula),
          ],
        )),
        // SliverFillRemaining(),
      ],
    ));
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        background: FadeInImage(
          placeholder: AssetImage("assets/img/img/loading.gif"),
          image: NetworkImage(
            pelicula.getBackgroundImg(),
          ),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 170,
              ),
            ),
          ),
          SizedBox(width: 20),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pelicula.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pelicula.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
              Row(children: [Icon(Icons.star)]),
              Text(pelicula.voteAverage.toString()),
            ],
          )),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculasProvider = PeliculasProvider();
    return FutureBuilder(
      future: peliculasProvider.getActores(pelicula.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemBuilder: (context, index) {
          return _actorTarjeta(actores[index]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/img/img/no-image.jpg"),
                image: NetworkImage(actor.getActorImg()),
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
