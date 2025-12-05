import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/models/player.dart';

void main() {
  group('Player', () {
    test('should create player with id and name', () {
      final player = Player(id: '1', name: 'Alice');

      expect(player.id, '1');
      expect(player.name, 'Alice');
      expect(player.assignedNumber, isNull);
    });

    test('should create player with assigned number', () {
      final player = Player(id: '1', name: 'Bob', assignedNumber: 42);

      expect(player.id, '1');
      expect(player.name, 'Bob');
      expect(player.assignedNumber, 42);
    });

    test('copyWith should create new instance with updated values', () {
      final player = Player(id: '1', name: 'Alice');
      final updatedPlayer = player.copyWith(assignedNumber: 50);

      expect(updatedPlayer.id, '1');
      expect(updatedPlayer.name, 'Alice');
      expect(updatedPlayer.assignedNumber, 50);
      expect(player.assignedNumber, isNull);
    });

    test('copyWith should preserve original values when not specified', () {
      final player = Player(id: '1', name: 'Alice', assignedNumber: 30);
      final updatedPlayer = player.copyWith(name: 'Bob');

      expect(updatedPlayer.id, '1');
      expect(updatedPlayer.name, 'Bob');
      expect(updatedPlayer.assignedNumber, 30);
    });

    test('two players with same values should be equal', () {
      final player1 = Player(id: '1', name: 'Alice', assignedNumber: 42);
      final player2 = Player(id: '1', name: 'Alice', assignedNumber: 42);

      expect(player1, equals(player2));
    });

    test('two players with different values should not be equal', () {
      final player1 = Player(id: '1', name: 'Alice');
      final player2 = Player(id: '2', name: 'Bob');

      expect(player1, isNot(equals(player2)));
    });
  });
}
