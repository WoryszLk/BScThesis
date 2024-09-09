class Player {
  final String firstName;
  final String lastName;
  final String? age;

  Player({
    required this.firstName,
    required this.lastName,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age'],
    );
  }
}