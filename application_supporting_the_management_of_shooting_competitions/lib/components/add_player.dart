import 'package:flutter/material.dart';
import 'player.dart';
import 'player_service.dart';

class AddPlayerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController ageController;
  final PlayerService playerService;
  final Player? editingPlayer;
  final VoidCallback onClearForm;
  final VoidCallback onSavePlayer; // Nowy callback

  const AddPlayerForm({
    Key? key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.ageController,
    required this.playerService,
    required this.onClearForm,
    required this.onSavePlayer, // Nowy callback
    this.editingPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(
              labelText: 'Imię',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Proszę podać imię';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nazwisko',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Proszę podać nazwisko';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: 'Wiek (opcjonalnie)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final int? age = int.tryParse(value);
                if (age == null || age < 0) {
                  return 'Proszę podać prawidłowy wiek';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: onSavePlayer, // Zapisanie zawodnika
            child: Text(editingPlayer == null ? 'Dodaj zawodnika' : 'Zapisz zmiany'),
          ),
          if (editingPlayer != null)
            TextButton(
              onPressed: onClearForm,
              child: const Text('Anuluj edycję'),
            ),
        ],
      ),
    );
  }
}