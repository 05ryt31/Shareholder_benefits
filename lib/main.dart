import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/benefit_service.dart';

void main() {
  runApp(const ShareholderBenefitApp());
}

class ShareholderBenefitApp extends StatelessWidget {
  const ShareholderBenefitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BenefitService(),
      child: MaterialApp(
        title: '株主優待マップ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'NotoSansJP',
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja', 'JP'),
        ],
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}