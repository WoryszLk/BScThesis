import 'package:flutter/material.dart';

class Player {
  final String firstName;
  final String lastName;
  final String? age;

  Player({required this.firstName, required this.lastName, this.age});
}

class PlayerList extends StatefulWidget {
  const PlayerList({super.key});

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final List<Player> _players = [];

  void _addPlayer() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _players.add(
          Player(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            age: _ageController.text.isNotEmpty ? _ageController.text : null,
          ),
        );
        // Wyczyść formularz po dodaniu zawodnika
        _firstNameController.clear();
        _lastNameController.clear();
        _ageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formularz dodawania zawodnika
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
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
                    controller: _lastNameController,
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
                    controller: _ageController,
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
                    onPressed: _addPlayer,
                    child: const Text('Dodaj zawodnika'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // Lista dodanych zawodników
            Expanded(
              child: _players.isNotEmpty
                  ? ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        final player = _players[index];
                        return ListTile(
                          title: Text('${player.firstName} ${player.lastName}'),
                          subtitle: player.age != null
                              ? Text('Wiek: ${player.age}')
                              : const Text('Wiek: nie podano'),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Brak dodanych zawodników.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
