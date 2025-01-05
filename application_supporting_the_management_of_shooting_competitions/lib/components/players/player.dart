class Player {
  final String id;
  final String firstName;
  final String lastName;
  final String? age;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
  return Player(
    // Securing it in case of an empty ID field
    id: map['id'] ?? 'Brak ID', 
    firstName: map['firstName'] ?? 'Nieznane imię',
    lastName: map['lastName'] ?? 'Nieznane nazwisko',
    age: map['age'],
  );
}
}