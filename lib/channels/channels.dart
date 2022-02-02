import 'package:flutter/services.dart';

class PaymentChannel {
  static const channel = MethodChannel("net.cbtdev.sample/method");
  static Future<String> test() async {
    return await channel.invokeMethod("hello");
  }

  static Future<String> payTest() async {
    return await channel.invokeMethod("pay");
  }
}
