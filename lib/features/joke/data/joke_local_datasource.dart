import '../../../realm/model/joke.dart';
import '../../../realm/realm_init.dart';

import 'joke_model.dart';

abstract class JokeLocalDataSource {
  Future<void> persistJoke(JokeModel jokeToRealm);
  Future<Joke> getJokeFromRealm(String id);
  Future<List<Joke>> getAllJokesFromRealm();
}

class JokeLocalDataSourceImpl implements JokeLocalDataSource {
  final RealmInit realmInit;
  
  JokeLocalDataSourceImpl({required this.realmInit});
  
  @override
  Future<void> persistJoke(JokeModel jokeToRealm) async {
    final Joke joke = Joke(
      jokeToRealm.id,
      jokeToRealm.setup,
      jokeToRealm.punchline,
      jokeToRealm.isFavorite,
    );
    
    try {
      
      final realm = realmInit.realm;
      realm.write(() {
        realm.add<Joke>(joke);
      });
      
    } catch (error) {
      throw Exception();
    }
  }
  
  @override
  Future<Joke> getJokeFromRealm(String id) async {
    try {
      final realm = realmInit.realm;
      final Joke? joke = realm.find<Joke>(id);
      
      if (joke != null) {
        return joke;
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
  
  @override
  Future<List<Joke>> getAllJokesFromRealm() async {
    try {
      final realm = realmInit.realm;
      final result = realm.all<Joke>(); 
      final List<Joke> jokes = result.map((e) => e).toList();
      
      if (jokes.isNotEmpty) {
        return jokes;
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
  
  
}
