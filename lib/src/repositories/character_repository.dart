import 'package:dio/dio.dart';

import '../errors/api_result.dart';
import '../models/character/character_models.dart';

class CharacterRepository {
  const CharacterRepository(this._dio);
  final Dio _dio;

  Result<CharacterPage> getAll(
          {int page = 1, CharacterFilter filter = const CharacterFilter()}) =>
      executeApiCall(() async {
        final response = await _dio.get('/character', queryParameters: {
          'page': page,
          if (filter.name != null) 'name': filter.name,
          if (filter.status != null) 'status': filter.status!.name,
        });
        return CharacterPageModel.fromJson(response.data, page: page)
            .toEntity();
      });
}
