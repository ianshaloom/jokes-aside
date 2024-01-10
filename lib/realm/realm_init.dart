import 'package:flutter/foundation.dart';

import 'package:realm/realm.dart';

import 'model/joke.dart';

class RealmInit {
  late Realm _realm;
  
  // getter
  Realm get realm => _realm;
  
  Future<void> initializeRealm(String path) async {
    try {
      // Configure a Realm configuration for your app
      final config = Configuration.local(
        [
          Joke.schema,
        ],
      );

      // Open a Realm instance using the configuration
      final realm = Realm(config);
      _realm = realm;
    } catch (error) {
      debugPrint('Realm initialization error: $error');
      // Handle initialization errors appropriately
    }
  }
  
  
  // factory constructor
  RealmInit._();
  static final RealmInit _instance = RealmInit._();
  factory RealmInit() => _instance;
}
