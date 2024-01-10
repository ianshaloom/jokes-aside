import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'app.dart';
import 'realm/realm_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // get application documents directory
  final Directory appDir =
      await path_provider.getApplicationDocumentsDirectory();
  final String appDirPath = appDir.path;
  debugPrint('appDirPath: $appDirPath');

  // initialize realm
  final realmInit = RealmInit();
  await realmInit.initializeRealm(appDirPath);

  runApp(const JokeAside());
}
