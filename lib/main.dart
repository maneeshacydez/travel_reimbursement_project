import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_reimbursement/auth/service/auth_service.dart';
import 'package:travel_reimbursement/dashboard/controller/finance.dart';
import 'package:travel_reimbursement/dashboard/controller/new_req_provider.dart';
import 'package:travel_reimbursement/dashboard/controller/travel_provider.dart';
import 'package:travel_reimbursement/dashboard/repository/new_req.dart';
import 'package:travel_reimbursement/dashboard/repository/travel_repo.dart';
import 'package:travel_reimbursement/dashboard/service/newreq_service.dart';
import 'package:travel_reimbursement/splashscreen/splash_screen.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initializeUsers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
          create: (_) => ReqstCreateProvider(
            ReqstCreateRepositoryImpl(
              ReqstCreateServiceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TravelProvider(
            TravelRepository(client: http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FinanceListProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Travel Reimbursement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const SplashScreen(),
      ),
    );
  }
}