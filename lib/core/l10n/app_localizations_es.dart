import 'app_localizations.dart';

/// Spanish translations
class AppLocalizationsEs implements AppLocalizations {
  // Common
  @override
  String get appName => 'Rastreador de Inversiones';
  @override
  String get ok => 'Aceptar';
  @override
  String get cancel => 'Cancelar';
  @override
  String get save => 'Guardar';
  @override
  String get delete => 'Eliminar';
  @override
  String get edit => 'Editar';
  @override
  String get loading => 'Cargando...';
  @override
  String get error => 'Error';
  @override
  String get success => 'Éxito';
  @override
  String get confirm => 'Confirmar';
  @override
  String get yes => 'Sí';
  @override
  String get no => 'No';

  // Auth - Common
  @override
  String get email => 'Correo electrónico';
  @override
  String get password => 'Contraseña';
  @override
  String get username => 'Nombre de usuario';
  @override
  String get fullName => 'Nombre completo';
  @override
  String get login => 'Iniciar sesión';
  @override
  String get register => 'Registrarse';
  @override
  String get logout => 'Cerrar sesión';
  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  // Auth - Validation
  @override
  String get emailRequired => 'El correo es requerido';
  @override
  String get emailInvalid => 'Formato de correo inválido';
  @override
  String get passwordRequired => 'La contraseña es requerida';
  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 8 caracteres';
  @override
  String get usernameRequired => 'El nombre de usuario es requerido';
  @override
  String get usernameTooShort =>
      'El nombre de usuario debe tener al menos 3 caracteres';

  // Auth - Messages
  @override
  String get loginSuccess => 'Inicio de sesión exitoso';
  @override
  String get registerSuccess => 'Registro exitoso';
  @override
  String get logoutSuccess => 'Sesión cerrada exitosamente';
  @override
  String get invalidCredentials => 'Correo o contraseña inválidos';
  @override
  String get emailNotVerified => 'Por favor verifica tu correo';
  @override
  String get accountDisabled => 'La cuenta ha sido deshabilitada';

  // Auth - 2FA
  @override
  String get twoFactorAuth => 'Autenticación de Dos Factores';
  @override
  String get twoFactorCode => 'Código 2FA';
  @override
  String get enable2FA => 'Activar 2FA';
  @override
  String get disable2FA => 'Desactivar 2FA';
  @override
  String get setup2FA => 'Configurar 2FA';
  @override
  String get invalid2FACode => 'Código 2FA inválido';

  // Settings
  @override
  String get settings => 'Configuración';
  @override
  String get preferences => 'Preferencias';
  @override
  String get theme => 'Tema';
  @override
  String get language => 'Idioma';
  @override
  String get darkMode => 'Modo Oscuro';
  @override
  String get lightMode => 'Modo Claro';
  @override
  String get systemMode => 'Sistema';

  // Errors
  @override
  String get networkError => 'Sin conexión a internet';
  @override
  String get unknownError => 'Ocurrió un error inesperado';
  @override
  String get timeoutError => 'Tiempo de conexión agotado';
}
