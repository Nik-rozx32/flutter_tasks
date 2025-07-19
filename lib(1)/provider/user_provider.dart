import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  final UserService _userService = UserService();

  List<User> get users => _users;

  Future<void> loadUsers() async {
    _users = await _userService.fetchUsers();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    final newUser = await _userService.createUser(user);
    _users.add(newUser);
    notifyListeners();
  }

  Future<void> updateUser(String id, User updatedUser) async {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final user = await _userService.updateUser(id, updatedUser);
      _users[index] = user;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String id) async {
    await _userService.deleteUser(id);
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}
