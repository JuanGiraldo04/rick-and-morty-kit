import 'package:flutter/material.dart';
import 'package:rick_and_morty_kit/rick_and_morty_kit.dart';

(String, Color) statusInfo(CharacterStatus status) => switch (status) {
  CharacterStatus.alive => ('Alive', Colors.green),
  CharacterStatus.dead => ('Dead', Colors.red),
  CharacterStatus.unknown => ('Unknown', Colors.grey),
};

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = statusInfo(character.status);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(
                character.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(character.image, fit: BoxFit.cover),
                  // Gradiente negro en la parte inferior
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.5, 1.0],
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoTable(character: character),
                  const SizedBox(height: 24),
                  const Text(
                    'Resumen',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _buildSummary(character),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildSummary(Character c) {
    final status = statusInfo(c.status).$1.toLowerCase();
    final gender = switch (c.gender) {
      CharacterGender.female => 'femenino',
      CharacterGender.male => 'masculino',
      CharacterGender.genderless => 'sin género',
      CharacterGender.unknown => 'desconocido',
    };
    return '${c.name} es un personaje ${c.species.toLowerCase()} con estado $status y género $gender.';
  }
}

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          _InfoRow(label: 'Especie', value: character.species),
          _InfoRow(
            label: 'Genero',
            value: switch (character.gender) {
              CharacterGender.female => 'Female',
              CharacterGender.male => 'Male',
              CharacterGender.genderless => 'Genderless',
              CharacterGender.unknown => 'Unknown',
            },
          ),
          _InfoRow(label: 'Origen', value: character.origin.name),
          _InfoRow(label: 'Ultima ubicacion', value: character.location.name),
          _InfoRow(label: 'ID', value: '${character.id}', isLast: true),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
