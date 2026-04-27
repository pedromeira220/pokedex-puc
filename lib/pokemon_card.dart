import 'package:flutter/material.dart';

const _typeNames = {
  1: 'Normal',
  2: 'Fighting',
  3: 'Flying',
  4: 'Poison',
  5: 'Ground',
  6: 'Rock',
  7: 'Bug',
  8: 'Ghost',
  9: 'Steel',
  10: 'Fire',
  11: 'Water',
  12: 'Grass',
  13: 'Electric',
  14: 'Psychic',
  15: 'Ice',
  16: 'Dragon',
  17: 'Dark',
  18: 'Fairy',
};

class PokemonCard extends StatelessWidget {
  final String pokemonName;
  final String spriteUrl;
  final List<int> typeIds;

  const PokemonCard({
    super.key,
    required this.pokemonName,
    required this.spriteUrl,
    required this.typeIds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.indigo.shade50,
              backgroundImage: NetworkImage(spriteUrl),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemonName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: typeIds
                      .map(
                        (id) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            _typeNames[id] ?? 'Type $id',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
