import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pokemons = [
    Pokemon(
      name: 'Gengar',
      spriteId: 94,
      typeIds: [8, 4],
      level: 42,
      moves: ['Hypnosis', 'Dream Eater', 'Shadow Ball', 'Lick'],
    ),
    Pokemon(
      name: 'Charizard',
      spriteId: 6,
      typeIds: [10, 3],
      level: 38,
      moves: ['Flamethrower', 'Fly', 'Slash', 'Dragon Rage'],
    ),
    Pokemon(
      name: 'Pikachu',
      spriteId: 25,
      typeIds: [13],
      level: 25,
      moves: ['Thunderbolt', 'Quick Attack', 'Iron Tail', 'Volt Tackle'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokémon'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pokemon.spriteUrl),
                backgroundColor: Colors.transparent,
              ),
              title: Text(pokemon.name),
              subtitle: Text('Level ${pokemon.level}'),
              onTap: () async {
                final novoNivel = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PokemonScreen(pokemon: pokemon),
                  ),
                );

                if (novoNivel != null) {
                  setState(() {
                    pokemon.level = novoNivel;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
