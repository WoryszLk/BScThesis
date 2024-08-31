import 'package:flutter/material.dart';

class Player {
  String firstName;
  String lastName;
  String? age;

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
  Player? _editingPlayer;

  void _addOrEditPlayer() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_editingPlayer == null) {
          _players.add(
            Player(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              age: _ageController.text.isNotEmpty ? _ageController.text : null,
            ),
          );
        } else {
          _editingPlayer!.firstName = _firstNameController.text;
          _editingPlayer!.lastName = _lastNameController.text;
          _editingPlayer!.age = _ageController.text.isNotEmpty ? _ageController.text : null;
          _editingPlayer = null;
        }
        _clearForm();
      });
    }
  }

  void _editPlayer(Player player) {
    setState(() {
      _editingPlayer = player;
      _firstNameController.text = player.firstName;
      _lastNameController.text = player.lastName;
      _ageController.text = player.age ?? '';
    });
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _ageController.clear();
    _editingPlayer = null;
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
            // Formularz dodawania/edycji zawodnika
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
                    onPressed: _addOrEditPlayer,
                    child: Text(_editingPlayer == null ? 'Dodaj zawodnika' : 'Zapisz zmiany'),
                  ),
                  if (_editingPlayer != null)
                    TextButton(
                      onPressed: _clearForm,
                      child: const Text('Anuluj edycję'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // Lista dodanych zawodników z możliwością edycji
            Expanded(
              child: _players.isNotEmpty
                  ? ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        final player = _players[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          child: ListTile(
                            title: Text('${player.firstName} ${player.lastName}'),
                            subtitle: player.age != null
                                ? Text('Wiek: ${player.age}')
                                : const Text('Wiek: nie podano'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editPlayer(player);
                              },
                            ),
                          ),
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
