import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

import 'jokes_entity.dart';

abstract class JokeRepo {
  Future<Either<Failure, JokeEntity>> getRandomRemoteJoke({String endpoint});
  Future<Either<Failure, List<JokeEntity>>> getAllLocalJoke();
  Future<Either<Failure, JokeEntity>> getLocalJokeById(String id);
  Future<Either<Failure, JokeEntity>> saveJokeToRealm(JokeEntity joke);
  Future<Either<Failure, JokeEntity>> deleteJokeFromRealm(String id);
}
