import 'package:flutter/material.dart';

class MoveList extends StatelessWidget {
  final List<String> moves;

  const MoveList({super.key, required this.moves});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Golpes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...moves.map(
              (move) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sports_martial_arts,
                      size: 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(move, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
