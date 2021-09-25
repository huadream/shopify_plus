import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopify_core/util/string_extension.dart';

/// Digital wallet, such as Apple Pay, which can be used for accelerated checkouts.
enum DigitalWallet {
  /// Android pay
  androidPay,

  /// Apple pay
  applePay,

  /// Google pay
  googlePay,

  /// Shopify pay
  shopifyPay,
}

/// {@macro json_converter}
class DigitalWalletJson extends JsonConverter<DigitalWallet, String> {
  /// {@macro json_converter}
  const DigitalWalletJson();

  static const _androidPayName = 'ANDROID_PAY';
  static const _applePayName = 'APPLE_PAY';
  static const _googlePayName = 'GOOGLE_PAY';
  static const _shopifyPayName = 'SHOPIFY_PAY';

  @override
  DigitalWallet fromJson(String json) {
    switch (json.toLowerCase()) {
      case _androidPayName:
        return DigitalWallet.androidPay;
      case _applePayName:
        return DigitalWallet.applePay;
      case _googlePayName:
        return DigitalWallet.googlePay;
      case _shopifyPayName:
        return DigitalWallet.shopifyPay;
      default:
        throw Exception('Unknown DigitalWallet: $json');
    }
  }

  @override
  String toJson(DigitalWallet object) => object.name;
}

/// {@macro enum_x}
extension DigitalWalletX on DigitalWallet {
  /// {@macro enum_x.map}
  T map<T>({
    required T androidPay,
    required T applePay,
    required T googlePay,
    required T shopifyPay,
  }) {
    switch (this) {
      case DigitalWallet.androidPay:
        return androidPay;
      case DigitalWallet.applePay:
        return applePay;
      case DigitalWallet.googlePay:
        return googlePay;
      case DigitalWallet.shopifyPay:
        return shopifyPay;
    }
  }

  /// {@macro enum_x.name}
  String get name {
    return map(
      androidPay: DigitalWalletJson._androidPayName,
      applePay: DigitalWalletJson._applePayName,
      googlePay: DigitalWalletJson._googlePayName,
      shopifyPay: DigitalWalletJson._shopifyPayName,
    );
  }

  /// {@macro enum_x.displayName}
  String get displayName => name.capitalize();
}
