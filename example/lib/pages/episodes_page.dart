import 'package:flutter/material.dart';
import 'package:rick_and_morty_kit/rick_and_morty_kit.dart';

import '../main.dart';
import '../widgets/error_view.dart';

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
    _future = client.episodes.getAll();
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
              ApiError(:final failure) => ErrorView(
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
