import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:movieapp/model/MovieModel.dart';

class GetDataApi {
  static Future<List<MovieModel>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MovieModel.fromJson(json['show'])).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<MovieModel>> searchMovies(String searchTerm) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MovieModel.fromJson(json['show'])).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
