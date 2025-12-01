import 'package:flutter/material.dart';
import 'package:travel_reimbursement/auth/service/auth_service.dart';
import 'package:travel_reimbursement/splashscreen/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initializeUsers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Reimbursement',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
    );
  }
}