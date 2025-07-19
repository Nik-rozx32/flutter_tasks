import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<User>> fetchUsers() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Users');
    }
  }

  Future<User> createUser(User user) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return User.fromJson(json.decode(res.body));
  }

  Future<User> updateUser(String id, User user) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return User.fromJson(json.decode(res.body));
  }

  Future<void> deleteUser(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
