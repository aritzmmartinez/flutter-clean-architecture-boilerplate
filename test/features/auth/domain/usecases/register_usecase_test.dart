import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:investment_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:investment_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:investment_tracker/features/auth/domain/usecases/register_usecase.dart';

import 'register_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    const testEmail = 'test@example.com';
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testFullName = 'Test User';

    final testUser = UserEntity(
      id: '1',
      email: testEmail,
      username: testUsername,
      fullName: testFullName,
      isActive: true,
      isVerified: false,
      createdAt: DateTime.now(),
    );

    test('should successfully register with valid data', () async {
      // Arrange
      when(mockRepository.register(
        email: testEmail,
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
      )).thenAnswer((_) async => testUser);

      // Act
      final result = await useCase(
        email: testEmail,
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
      );

      // Assert
      expect(result, testUser);
      verify(mockRepository.register(
        email: testEmail,
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
      )).called(1);
    });

    test('should throw exception when email is empty', () async {
      // Act & Assert
      expect(
        () => useCase(
          email: '',
          username: testUsername,
          password: testPassword,
        ),
        throwsException,
      );
    });

    test('should throw exception when username is too short', () async {
      // Act & Assert
      expect(
        () => useCase(
          email: testEmail,
          username: 'ab',
          password: testPassword,
        ),
        throwsException,
      );
    });

    test('should throw exception when username contains invalid characters',
        () async {
      // Act & Assert
      expect(
        () => useCase(
          email: testEmail,
          username: 'test user!',
          password: testPassword,
        ),
        throwsException,
      );
    });

    test('should throw exception when password is too short', () async {
      // Act & Assert
      expect(
        () => useCase(
          email: testEmail,
          username: testUsername,
          password: '1234567',
        ),
        throwsException,
      );
    });
  });
}
