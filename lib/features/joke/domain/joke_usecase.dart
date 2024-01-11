import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

import 'joke_repo.dart';
import 'jokes_entity.dart';

class GetJokeUsecase {
  final JokeRepo jokeRepository;

  GetJokeUsecase(this.jokeRepository);

  Future<Either<Failure, JokeEntity>> call({required String endpoint}) async {
    return await jokeRepository.getRandomRemoteJoke(endpoint: endpoint);
  }
  
  Future<Either<Failure, List<JokeEntity>>> getAllLocalJoke() async {
    return await jokeRepository.getAllLocalJoke();
  }
  
  Future<Either<Failure, JokeEntity>> getLocalJokeById(String id) async {
    return await jokeRepository.getLocalJokeById(id);
  }
  
  Future<Either<Failure, JokeEntity>> saveJokeToRealm(JokeEntity joke) async {
    return await jokeRepository.saveJokeToRealm(joke);
  }
  
  Future<Either<Failure, JokeEntity>> deleteJokeFromRealm(String id) async {
    return await jokeRepository.deleteJokeFromRealm(id);
  }
}