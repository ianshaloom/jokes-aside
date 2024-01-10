import 'package:realm/realm.dart';

part 'joke.g.dart';

@RealmModel()
class _Joke{
  @PrimaryKey()
  late final String id;
  
  late final String joke;
  late final String punchline;
  late bool isFavorite;
}