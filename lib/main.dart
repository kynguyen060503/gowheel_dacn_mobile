import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/pages/sign_in.dart';
import 'package:gowheel_flutterflow_ui/root.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TokenService tokenService = TokenService();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:const Color(0xFF213A58) ,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF213A58),
          onPrimary: Colors.white
        ),
      ),
      home: tokenService.getToken().isNull ? const SignInWidget(): const RootPage(),
    );

  }
}
