import 'package:flutter/material.dart';
import 'player_service.dart';

class PlayerListSelector extends StatefulWidget {
  const PlayerListSelector({Key? key}) : super(key: key);

  @override
  _PlayerListSelectorState createState() => _PlayerListSelectorState();
}

class _PlayerListSelectorState extends State<PlayerListSelector> {
  final PlayerService _playerService = PlayerService();
  final List<PlayerWithId> _selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz zawodników'),
      ),
      body: StreamBuilder<List<PlayerWithId>>(
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

                return ListTile(
                  title: Text('${player.firstName} ${player.lastName}'),
                  subtitle: Text(player.age != null ? 'Wiek: ${player.age}' : 'Wiek: nie podano'),
                  trailing: Checkbox(
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
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedPlayers);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}