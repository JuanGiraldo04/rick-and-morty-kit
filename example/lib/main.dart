import 'package:flutter/material.dart';
import 'package:rick_and_morty_kit/rick_and_morty_kit.dart';

void main() => runApp(const ExampleApp());

final _client = RickAndMortyClient();

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Kit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExampleShell(),
    );
  }
}

class ExampleShell extends StatefulWidget {
  const ExampleShell({super.key});

  @override
  State<ExampleShell> createState() => _ExampleShellState();
}

class _ExampleShellState extends State<ExampleShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [CharactersPage(), EpisodesPage(), LocationsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Personajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_outlined),
            selectedIcon: Icon(Icons.tv),
            label: 'Episodios',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Locaciones',
          ),
        ],
      ),
    );
  }
}

// ── Characters ──────────────────────────────────────────────────────────────

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late Future<ApiResult<CharacterPage>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async => setState(() {
    _future = _client.characters.getAll();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _load,
        child: FutureBuilder<ApiResult<CharacterPage>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (snapshot.data) {
              ApiSuccess(:final data) => ListView.builder(
                itemCount: data.characters.length,
                itemBuilder: (context, index) {
                  final c = data.characters[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(c.image),
                    ),
                    title: Text(c.name),
                    subtitle: Text(c.species),
                    trailing: Text(switch (c.status) {
                      CharacterStatus.alive => '🟢',
                      CharacterStatus.dead => '🔴',
                      CharacterStatus.unknown => '⚪',
                    }),
                  );
                },
              ),
              ApiError(:final failure) => _ErrorView(
                message: failure.userMessage,
                onRetry: _load,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

// ── Episodes ─────────────────────────────────────────────────────────────────

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  late Future<ApiResult<EpisodePage>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async => setState(() {
    _future = _client.episodes.getAll();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Episodios'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _load,
        child: FutureBuilder<ApiResult<EpisodePage>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (snapshot.data) {
              ApiSuccess(:final data) => ListView.builder(
                itemCount: data.episodes.length,
                itemBuilder: (context, index) {
                  final e = data.episodes[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(e.code.split('E').last)),
                    title: Text(e.name),
                    subtitle: Text('${e.code} · ${e.airDate}'),
                    trailing: Text('${e.characterCount} pers.'),
                  );
                },
              ),
              ApiError(:final failure) => _ErrorView(
                message: failure.userMessage,
                onRetry: _load,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

// ── Locations ────────────────────────────────────────────────────────────────

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late Future<ApiResult<LocationPage>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async => setState(() {
    _future = _client.locations.getAll();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locaciones'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _load,
        child: FutureBuilder<ApiResult<LocationPage>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (snapshot.data) {
              ApiSuccess(:final data) => ListView.builder(
                itemCount: data.locations.length,
                itemBuilder: (context, index) {
                  final l = data.locations[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.location_on)),
                    title: Text(l.name),
                    subtitle: Text('${l.type} · ${l.dimension}'),
                    trailing: Text('${l.residentCount} hab.'),
                  );
                },
              ),
              ApiError(:final failure) => _ErrorView(
                message: failure.userMessage,
                onRetry: _load,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

// ── Shared ───────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
