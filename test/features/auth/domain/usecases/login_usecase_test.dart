import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:investment_tracker/features/auth/domain/entities/auth_response_entity.dart';
import 'package:investment_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:investment_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:investment_tracker/features/auth/domain/usecases/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

// Generate mocks using build_runner:
// flutter pub run build_runner build
@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    final testUser = UserEntity(
      id: '1',
      email: testEmail,
      username: 'testuser',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    final testAuthResponse = AuthResponseEntity(
      accessToken: 'access_token',
      refreshToken: 'refresh_token',
      user: testUser,
    );

    test('should successfully login with valid credentials', () async {
      // Arrange
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => testAuthResponse);

      // Act
      final result = await useCase(email: testEmail, password: testPassword);

      // Assert
      expect(result, testAuthResponse);
      verify(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when email is empty', () async {
      // Act & Assert
      expect(
        () => useCase(email: '', password: testPassword),
        throwsException,
      );
      verifyNever(mockRepository.login(
        email: any,
        password: any,
      ));
    });

    test('should throw exception when password is empty', () async {
      // Act & Assert
      expect(
        () => useCase(email: testEmail, password: ''),
        throwsException,
      );
      verifyNever(mockRepository.login(
        email: any,
        password: any,
      ));
    });

    test('should throw exception when email format is invalid', () async {
      // Act & Assert
      expect(
        () => useCase(email: 'invalid-email', password: testPassword),
        throwsException,
      );
      verifyNever(mockRepository.login(
        email: any,
        password: any,
      ));
    });

    test('should throw exception when password is too short', () async {
      // Act & Assert
      expect(
        () => useCase(email: testEmail, password: '12345'),
        throwsException,
      );
      verifyNever(mockRepository.login(
        email: any,
        password: any,
      ));
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => useCase(email: testEmail, password: testPassword),
        throwsException,
      );
      verify(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);
    });
  });
}
