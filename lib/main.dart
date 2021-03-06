import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/pages/auth/auth_page.dart';
import 'package:table/pages/auth/login_page.dart';
import 'package:table/pages/auth/register_page.dart';
import 'package:table/pages/groups/event_info_page.dart';
import 'package:table/pages/groups/example_map.dart';
import 'package:table/pages/groups/group_details_page.dart';
import 'package:table/pages/groups/groups_page.dart';
import 'package:table/pages/groups/rohan_event_suggest_add.dart';
import 'package:table/pages/profile/friends_page.dart';
import 'package:table/pages/profile/profile_edit_page.dart';
import 'package:table/pages/profile/profile_page.dart';
import 'package:table/pages/settings/settings_about_page.dart';
import 'package:table/pages/settings/settings_page.dart';
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
    return new LoginPage();
  }));
  router.define('/auth/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));

  // HOME ROUTES
  router.define('/', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  // GROUPS ROUTES
  router.define('/groups', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GroupsPage();
  }));
  router.define('/groups/:id', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GroupDetailsPage(params["id"][0]);
  }));
  router.define('/groups/:id/:groupid/events/:eventid', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventInfoPage(params["groupid"][0], params["eventid"][0], params["id"][0]);
  }));
  router.define('/groups/:id/:groupid/events/:eventid/map', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new MyApp();
  }));
  router.define('/groups/:id/:groupid/events/:eventid/new', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SuggestedEventsPage();
  }));

  // PROFILE ROUTES
  router.define('/profile/:id', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ProfilePage(params["id"][0]);
  }));
  router.define('/profile/:id/edit', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ProfileEditPage();
  }));
  router.define('/profile/:id/friends', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new FriendsPage(params["id"][0]);
  }));

  // SETTINGS ROUTES
  router.define('/settings', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsPage();
  }));
  router.define('/settings/about', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsAboutPage();
  }));

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/auth',
    title: "Table",
    onGenerateRoute: router.generator,
    navigatorObservers: [routeObserver],
  ));
}