import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';
import 'new_pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final collection = FirebaseFirestore.instance.collection('pokemons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokémon'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewPokemonScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: collection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map;
              final docId = docs[index].id;
              final pokemon = Pokemon(
                name: data['name'] as String,
                spriteUrl: (data['spriteUrl'] as String?) ?? '',
                level: int.parse(data['level'].toString()),
                types: List<String>.from(data['types'] ?? []),
                moves: List<String>.from(data['moves'] ?? []),
              );
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pokemon.spriteUrl),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(pokemon.name),
                  subtitle: Text(
                    '${pokemon.typeNames.join(' · ')} — Lv ${pokemon.level}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await collection.doc(docId).delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonScreen(pokemon: pokemon, docId: docId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
