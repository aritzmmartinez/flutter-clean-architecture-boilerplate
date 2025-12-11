/// Two Factor entity - Contains 2FA setup information
class TwoFactorEntity {
  final String secret;
  final String qrCodeUrl;
  final List<String> backupCodes;

  const TwoFactorEntity({
    required this.secret,
    required this.qrCodeUrl,
    required this.backupCodes,
  });
}
