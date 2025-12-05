class Player {
  final String id;
  final String name;
  final int? assignedNumber;

  const Player({
    required this.id,
    required this.name,
    this.assignedNumber,
  });

  Player copyWith({
    String? id,
    String? name,
    int? assignedNumber,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      assignedNumber: assignedNumber ?? this.assignedNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.id == id &&
        other.name == name &&
        other.assignedNumber == assignedNumber;
  }

  @override
  int get hashCode => Object.hash(id, name, assignedNumber);

  @override
  String toString() => 'Player(id: $id, name: $name, assignedNumber: $assignedNumber)';
}
