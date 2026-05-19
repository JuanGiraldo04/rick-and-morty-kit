# rick_and_morty_kit

Paquete Dart para consumir la [Rick and Morty API](https://rickandmortyapi.com) con manejo de errores integrado, modelos tipados y soporte de paginación.

---

## Características

- Consulta personajes, episodios y locaciones
- Manejo de errores integrado para fallos de red, servidor y recursos no encontrados
- Respuestas tipadas con enums para status y género
- Paginación lista para usar
- Búsqueda por nombre y filtro por status

---

## Instalación

Agrega la dependencia en tu `pubspec.yaml` apuntando al repositorio de GitHub:

```yaml
dependencies:
  rick_and_morty_kit:
    git:
      url: https://github.com/JuanGiraldo04/rick_and_morty_kit.git
```

Luego ejecuta:

```bash
flutter pub get
```

---

## Uso

### 1. Crear una instancia del cliente

```dart
import 'package:rick_and_morty_kit/rick_and_morty_kit.dart';

final client = RickAndMortyClient();
```

### 2. Consultar personajes

```dart
final result = await client.characters.getAll(page: 1);

switch (result) {
  case ApiSuccess(:final data):
    for (final character in data.characters) {
      print('${character.name} — ${character.status}');
    }
  case ApiError(:final failure):
    print(failure.userMessage);
}
```

### 3. Buscar por nombre y filtrar por status

```dart
final result = await client.characters.getAll(
  page: 1,
  filter: const CharacterFilter(
    name: 'Rick',
    status: CharacterStatus.alive,
  ),
);
```

### 4. Consultar episodios

```dart
final result = await client.episodes.getAll(page: 1);

switch (result) {
  case ApiSuccess(:final data):
    for (final episode in data.episodes) {
      print('${episode.code} — ${episode.name}');
    }
  case ApiError(:final failure):
    print(failure.userMessage);
}
```

### 5. Buscar episodios por nombre

```dart
final result = await client.episodes.getAll(name: 'Pilot');
```

### 6. Consultar locaciones

```dart
final result = await client.locations.getAll(page: 1);
```

### 7. Buscar locaciones por nombre

```dart
final result = await client.locations.getAll(name: 'Earth');
```

---

## Manejo de errores

Cada respuesta viene envuelta en `ApiResult<T>`, una sealed class con dos subtipos:

| Tipo | Descripción |
|---|---|
| `ApiSuccess<T>` | Contiene `data` con el resultado |
| `ApiError<T>` | Contiene `failure` con el error |

Tipos de `Failure` disponibles:

| Failure | Cuándo ocurre |
|---|---|
| `NetworkFailure` | Sin conexión a internet o timeout |
| `NotFoundFailure` | 404 — recurso no encontrado o búsqueda sin resultados |
| `UnauthorizedFailure` | 401 — no autorizado |
| `ServerErrorFailure` | 5xx — error del servidor |
| `UnknownFailure` | Cualquier otro error inesperado |

Cada `Failure` expone un getter `userMessage` con un mensaje legible para el usuario.

---

## Modelos

### Character

| Campo | Tipo |
|---|---|
| `id` | `int` |
| `name` | `String` |
| `status` | `CharacterStatus` |
| `species` | `String` |
| `type` | `String` |
| `gender` | `CharacterGender` |
| `image` | `String` |
| `origin` | `CharacterLocation` |
| `location` | `CharacterLocation` |

**CharacterStatus:** `alive`, `dead`, `unknown`

**CharacterGender:** `female`, `male`, `genderless`, `unknown`

### Episode

| Campo | Tipo |
|---|---|
| `id` | `int` |
| `name` | `String` |
| `airDate` | `String` |
| `code` | `String` |
| `characterCount` | `int` |

### Location

| Campo | Tipo |
|---|---|
| `id` | `int` |
| `name` | `String` |
| `type` | `String` |
| `dimension` | `String` |
| `residentCount` | `int` |

---

## Paginación

Todos los métodos `getAll()` retornan un objeto de página con información de paginación:

```dart
final result = await client.characters.getAll(page: 1);

if (result case ApiSuccess(:final data)) {
  print('Página ${data.currentPage} de ${data.totalPages}');
  print('Tiene siguiente página: ${data.hasNextPage}');
}
```

---

## Ejecutar el ejemplo

```bash
cd example
flutter pub get
flutter run
```

La app de ejemplo demuestra los estados de carga, éxito, error y reintento usando únicamente `FutureBuilder` y `setState`, sin dependencias de gestión de estado.

---

## Estructura del proyecto

```
lib/
├── rick_and_morty_kit.dart     # Barrel público
└── src/
    ├── client/
    │   └── rick_and_morty_client.dart
    ├── http/
    │   └── http_client.dart
    ├── errors/
    │   ├── failure.dart
    │   └── api_result.dart
    ├── models/
    │   ├── character/
    │   ├── episode/
    │   └── location/
    └── repositories/
        ├── character_repository.dart
        ├── episode_repository.dart
        └── location_repository.dart
```

---

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| dio | ^5.9.2 | Cliente HTTP |

---

## Licencia

MIT