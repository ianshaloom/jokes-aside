import '../../../core/constants/constant.dart';
import '../domain/jokes_entity.dart';

class JokeModel extends JokeEntity {
  const JokeModel({
    required String id,
    required String type,
    required String setup,
    required String punchline,
    required bool isFavorite,
  }) : super(
          id: id,
          setup: setup,
          punchline: punchline,
          isFavorite: isFavorite,
        );

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(
      id: json[idKey].toString(),
      type: json[typeKey],
      setup: json[setupKey],
      punchline: json[punchlineKey],
      isFavorite: false,
    );
  }
}
