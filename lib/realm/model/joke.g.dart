// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Joke extends _Joke with RealmEntity, RealmObjectBase, RealmObject {
  Joke(
    String id,
    String joke,
    String punchline,
    bool isFavorite,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'joke', joke);
    RealmObjectBase.set(this, 'punchline', punchline);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
  }

  Joke._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => throw RealmUnsupportedSetError();

  @override
  String get joke => RealmObjectBase.get<String>(this, 'joke') as String;
  @override
  set joke(String value) => throw RealmUnsupportedSetError();

  @override
  String get punchline =>
      RealmObjectBase.get<String>(this, 'punchline') as String;
  @override
  set punchline(String value) => throw RealmUnsupportedSetError();

  @override
  bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
  @override
  set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

  @override
  Stream<RealmObjectChanges<Joke>> get changes =>
      RealmObjectBase.getChanges<Joke>(this);

  @override
  Joke freeze() => RealmObjectBase.freezeObject<Joke>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Joke._);
    return const SchemaObject(ObjectType.realmObject, Joke, 'Joke', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('joke', RealmPropertyType.string),
      SchemaProperty('punchline', RealmPropertyType.string),
      SchemaProperty('isFavorite', RealmPropertyType.bool),
    ]);
  }
}
