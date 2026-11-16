import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../models/schedule_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  static Future<List<MovieModel>> getMovies({String? status, String? name}) async {
    Uri uri;
    if (name != null && name.trim().isNotEmpty) {
      uri = Uri.parse('$baseUrl/search/shows?q=${Uri.encodeComponent(name.trim())}');
    } else {
      uri = Uri.parse('$baseUrl/shows?page=0');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      List<MovieModel> movies = [];

      if (name != null && name.trim().isNotEmpty) {
        movies = data.map((item) {
          final show = item['show'] ?? item;
          return MovieModel.fromJson(show);
        }).toList();
      } else {
        movies = data.take(30).map((item) => MovieModel.fromJson(item)).toList();
      }

      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        movies = movies.where((m) => m.status.toLowerCase() == status.toLowerCase()).toList();
      }

      return movies;
    } else {
      throw Exception('Gagal memuat katalog film bioskop (${response.statusCode})');
    }
  }

  static Future<MovieModel> getMovieDetail(int id) async {
    final uri = Uri.parse('$baseUrl/shows/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail film (${response.statusCode})');
    }
  }

  static Future<List<ScheduleModel>> getSchedules() async {
    final uri = Uri.parse('$baseUrl/schedule');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.take(20).map((item) => ScheduleModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat jadwal tayang bioskop (${response.statusCode})');
    }
  }
}

