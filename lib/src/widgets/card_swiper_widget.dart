import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> listaPeliculas;

  const CardSwiper({@required this.listaPeliculas});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.45,
        itemBuilder: (BuildContext context, int index) {
          listaPeliculas[index].uniqueId =
              listaPeliculas[index].title + "tarjeta";
          return Hero(
            tag: listaPeliculas[index].id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "detalle",
                      arguments: listaPeliculas[index]);
                },
                child: FadeInImage(
                  placeholder: AssetImage("assets/img/img/no-image.jpg"),
                  image: NetworkImage(
                    listaPeliculas[index].getPosterImg(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: listaPeliculas.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
