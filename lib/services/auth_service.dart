import 'dart:convert';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late User user;
  bool _utentication = false;
  final _storage = new FlutterSecureStorage();

  bool get autentication => _utentication;
  set autentication(bool value) {
    _utentication = value;
    notifyListeners();
  }

  //Getters of token
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    // Write value
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autentication = true;
    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);
    autentication = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _savedToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    autentication = true;
    final data = {'name': name, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // print(resp.body);
    autentication = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _savedToken(loginResponse.token);
      return true;
    } else {
      final resBody = jsonDecode(resp.body);
      return resBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': '$token'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _savedToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _savedToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete all
    await _storage.delete(key: 'token');
  }
}
