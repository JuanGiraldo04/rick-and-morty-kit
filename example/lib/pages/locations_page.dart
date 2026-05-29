import 'package:flutter/material.dart';
import 'package:rick_and_morty_kit/rick_and_morty_kit.dart';

import '../main.dart';
import '../widgets/error_view.dart';

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
    _future = client.locations.getAll();
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
