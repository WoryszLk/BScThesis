import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/add_player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class PlayerListSelector extends StatefulWidget {
  final List<PlayerWithId> selectedPlayers;

  const PlayerListSelector({Key? key, required this.selectedPlayers}) : super(key: key);

  @override
  _PlayerListSelectorState createState() => _PlayerListSelectorState();
}

class _PlayerListSelectorState extends State<PlayerListSelector> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final Uuid _uuid = Uuid();

  PlayerWithId? _editingPlayer;
  late List<PlayerWithId> _localSelectedPlayers;

  @override
  void initState() {
    super.initState();
    _localSelectedPlayers = List.from(widget.selectedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzaj zawodnikami'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _importPlayersFromExcel,
            tooltip: 'Importuj zawodników z Excel',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AddPlayerForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              ageController: _ageController,
              playerService: PlayerService(),
              editingPlayer: _editingPlayer?.player,
              onClearForm: _clearForm,
              onSavePlayer: _savePlayer,
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: ListView.builder(
                itemCount: _localSelectedPlayers.length,
                itemBuilder: (context, index) {
                  final playerWithId = _localSelectedPlayers[index];
                  final player = playerWithId.player;
                  final isSelected = _localSelectedPlayers.contains(playerWithId);

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
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editPlayer(playerWithId);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _localSelectedPlayers.remove(playerWithId);
                              });
                            },
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _localSelectedPlayers.add(playerWithId);
                                } else {
                                  _localSelectedPlayers.remove(playerWithId);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _importPlayersFromExcel,
            label: const Text('Importuj z Excel'),
            icon: const Icon(Icons.upload_file),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context, _localSelectedPlayers);
            },
            label: const Text('Dalej'),
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  void _editPlayer(PlayerWithId playerWithId) {
    setState(() {
      _editingPlayer = playerWithId;
      _firstNameController.text = playerWithId.player.firstName;
      _lastNameController.text = playerWithId.player.lastName;
      _ageController.text = playerWithId.player.age ?? '';
    });
  }

  Future<void> _savePlayer() async {
    if (_formKey.currentState!.validate()) {
      if (_editingPlayer == null) {
        final newPlayer = Player(
          id: _uuid.v4(),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          age: _ageController.text.isNotEmpty ? _ageController.text : null,
        );

        setState(() {
          _localSelectedPlayers.add(PlayerWithId(id: newPlayer.id, player: newPlayer));
        });
      } else {
        setState(() {
          final index = _localSelectedPlayers.indexWhere((p) => p.id == _editingPlayer!.id);
          if (index != -1) {
            _localSelectedPlayers[index] = PlayerWithId(
              id: _editingPlayer!.id,
              player: Player(
                id: _editingPlayer!.id,
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                age: _ageController.text.isNotEmpty ? _ageController.text : null,
              ),
            );
          }
        });
      }
      _clearForm();
    }
  }

  Future<void> _importPlayersFromExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        final bytes = result.files.single.bytes;

        if (bytes != null) {
          var excel = Excel.decodeBytes(bytes);

          for (var table in excel.tables.keys) {
            for (var row in excel.tables[table]!.rows.skip(1)) {
              if (row.length >= 2) {
                final firstName = row[0]?.value.toString() ?? '';
                final lastName = row[1]?.value.toString() ?? '';
                final age = row.length > 2 && row[2]?.value.toString().isNotEmpty == true
                    ? row[2]?.value.toString()
                    : null;

                if (firstName.isNotEmpty && lastName.isNotEmpty) {
                  final newPlayer = Player(
                    id: _uuid.v4(),
                    firstName: firstName,
                    lastName: lastName,
                    age: age,
                  );

                  setState(() {
                    _localSelectedPlayers.add(PlayerWithId(id: newPlayer.id, player: newPlayer));
                  });
                }
              }
            }
          }
        } else {
          print("Brak dostępu do danych pliku.");
        }
      }
    } catch (e) {
      print("Błąd podczas importowania zawodników: $e");
    }
  }

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
