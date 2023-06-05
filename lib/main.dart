import 'package:easy_shop/color/palette.dart';
import 'package:easy_shop/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    // statusBarColor: Colors.transparent,
    // statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // colorSchemeSeed: Colors.white,
        //primarySwatch: Palette.kToGrey,
      ),
      home: const MyHomePage(title: 'Easy Shop'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    //draw under navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FilledButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('註冊'),
                  )),
              SizedBox(
                height: 30,
              ),
              FilledButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('登入'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
