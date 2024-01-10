import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

import 'jokes_entity.dart';

abstract class JokeRepo {
  Future<Either<Failure, JokeEntity>> getRandomRemoteJoke({String endpoint});
  Future<Either<Failure, List<JokeEntity>>> getAllLocalJoke();
}
