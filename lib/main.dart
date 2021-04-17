import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/pages/auth/auth_page.dart';
import 'package:table/pages/tab_bar_controller.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);
  print('Initialized default app $app');

  // AUTH ROUTES
  router.define('/auth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthPage();
  }));
  router.define('/auth/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Container();
  }));
  router.define('/auth/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Container();
  }));
  router.define('/auth/error', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Container();
  }));

  // HOME ROUTES
  router.define('/', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
    // return new MaintenancePage();
  }));

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/auth',
    title: "Table",
    onGenerateRoute: router.generator,
  ));
}