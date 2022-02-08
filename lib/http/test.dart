import 'dart:convert';

import 'package:airplane/entities/authInfo.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Req {
  static const targetUrl = "http://localhost:3000/";
  static testReq() async {
    final response = await http.get(Uri.parse(targetUrl + 'api/test'));
    final decoded = jsonDecode(response.body);
    print(decoded);
  }

  static registNewUser(
      String email, String password, String name, String? note) async {
    await http.post(Uri.parse(targetUrl + 'api/v3/customer/new'), body: {
      "email": email,
      "password": password,
      "name": name,
      "note": note
    });
  }
}
