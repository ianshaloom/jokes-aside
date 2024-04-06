// server url
import 'dart:math';

const String serverUrl = 'https://official-joke-api.appspot.com/';
const String scheme = 'https';
const String host = 'official-joke-api.appspot.com';

//  Endpoints
const String getJoke = '/jokes/random';
const String getTenJokes = '/jokes/ten';
const String getProgrammingJoke = '/jokes/programming/random';


// map keys
const String idKey = 'id';
const String typeKey = 'type';
const String setupKey = 'setup';
const String punchlineKey = 'punchline';

// return a number from given list length
// number should include 0 and exclude list length
int getRandomIndex(int length) {
  final Random random = Random();
  return random.nextInt(length);
}


// svg paths
/// light
const String share = 'assets/icons/share.svg';

/// dark
const String shareDark = 'assets/icons/share-dark.svg';
