import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  final String _url = 'https://testapi.doitserver.in.ua/api';

  String get token {
    if (_token != null &&
        _expireDate != null &&
        DateTime.now().isBefore(_expireDate)) {
      return _token;
    }
    return null;
  }

  bool get isAuthenticate => token != null;

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      var response = await http.post(_url + '/$url', body: {
        'email': email,
        'password': password,
      });
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      _checkForError(response.statusCode, responseData);
      _token = responseData['token'];
      _expireDate = DateTime.now().add(Duration(hours: 24));
      notifyListeners();
    } on SocketException catch (_) {
      throw 'No network connection!';
    } catch (err) {
      throw err;
    }
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'expireDate': _expireDate.toIso8601String(),
    });
    prefs.setString('loginData', userData);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'users');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'auth');
  }

  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('loginData');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    // TODO: del return false
    // return false;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('loginData')) {
      return false;
    }
    final loginData =
        json.decode(prefs.getString('loginData')) as Map<String, Object>;
    final expireDate = DateTime.parse(loginData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = loginData['token'];
    _expireDate = expireDate;
    notifyListeners();
    return true;
  }

  void _checkForError(int statusCode, Map<String, dynamic> responseData) {
    switch (statusCode) {
      case 403:
        if (responseData.containsKey('message')) {
          throw responseData['message'];
        }
        break;
      case 422:
        if (responseData.containsKey('fields')) {
          if ((responseData['fields'] as Map<String, dynamic>)
              .containsKey('email')) {
            throw responseData['fields']['email'][0];
          }
        }
        break;
      default:
        if (statusCode != 200 && statusCode != 201) {
          throw 'Something went wrong!';
        }
    }
  }
}
