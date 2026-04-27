import 'package:flutter/material.dart';

class BattlePanel extends StatefulWidget {
  final String pokemonName;
  final int initialLevel;
  final void Function(int newLevel) onLevelChanged;

  const BattlePanel({
    super.key,
    required this.pokemonName,
    required this.initialLevel,
    required this.onLevelChanged,
  });

  @override
  State<BattlePanel> createState() => _BattlePanelState();
}

class _BattlePanelState extends State<BattlePanel> {
  late int hp;
  int xp = 0;
  late int nivel;

  static const int _maxHp = 100;
  static const int _xpPerLevel = 100;

  @override
  void initState() {
    super.initState();
    hp = _maxHp;
    nivel = widget.initialLevel;
  }

  void _attack() {
    setState(() {
      hp = (hp - 20).clamp(0, _maxHp);
      xp += 10;

      if (xp >= _xpPerLevel) {
        nivel++;
        xp = 0;
        widget.onLevelChanged(nivel);
      }
    });
  }

  void _usePotion() {
    setState(() {
      hp = (hp + 30).clamp(0, _maxHp);
    });
  }

  Color _getHpColor() {
    if (hp > 60) return Colors.green;
    if (hp > 30) return Colors.yellow;
    return Colors.red;
  }

  String? _getStatusMessage() {
    if (hp == 0) return '${widget.pokemonName} desmaiou!';
    if (hp <= 30) return 'HP crítico!';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool canAttack = hp > 0;
    final bool canUsePotion = hp < _maxHp;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HP $hp/$_maxHp', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: hp / _maxHp.toDouble(),
              color: _getHpColor(),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'XP $xp/$_xpPerLevel — Nível $nivel',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: xp / _xpPerLevel.toDouble(),
              color: Colors.indigo,
              backgroundColor: Colors.grey.shade300,
            ),
            if (_getStatusMessage() != null) ...[
              const SizedBox(height: 12),
              Text(
                _getStatusMessage()!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hp == 0 ? Colors.red.shade700 : Colors.orange,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: canAttack ? _attack : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade700,
                      disabledForegroundColor: Colors.grey.shade400,
                    ),
                    child: const Text('Atacar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canUsePotion ? _usePotion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade700,
                      disabledForegroundColor: Colors.grey.shade400,
                    ),
                    child: const Text('Usar poção'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
