import 'package:dartz/dartz.dart';

import '../../../core/connection/network_info.dart';
import '../../../core/constants/constant.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../domain/joke_repo.dart';
import '../domain/jokes_entity.dart';

import 'joke_local_datasource.dart';
import 'joke_model.dart';
import 'joke_remote_datasource.dart';

class JokeRepoImpl implements JokeRepo {
  final JokeLocalDataSource localDataSource;
  final JokeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  JokeRepoImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, JokeEntity>> getRandomRemoteJoke(
      {String? endpoint}) async {
    final bool isConnected = await networkInfo.isConnected!;
    endpoint = endpoint ?? getJoke;

    if (isConnected) {
      try {
        final remoteJoke = await remoteDataSource.getAJoke(endpoint: endpoint);
        return Right(remoteJoke);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      try {
        final localJoke = await localDataSource.getJokeFromRealm();
        final joke = JokeEntity(
          id: localJoke.id,
          setup: localJoke.setup,
          punchline: localJoke.punchline,
          isFavorite: localJoke.isFavorite,
        );

        return Right(joke);
      } on Exception {
        return Left(CacheFailure(errorMessage: 'This is a cache exception'));
      }
    }
  }

  @override
  Future<Either<Failure, List<JokeEntity>>> getAllLocalJoke() async {
    try {
      final localJoke = await localDataSource.getAllJokesFromRealm();

      final joke = localJoke
          .map(
            (e) => JokeEntity(
              id: e.id,
              setup: e.setup,
              punchline: e.punchline,
              isFavorite: e.isFavorite,
            ),
          )
          .toList();

      return Right(joke);
    } on Exception {
      return Left(CacheFailure(errorMessage: 'This is a cache exception'));
    }
  }

  @override
  Future<Either<Failure, JokeEntity>> getLocalJokeById(String id) async {
    try {
      final localJoke = await localDataSource.getJokeFromRealm(id: id);

      final joke = JokeEntity(
        id: localJoke.id,
        setup: localJoke.setup,
        punchline: localJoke.punchline,
        isFavorite: localJoke.isFavorite,
      );

      return Right(joke);
    } on Exception {
      return Left(CacheFailure(errorMessage: 'This is a cache exception'));
    }
  }

  @override
  Future<Either<Failure, JokeEntity>> saveJokeToRealm(JokeEntity j) async {
    try {
      final JokeModel localJoke = JokeModel(
        id: j.id,
        setup: j.setup,
        type: 'general',
        punchline: j.punchline,
        isFavorite: j.isFavorite,
      );

      await localDataSource.persistJoke(localJoke);

      return Right(j);
    } on Exception {
      return Left(CacheFailure(errorMessage: 'This is a cache exception'));
    }
  }

  @override
  Future<Either<Failure, JokeEntity>> deleteJokeFromRealm(String id) async {
    try {
      await localDataSource.deleteJokeFromRealm(id);

      return Right(JokeEntity(
        id: id,
        setup: '',
        punchline: '',
        isFavorite: false,
      ));
    } on Exception {
      return Left(CacheFailure(errorMessage: 'This is a cache exception'));
    }
  }
}
