import 'package:flutter/material.dart';

class StatBar extends StatelessWidget implements PreferredSizeWidget {
  final String pokemonName;

  const StatBar({super.key, required this.pokemonName});

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(pokemonName),
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    );
  }
}
