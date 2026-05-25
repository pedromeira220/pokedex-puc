import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon.dart';
import 'pokemon_screen.dart';
import 'new_pokemon_screen.dart';
import 'trainer_profile_screen.dart'; // ← novo

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final collection = FirebaseFirestore.instance.collection('pokemons');

  Future<Map<String, dynamic>?> _fetchTrainerProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('treinador')
        .get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokémon'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _fetchTrainerProfile(),
            builder: (context, snapshot) {
              final avatarIndex =
                  (snapshot.data?['avatarIndex'] as int?) ?? 0;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Perfil do Treinador',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TrainerProfileScreen(),
                      ),
                    );
                    // Força rebuild para atualizar o avatar ao voltar
                    setState(() {});
                  },
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.indigo.shade300,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/trainers/trainer_$avatarIndex.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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

      body: Column(
        children: [
          // ── Cabeçalho do treinador ──────────────────────────────────────
          FutureBuilder<Map<String, dynamic>?>(
            future: _fetchTrainerProfile(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final name =
                  (snapshot.data?['name'] as String?)?.isNotEmpty == true
                      ? snapshot.data!['name'] as String
                      : 'Treinador';
              final avatarIndex =
                  (snapshot.data?['avatarIndex'] as int?) ?? 0;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                color: Colors.indigo.shade50,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.indigo.shade100,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/trainers/trainer_$avatarIndex.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo,',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Lista de Pokémons ───────────────────────────────────────────
          Expanded(
            child: StreamBuilder(
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
                              builder: (_) =>
                                  PokemonScreen(pokemon: pokemon, docId: docId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}