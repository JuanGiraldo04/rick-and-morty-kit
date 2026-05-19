import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_kit/src/models/character/character_page.dart';
import 'package:rick_and_morty_kit/src/models/character/character_page_model.dart';

void main() {
  final tPageJson = {
    'info': {'count': 826, 'pages': 42, 'next': 'url', 'prev': null},
    'results': [
      {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'origin': {'name': 'Earth (C-137)', 'url': ''},
        'location': {'name': 'Citadel of Ricks', 'url': ''},
      },
    ],
  };

  group('CharacterPageModel', () {
    test('fromJson returns a CharacterPageModel with correct values', () {
      final model = CharacterPageModel.fromJson(tPageJson, page: 1);

      expect(model, isA<CharacterPageModel>());
      expect(model.currentPage, 1);
      expect(model.totalPages, 42);
      expect(model.characters.length, 1);
      expect(model.characters.first.name, 'Rick Sanchez');
    });

    test('toEntity returns CharacterPage with correct values', () {
      final entity = CharacterPageModel.fromJson(tPageJson, page: 2).toEntity();

      expect(entity, isA<CharacterPage>());
      expect(entity.currentPage, 2);
      expect(entity.totalPages, 42);
      expect(entity.characters.length, 1);
      expect(entity.characters.first.name, 'Rick Sanchez');
    });

    test('hasNextPage is true when currentPage < totalPages', () {
      final entity = CharacterPageModel.fromJson(tPageJson, page: 1).toEntity();
      expect(entity.hasNextPage, isTrue);
    });

    test('hasNextPage is false on last page', () {
      final entity =
          CharacterPageModel.fromJson(tPageJson, page: 42).toEntity();
      expect(entity.hasNextPage, isFalse);
    });
  });
}
