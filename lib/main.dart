import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kawika/screens/home_screen.dart';
import 'package:kawika/screens/themes/dark_theme.dart';
import 'package:kawika/screens/themes/light_theme.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeData? _themeData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeData = darkTheme;
  }

  void switchTheme() {
    setState(() {
      _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //  switchTheme: switchTheme,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
