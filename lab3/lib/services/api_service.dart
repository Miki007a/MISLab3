import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class ApiService {
  static const baseUrl = 'https://official-joke-api.appspot.com';

  static Future<List<String>> fetchJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  static Future<List<JokeModel>> fetchJokesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => JokeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  static Future<Map<String, dynamic>> fetchRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load random joke');
    }
  }
}
