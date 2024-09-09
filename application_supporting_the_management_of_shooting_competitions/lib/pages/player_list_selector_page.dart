import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/add_player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/player_service.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({Key? key}) : super(key: key);

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final PlayerService _playerService = PlayerService();
  Player? _editingPlayer;

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
            AddPlayerForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              ageController: _ageController,
              playerService: _playerService,
              editingPlayer: _editingPlayer,
              onClearForm: _clearForm,
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
                                    _editPlayer(player);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _playerService.deletePlayer(playerWithId.id);
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
    );
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