import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String pokemonName;
  final String spriteUrl;
  final List<String> typeNames;

  const PokemonCard({
    super.key,
    required this.pokemonName,
    required this.spriteUrl,
    required this.typeNames,
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
                  children: typeNames
                      .map(
                        (name) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            name,
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
