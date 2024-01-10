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
}