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

class JokeProvider extends ChangeNotifier {
  JokeEntity? jokeEntity;
  Failure? failure;
  
  List<JokeEntity>? jokeEntityList;
  Failure? failureList;

  JokeProvider({this.jokeEntity,  this.failure, this.jokeEntityList});

  void eitherFailureOrJokes({required String endpoint}) async {
    
    JokeRepoImpl jokeRepoImpl = JokeRepoImpl(
      localDataSource: JokeLocalDataSourceImpl(
        realmInit: RealmInit(),
      ),
      remoteDataSource: JokeRemoteDataSourceImpl(
        dio: Dio(),
      ),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrJoke =
        await GetJokeUsecase(jokeRepoImpl)(endpoint: endpoint);
        
    failureOrJoke.fold((failure) {
      this.failure = failure;
      jokeEntity = null;
      notifyListeners();
    }, (joke) {
      jokeEntity = joke;
      failure = null;
      notifyListeners();
    });
  }
  
  void getAllLocalJoke() async {
    JokeRepoImpl jokeRepoImpl = JokeRepoImpl(
      localDataSource: JokeLocalDataSourceImpl(
        realmInit: RealmInit(),
      ),
      remoteDataSource: JokeRemoteDataSourceImpl(
        dio: Dio(),
      ),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrListOfJokes =
        await GetJokeUsecase(jokeRepoImpl).getAllLocalJoke();
        
    failureOrListOfJokes.fold ((failure) {
      failureList = failure;
      jokeEntityList = null;
      notifyListeners();
    }, (jokes) {
      jokeEntityList = jokes;
      failureList = null;
      notifyListeners();
    });
  }
}
