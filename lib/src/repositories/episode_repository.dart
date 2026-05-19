import 'package:dio/dio.dart';

import '../errors/api_result.dart';
import '../models/episode/episode_models.dart';

class EpisodeRepository {
  const EpisodeRepository(this._dio);

  final Dio _dio;

  Result<EpisodePage> getAll({
    int page = 1,
    String? name,
  }) =>
      executeApiCall(() async {
        final response = await _dio.get(
          '/episode',
          queryParameters: {
            'page': page,
            if (name != null && name.isNotEmpty) 'name': name,
          },
        );
        return EpisodePageModel.fromJson(
          response.data as Map<String, dynamic>,
          page: page,
        ).toEntity();
      });
}
