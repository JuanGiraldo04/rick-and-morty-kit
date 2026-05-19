import 'package:dio/dio.dart';

import '../errors/api_result.dart';
import '../models/location/location_models.dart';

class LocationRepository {
  const LocationRepository(this._dio);

  final Dio _dio;

  Result<LocationPage> getAll({
    int page = 1,
    String? name,
  }) =>
      executeApiCall(() async {
        final response = await _dio.get(
          '/location',
          queryParameters: {
            'page': page,
            if (name != null && name.isNotEmpty) 'name': name,
          },
        );
        return LocationPageModel.fromJson(
          response.data as Map<String, dynamic>,
          page: page,
        ).toEntity();
      });
}
