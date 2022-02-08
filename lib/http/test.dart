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

  static Future<dynamic> getStripeInfo(UserDoc user) async {
    final uid = user.id;
    final hashKey = user.paymentId;
    final str = "$uid:$hashKey";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final token = stringToBase64.encode(str);
    final res = await http.get(Uri.parse(targetUrl + 'api/v3/customer/info'),
        headers: {"A-Payments": token});
    final decoded = jsonDecode(res.body);
    return decoded;
  }
}
