import 'package:jokes_aside/core/constants/constant.dart';

import '../../../realm/model/joke.dart';
import '../../../realm/realm_init.dart';

import 'joke_model.dart';

abstract class JokeLocalDataSource {
  Future<void> persistJoke(JokeModel jokeToRealm);
  Future<JokeModel> getJokeFromRealm({String id = ''});
  Future<List<JokeModel>> getAllJokesFromRealm();
  Future<void> deleteJokeFromRealm(String id);
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
  Future<JokeModel> getJokeFromRealm({String id = ''}) async {
    try {
      final realm = realmInit.realm;

      if (id == '') {
        final result = realm.all<Joke>();
        final List<Joke> jokes = result.map((e) => e).toList();

        if (jokes.isNotEmpty) {
          final Joke randomJoke = jokesList.getJoke(jokes);

          final JokeModel fetchedJoke = JokeModel(
            id: randomJoke.id,
            setup: randomJoke.joke,
            type: 'general',
            punchline: randomJoke.punchline,
            isFavorite: randomJoke.isFavorite,
          );

          return fetchedJoke;
        } else {
          throw Exception();
        }
      } else {
        final Joke? joke = realm.find<Joke>(id);

        if (joke != null) {
          final JokeModel fetchedJoke = JokeModel(
            id: joke.id,
            setup: joke.joke,
            type: 'general',
            punchline: joke.punchline,
            isFavorite: joke.isFavorite,
          );

          return fetchedJoke;
        } else {
          throw Exception();
        }
      }
    } catch (error) {
      throw Exception();
    }
  }

  @override
  Future<List<JokeModel>> getAllJokesFromRealm() async {
    try {
      final realm = realmInit.realm;
      final result = realm.all<Joke>();
      final List<Joke> jokes = result.map((e) => e).toList();

      if (jokes.isNotEmpty) {
        final List<JokeModel> fetchedJokes = jokes
            .map((e) => JokeModel(
                  id: e.id,
                  setup: e.joke,
                  type: 'general',
                  punchline: e.punchline,
                  isFavorite: e.isFavorite,
                ))
            .toList();

        return fetchedJokes;
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }

  @override
  Future<void> deleteJokeFromRealm(String id) async {
    try {
      final realm = realmInit.realm;
      final Joke? joke = realm.find<Joke>(id);

      if (joke != null) {
        realm.write(() {
          realm.delete(joke);
        });
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
}

final JokesList jokesList = JokesList();

class JokesList {
  int currentIndex = 0;

  // loop thru the list from the beginning while updating currentIndex
  Joke getJoke(List<Joke> jokes) {
    if (currentIndex >= jokes.length) {
      currentIndex = 0;
    }
    return jokes[currentIndex++];
  }

  JokesList._();
  static final JokesList jokeList = JokesList._();
  factory JokesList() => jokeList;
}
