import '../../domain/entities/two_factor_entity.dart';

/// Two Factor Model - Extends TwoFactorEntity
/// Note: Renamed from Enable2FAModel for consistency
class TwoFactorModel extends TwoFactorEntity {
  const TwoFactorModel({
    required super.secret,
    required String qrCodeUrl,
    required super.backupCodes,
  }) : super(qrCodeUrl: qrCodeUrl);

  // Legacy alias for backwards compatibility
  String get qrCode => qrCodeUrl;

  factory TwoFactorModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorModel(
      secret: json['secret'] as String,
      qrCodeUrl: json['qr_code'] as String,
      backupCodes: (json['backup_codes'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secret': secret,
      'qr_code': qrCodeUrl,
      'backup_codes': backupCodes,
    };
  }
}

/// Legacy alias for backwards compatibility
@Deprecated('Use TwoFactorModel instead')
typedef Enable2FAModel = TwoFactorModel;
