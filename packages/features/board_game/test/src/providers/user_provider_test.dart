import 'package:flutter_test/flutter_test.dart';
import 'package:board_game/src/providers/user/user_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_repository/state_repository.dart';
import 'package:user_remote_repository/user_remote_repository.dart';

class MockRemoteUserRepository extends Mock implements UserRemoteRepository {}

class MockStateRepository extends Mock implements StateRepository {}

void main() {
  final repository = MockRemoteUserRepository();
  final stateRepository = MockStateRepository();

  final sut = UserNotifier(repository, stateRepository);

  group('UserProvider', () {
    group('isEmail', () {
      test('retourne true pour une adresse email valide simple', () {
        expect(sut.isEmail('test@example.com'), isTrue);
      });

      test('retourne false pour une adresse email avec des caractères spéciaux',
          () {
        expect(sut.isEmail('user.name+tag+sorting@example.com'), isFalse);
      });

      test('retourne false pour une adresse email sans @', () {
        expect(sut.isEmail('invalid-email.com'), isFalse);
      });

      test('retourne false pour une adresse email avec un domaine invalide',
          () {
        expect(sut.isEmail('user@.invalid.com'), isFalse);
      });

      test('retourne false pour une chaîne vide', () {
        expect(sut.isEmail(''), isFalse);
      });

      test('retourne false pour une adresse email avec des espaces', () {
        expect(sut.isEmail('user @example.com'), isFalse);
      });

      test('retourne true pour une adresse email avec des sous-domaines', () {
        expect(sut.isEmail('user@mail.example.co.uk'), isTrue);
      });

      test(
          'retourne false pour une adresse email avec des caractères invalides',
          () {
        expect(sut.isEmail('user@exa mple.com'), isFalse);
      });

      test('retourne false pour une adresse email avec un TLD trop court', () {
        expect(sut.isEmail('user@example.c'),
            isFalse); // Selon la regex simplifiée
      });

      test(
          'retourne true pour une adresse email avec des chiffres dans le domaine',
          () {
        expect(sut.isEmail('user123@example123.com'), isTrue);
      });
    });
  });
}
