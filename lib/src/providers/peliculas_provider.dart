import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pelicula_app/src/models/actores_model.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = "a6a2e0ed988ab7baffa6f3361735bd6d";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";
  int _popularesPage = 1;
  bool _cargando = false;

  List<Pelicula> _populares = [];

  final _popularesStreamControler =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamControler.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamControler.stream;

  void disposeStreams() {
    _popularesStreamControler?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);
    final peliculas = Peliculas.fromJsonList(decodedData["results"]);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, "/3/movie/now_playing", {
      "api_key": _apiKey,
      "languague": _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) {
      return [];
    }

    _cargando = true;

    _popularesPage++;
    final url = Uri.https(_url, "/3/movie/top_rated", {
      "api_key": _apiKey,
      "language": _language,
      "page": _popularesPage.toString(),
    });

    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    popularesSink(_populares);
    _cargando = false;
    return respuesta;
  }

  Future<List<Pelicula>> getPorVenir() async {
    final url = Uri.https(_url, "/3/movie/upcoming", {
      "api_key": _apiKey,
      "language": _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Actor>> getActores(String peliculaId) async {
    final url = Uri.https(_url, "3/movie/$peliculaId/credits", {
      "api_key": _apiKey,
      "language": _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final actores = Actores.fromJsonList(decodedData["cast"]);
    return actores.actores;
  }

  Future<List<Pelicula>> getBuscarPelicula(String query) async {
    final url = Uri.https(_url, "/3/search/movie", {
      "api_key": _apiKey,
      "language": _language,
      "query": query,
    });

    return await _procesarRespuesta(url);
  }
}
