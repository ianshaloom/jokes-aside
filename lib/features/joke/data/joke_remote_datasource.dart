import 'package:dio/dio.dart';

import '../../../core/constants/constant.dart';
import '../../../core/errors/exceptions.dart';

import 'joke_model.dart';

abstract class JokeRemoteDataSource {
  Future<JokeModel> getAJoke({String endpoint});
}

class JokeRemoteDataSourceImpl implements JokeRemoteDataSource {
  final Dio dio;
  JokeRemoteDataSourceImpl({required this.dio});

  @override
  Future<JokeModel> getAJoke({String? endpoint}) async {
    
    if (endpoint == null) {
      final response = await dio.get('$serverUrl$endpoint');

      if (response.statusCode != 200) {
        throw ServerException();
      }

      return JokeModel.fromJson(response.data);
    } else {
      final response = await dio.get('$serverUrl$getJoke');

      if (response.statusCode != 200) {
        throw ServerException();
      }

      return JokeModel.fromJson(response.data);
    }
  }
}
