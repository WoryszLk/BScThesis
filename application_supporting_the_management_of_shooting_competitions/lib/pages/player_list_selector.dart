import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/add_player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';

class PlayerListSelector extends StatefulWidget {
  const PlayerListSelector({Key? key}) : super(key: key);

  @override
  _PlayerListSelectorState createState() => _PlayerListSelectorState();
}

class _PlayerListSelectorState extends State<PlayerListSelector> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final PlayerService _playerService = PlayerService();
  PlayerWithId? _editingPlayer;
  final List<PlayerWithId> _selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzaj zawodnikami'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formularz dodawania/edycji zawodnika
            AddPlayerForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              ageController: _ageController,
              playerService: _playerService,
              editingPlayer: _editingPlayer?.player,
              onClearForm: _clearForm,
              onSavePlayer: _savePlayer,
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: StreamBuilder<List<PlayerWithId>>(
                stream: _playerService.getPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final playersWithIds = snapshot.data!;
                    return ListView.builder(
                      itemCount: playersWithIds.length,
                      itemBuilder: (context, index) {
                        final playerWithId = playersWithIds[index];
                        final player = playerWithId.player;
                        final isSelected = _selectedPlayers.contains(playerWithId);

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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edycja zawodnika
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editPlayer(playerWithId);
                                  },
                                ),
                                // Usunicie zawodnika
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _playerService.deletePlayer(playerWithId.id);
                                  },
                                ),
                                // Wybieranie zawodnika
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedPlayers.add(playerWithId);
                                      } else {
                                        _selectedPlayers.remove(playerWithId);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Wystąpił błąd: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedPlayers);
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  // Funkcja do edycji zawodnika
  void _editPlayer(PlayerWithId playerWithId) {
    setState(() {
      _editingPlayer = playerWithId;
      _firstNameController.text = playerWithId.player.firstName;
      _lastNameController.text = playerWithId.player.lastName;
      _ageController.text = playerWithId.player.age ?? '';
    });
  }

  // Funkcja do zapisu lub aktualizacji zawodnika
  void _savePlayer() {
    if (_formKey.currentState!.validate()) {
      if (_editingPlayer == null) {
        _playerService.addPlayer(
          Player(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            age: _ageController.text.isNotEmpty ? _ageController.text : null,
          ),
        );
      } else {
        _playerService.updatePlayer(
          _editingPlayer!.id,
          Player(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            age: _ageController.text.isNotEmpty ? _ageController.text : null,
          ),
        );
      }
      _clearForm();
    }
  }

  // Funkcja do czyszczenia formularza
  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _ageController.clear();
    setState(() {
      _editingPlayer = null;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}