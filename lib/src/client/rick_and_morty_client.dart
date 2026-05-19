import 'package:dio/dio.dart';

import '../http/http_client.dart';
import '../repositories/character_repository.dart';
import '../repositories/episode_repository.dart';
import '../repositories/location_repository.dart';

class RickAndMortyClient {
  RickAndMortyClient() : _dio = createDio();

  final Dio _dio;

  late final characters = CharacterRepository(_dio);
  late final episodes = EpisodeRepository(_dio);
  late final locations = LocationRepository(_dio);
}
