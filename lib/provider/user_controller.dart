import 'dart:convert';

import 'package:f07_recursos_nativos/models/user.dart';
import 'package:http/http.dart' as http;

class UserController {
  UserController();

  static Future<List<User>> loadUsers() async {
    final response = await http.get(Uri.parse(
        'https://mini-projeto-v-default-rtdb.firebaseio.com/users.json'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((element) => {print('\n $element \n')});
      List<User> users = [];
      body.forEach((element) => {users.add(User.fromJson(element))});
      return users;
    }
    throw Exception("\n[ERRO] Não foi possível carregar usuários\n");
  }
}
