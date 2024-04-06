import 'package:flutter/material.dart';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failure.dart';
import '../../../../realm/realm_init.dart';
import '../../data/joke_local_datasource.dart';
import '../../data/joke_remote_datasource.dart';
import '../../data/joke_repo_impl.dart';
import '../../domain/joke_usecase.dart';
import '../../domain/jokes_entity.dart';

class JokeProvider extends ChangeNotifier with JokeProviderMixin {
  JokeProvider({
    this.jokeEntity,
    this.failure,
    this.jokeEntityList,
    this.failureList,
    this.jokeEntityById,
    this.failureById,
    this.jokeEntityToSave,
    this.failureToSave,
    this.jokeEntityToDelete,
    this.failureToDelete,
  });

  final JokeRepoImpl jokeRepoImpl = JokeRepoImpl(
    localDataSource: JokeLocalDataSourceImpl(
      realmInit: RealmInit(),
    ),
    remoteDataSource: JokeRemoteDataSourceImpl(
      dio: Dio(),
    ),
    networkInfo: NetworkInfoImpl(DataConnectionChecker()),
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  static bool isConnected = false;

  bool _isBookmark = false;
  bool get isBookmark => _isBookmark;
  set isBookmark(bool value) {
    _isBookmark = value;
    notifyListeners();
  }

  JokeEntity? jokeEntity;
  Failure? failure;
  Future eitherFailureOrJokeEntity({required String endpoint}) async {
    // is loading
    _isLoading = true;
    notifyListeners();

    final failureOrJoke =
        await GetJokeUsecase(jokeRepoImpl).call(endpoint: endpoint);

    failureOrJoke.fold((failure) {
      this.failure = failure;
      _isLoading = false;
      jokeEntity = null;
      notifyListeners();
    }, (joke) {
      _isLoading = false;
      jokeEntity = joke;
      failure = null;
      _isBookmark = joke.isFavorite;

      notifyListeners();
    });
  }

  List<JokeEntity>? jokeEntityList;
  Failure? failureList;
  void eitherFailureOrLocalJokes() async {
    final failureOrListOfJokes =
        await GetJokeUsecase(jokeRepoImpl).getAllLocalJoke();

    failureOrListOfJokes.fold((failure) {
      failureList = failure;
      jokeEntityList = null;
      notifyListeners();
    }, (jokes) {
      jokeEntityList = jokes;
      failureList = null;
      notifyListeners();
    });
  }

  JokeEntity? jokeEntityById;
  Failure? failureById;
  void eitherFailureOrLocalJokeById(String id) async {
    final failureOrJoke =
        await GetJokeUsecase(jokeRepoImpl).getLocalJokeById(id);

    failureOrJoke.fold((failure) {
      failureById = failure;
      jokeEntityById = null;
      notifyListeners();
    }, (joke) {
      jokeEntityById = joke;
      failureById = null;
      notifyListeners();
    });
  }

  JokeEntity? jokeEntityToSave;
  Failure? failureToSave;
  void eitherFailureOrSavedJoke(JokeEntity joke) async {
    final failureOrJoke =
        await GetJokeUsecase(jokeRepoImpl).saveJokeToRealm(joke);

    failureOrJoke.fold((failure) {
      debugPrint('failure: ${failure.errorMessage}');
      failureToSave = failure;
      jokeEntityToSave = null;
      notifyListeners();
    }, (joke) {
      jokeEntityToSave = joke;
      failureToSave = null;
      _isBookmark = true;

      notifyListeners();
    });
  }

  JokeEntity? jokeEntityToDelete;
  Failure? failureToDelete;
  void eitherFailureOrDeletedJoke(String id) async {
    final failureOrJoke =
        await GetJokeUsecase(jokeRepoImpl).deleteJokeFromRealm(id);

    failureOrJoke.fold((failure) {
      debugPrint('failure: $failure');
      failureToDelete = failure;
      jokeEntityToDelete = null;

      notifyListeners();
    }, (joke) {
      jokeEntityToDelete = joke;
      failureToDelete = null;
      jokeEntityList = deleteJoke(id, jokeEntityList!);
      _isBookmark = false;

      notifyListeners();
    });
  }
}

mixin JokeProviderMixin {
  List<JokeEntity> deleteJoke(String id, List<JokeEntity> jokes) {
    jokes.removeWhere((element) => element.id == id);
    return jokes;
  }
}
