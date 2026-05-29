# rick_and_morty_kit — Example

App de ejemplo que demuestra el funcionamiento del paquete [`rick_and_morty_kit`](../).

---

## Qué demuestra

- Instanciar `RickAndMortyClient` y consumir los tres endpoints disponibles
- Manejo de estados: carga, éxito y error con reintento
- Búsqueda de personajes por nombre
- Navegación al detalle de un personaje
- Refresco con pull-to-refresh

---

## Cómo ejecutar

```bash
cd example
flutter pub get
flutter run
```

No requiere configuración adicional. El paquete apunta al directorio padre con `path: ../`.

---

## Estructura

```
lib/
├── main.dart                    # App + navegación principal
├── pages/
│   ├── characters_page.dart     # Listado y búsqueda de personajes
│   ├── character_detail_page.dart
│   ├── episodes_page.dart
│   └── locations_page.dart
└── widgets/
    └── error_view.dart          # Widget compartido de error + retry
```

---

## Nota

Esta app usa únicamente `FutureBuilder` y `setState`. No tiene gestor de estado ni arquitectura adicional, ya que su único propósito es mostrar cómo se consume el paquete con el mínimo de código posible.