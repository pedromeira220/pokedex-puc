import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPokemonScreen extends StatefulWidget {
  const NewPokemonScreen({super.key});

  @override
  State<NewPokemonScreen> createState() => _NewPokemonScreenState();
}

class _NewPokemonScreenState extends State<NewPokemonScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _spriteIdController = TextEditingController();
  final _levelController = TextEditingController();

  final _spriteIdFocus = FocusNode();
  final _levelFocus = FocusNode();
  final _typeFocus = FocusNode();

  String _previewName = '';
  String? _selectedType;

  static const _types = [
    'Fogo', 'Água', 'Planta', 'Elétrico',
    'Normal', 'Psíquico', 'Gelo', 'Dragão',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _spriteIdController.dispose();
    _levelController.dispose();
    _spriteIdFocus.dispose();
    _levelFocus.dispose();
    _typeFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance.collection('pokemons').add({
      'name': _nameController.text.trim(),
      'spriteId': int.parse(_spriteIdController.text.trim()),
      'level': int.parse(_levelController.text.trim()),
      'types': [_selectedType!],
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pokémon'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_previewName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Cadastrando: $_previewName…',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
              ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Pokémon',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => setState(() => _previewName = v.trim()),
                    onFieldSubmitted: (_) => _spriteIdFocus.requestFocus(),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
                      if (v.trim().length < 2) return 'Mínimo 2 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _spriteIdController,
                    focusNode: _spriteIdFocus,
                    decoration: const InputDecoration(
                      labelText: 'Sprite ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _levelFocus.requestFocus(),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null) return 'Digite um número inteiro';
                      if (n < 1 || n > 1025) return 'Deve ser entre 1 e 1025';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _levelController,
                    focusNode: _levelFocus,
                    decoration: const InputDecoration(
                      labelText: 'Nível inicial',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _typeFocus.requestFocus(),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null) return 'Digite um número inteiro';
                      if (n < 1 || n > 100) return 'Deve ser entre 1 e 100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    focusNode: _typeFocus,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    items: _types
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v),
                    validator: (v) => v == null ? 'Selecione um tipo' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
