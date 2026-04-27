import 'package:flutter/material.dart';
import 'package:pokemon_app/pokemon.dart';
import 'package:pokemon_app/pokemon_card.dart';
import 'package:pokemon_app/stat_bar.dart';
import 'package:pokemon_app/battle_panel.dart';
import 'package:pokemon_app/move_list.dart';

class PokemonScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonScreen({super.key, required this.pokemon});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  late int currentLevel;

  @override
  void initState() {
    super.initState();
    currentLevel = widget.pokemon.level;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: StatBar(pokemonName: widget.pokemon.name),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PokemonCard(
                pokemonName: widget.pokemon.name,
                spriteUrl: widget.pokemon.spriteUrl,
                typeIds: widget.pokemon.typeIds,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BattlePanel(
                  pokemonName: widget.pokemon.name,
                  initialLevel: currentLevel,
                  onLevelChanged: (newLevel) {
                    currentLevel = newLevel;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: MoveList(moves: widget.pokemon.moves),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, currentLevel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Encerrar Batalha',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
