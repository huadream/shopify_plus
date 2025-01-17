// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'payment_settings.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PaymentSettings _$PaymentSettingsFromJson(Map<String, dynamic> json) {
  return _PaymentSettings.fromJson(json);
}

/// @nodoc
class _$PaymentSettingsTearOff {
  const _$PaymentSettingsTearOff();

  _PaymentSettings call(
      {@CardBrandJson()
          required List<CardBrand> acceptedCardBrands,
      required String cardVaultUrl,
      @CountryCodeJson()
          required CountryCode countryCode,
      @CurrencyCodeJson()
          required CurrencyCode currencyCode,
      @CurrencyCodeJson()
          required List<CurrencyCode> enabledPresentmentCurrencies,
      String? shopifyPaymentsAccountId,
      @DigitalWalletJson()
          required List<DigitalWallet> supportedDigitalWallets}) {
    return _PaymentSettings(
      acceptedCardBrands: acceptedCardBrands,
      cardVaultUrl: cardVaultUrl,
      countryCode: countryCode,
      currencyCode: currencyCode,
      enabledPresentmentCurrencies: enabledPresentmentCurrencies,
      shopifyPaymentsAccountId: shopifyPaymentsAccountId,
      supportedDigitalWallets: supportedDigitalWallets,
    );
  }

  PaymentSettings fromJson(Map<String, Object> json) {
    return PaymentSettings.fromJson(json);
  }
}

/// @nodoc
const $PaymentSettings = _$PaymentSettingsTearOff();

/// @nodoc
mixin _$PaymentSettings {
  /// List of the card brands which the shop accepts.
  @CardBrandJson()
  List<CardBrand> get acceptedCardBrands => throw _privateConstructorUsedError;

  /// The url pointing to the endpoint to vault credit cards.
  String get cardVaultUrl => throw _privateConstructorUsedError;

  /// The country where the shop is located.
  @CountryCodeJson()
  CountryCode get countryCode => throw _privateConstructorUsedError;

  /// The three-letter code for the shop's primary currency.
  @CurrencyCodeJson()
  CurrencyCode get currencyCode => throw _privateConstructorUsedError;

  /// A list of enabled currencies (ISO 4217 format) that the shop accepts. Merchants can enable currencies from their Shopify Payments settings in the Shopify admin.
  @CurrencyCodeJson()
  List<CurrencyCode> get enabledPresentmentCurrencies =>
      throw _privateConstructorUsedError;

  /// The shop’s Shopify Payments account id.
  String? get shopifyPaymentsAccountId => throw _privateConstructorUsedError;

  /// List of the digital wallets which the shop supports.
  @DigitalWalletJson()
  List<DigitalWallet> get supportedDigitalWallets =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentSettingsCopyWith<PaymentSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSettingsCopyWith<$Res> {
  factory $PaymentSettingsCopyWith(
          PaymentSettings value, $Res Function(PaymentSettings) then) =
      _$PaymentSettingsCopyWithImpl<$Res>;
  $Res call(
      {@CardBrandJson() List<CardBrand> acceptedCardBrands,
      String cardVaultUrl,
      @CountryCodeJson() CountryCode countryCode,
      @CurrencyCodeJson() CurrencyCode currencyCode,
      @CurrencyCodeJson() List<CurrencyCode> enabledPresentmentCurrencies,
      String? shopifyPaymentsAccountId,
      @DigitalWalletJson() List<DigitalWallet> supportedDigitalWallets});
}

/// @nodoc
class _$PaymentSettingsCopyWithImpl<$Res>
    implements $PaymentSettingsCopyWith<$Res> {
  _$PaymentSettingsCopyWithImpl(this._value, this._then);

  final PaymentSettings _value;
  // ignore: unused_field
  final $Res Function(PaymentSettings) _then;

  @override
  $Res call({
    Object? acceptedCardBrands = freezed,
    Object? cardVaultUrl = freezed,
    Object? countryCode = freezed,
    Object? currencyCode = freezed,
    Object? enabledPresentmentCurrencies = freezed,
    Object? shopifyPaymentsAccountId = freezed,
    Object? supportedDigitalWallets = freezed,
  }) {
    return _then(_value.copyWith(
      acceptedCardBrands: acceptedCardBrands == freezed
          ? _value.acceptedCardBrands
          : acceptedCardBrands // ignore: cast_nullable_to_non_nullable
              as List<CardBrand>,
      cardVaultUrl: cardVaultUrl == freezed
          ? _value.cardVaultUrl
          : cardVaultUrl // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: countryCode == freezed
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as CountryCode,
      currencyCode: currencyCode == freezed
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as CurrencyCode,
      enabledPresentmentCurrencies: enabledPresentmentCurrencies == freezed
          ? _value.enabledPresentmentCurrencies
          : enabledPresentmentCurrencies // ignore: cast_nullable_to_non_nullable
              as List<CurrencyCode>,
      shopifyPaymentsAccountId: shopifyPaymentsAccountId == freezed
          ? _value.shopifyPaymentsAccountId
          : shopifyPaymentsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      supportedDigitalWallets: supportedDigitalWallets == freezed
          ? _value.supportedDigitalWallets
          : supportedDigitalWallets // ignore: cast_nullable_to_non_nullable
              as List<DigitalWallet>,
    ));
  }
}

/// @nodoc
abstract class _$PaymentSettingsCopyWith<$Res>
    implements $PaymentSettingsCopyWith<$Res> {
  factory _$PaymentSettingsCopyWith(
          _PaymentSettings value, $Res Function(_PaymentSettings) then) =
      __$PaymentSettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {@CardBrandJson() List<CardBrand> acceptedCardBrands,
      String cardVaultUrl,
      @CountryCodeJson() CountryCode countryCode,
      @CurrencyCodeJson() CurrencyCode currencyCode,
      @CurrencyCodeJson() List<CurrencyCode> enabledPresentmentCurrencies,
      String? shopifyPaymentsAccountId,
      @DigitalWalletJson() List<DigitalWallet> supportedDigitalWallets});
}

/// @nodoc
class __$PaymentSettingsCopyWithImpl<$Res>
    extends _$PaymentSettingsCopyWithImpl<$Res>
    implements _$PaymentSettingsCopyWith<$Res> {
  __$PaymentSettingsCopyWithImpl(
      _PaymentSettings _value, $Res Function(_PaymentSettings) _then)
      : super(_value, (v) => _then(v as _PaymentSettings));

  @override
  _PaymentSettings get _value => super._value as _PaymentSettings;

  @override
  $Res call({
    Object? acceptedCardBrands = freezed,
    Object? cardVaultUrl = freezed,
    Object? countryCode = freezed,
    Object? currencyCode = freezed,
    Object? enabledPresentmentCurrencies = freezed,
    Object? shopifyPaymentsAccountId = freezed,
    Object? supportedDigitalWallets = freezed,
  }) {
    return _then(_PaymentSettings(
      acceptedCardBrands: acceptedCardBrands == freezed
          ? _value.acceptedCardBrands
          : acceptedCardBrands // ignore: cast_nullable_to_non_nullable
              as List<CardBrand>,
      cardVaultUrl: cardVaultUrl == freezed
          ? _value.cardVaultUrl
          : cardVaultUrl // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: countryCode == freezed
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as CountryCode,
      currencyCode: currencyCode == freezed
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as CurrencyCode,
      enabledPresentmentCurrencies: enabledPresentmentCurrencies == freezed
          ? _value.enabledPresentmentCurrencies
          : enabledPresentmentCurrencies // ignore: cast_nullable_to_non_nullable
              as List<CurrencyCode>,
      shopifyPaymentsAccountId: shopifyPaymentsAccountId == freezed
          ? _value.shopifyPaymentsAccountId
          : shopifyPaymentsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      supportedDigitalWallets: supportedDigitalWallets == freezed
          ? _value.supportedDigitalWallets
          : supportedDigitalWallets // ignore: cast_nullable_to_non_nullable
              as List<DigitalWallet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PaymentSettings extends _PaymentSettings {
  const _$_PaymentSettings(
      {@CardBrandJson() required this.acceptedCardBrands,
      required this.cardVaultUrl,
      @CountryCodeJson() required this.countryCode,
      @CurrencyCodeJson() required this.currencyCode,
      @CurrencyCodeJson() required this.enabledPresentmentCurrencies,
      this.shopifyPaymentsAccountId,
      @DigitalWalletJson() required this.supportedDigitalWallets})
      : super._();

  factory _$_PaymentSettings.fromJson(Map<String, dynamic> json) =>
      _$$_PaymentSettingsFromJson(json);

  @override

  /// List of the card brands which the shop accepts.
  @CardBrandJson()
  final List<CardBrand> acceptedCardBrands;
  @override

  /// The url pointing to the endpoint to vault credit cards.
  final String cardVaultUrl;
  @override

  /// The country where the shop is located.
  @CountryCodeJson()
  final CountryCode countryCode;
  @override

  /// The three-letter code for the shop's primary currency.
  @CurrencyCodeJson()
  final CurrencyCode currencyCode;
  @override

  /// A list of enabled currencies (ISO 4217 format) that the shop accepts. Merchants can enable currencies from their Shopify Payments settings in the Shopify admin.
  @CurrencyCodeJson()
  final List<CurrencyCode> enabledPresentmentCurrencies;
  @override

  /// The shop’s Shopify Payments account id.
  final String? shopifyPaymentsAccountId;
  @override

  /// List of the digital wallets which the shop supports.
  @DigitalWalletJson()
  final List<DigitalWallet> supportedDigitalWallets;

  @override
  String toString() {
    return 'PaymentSettings(acceptedCardBrands: $acceptedCardBrands, cardVaultUrl: $cardVaultUrl, countryCode: $countryCode, currencyCode: $currencyCode, enabledPresentmentCurrencies: $enabledPresentmentCurrencies, shopifyPaymentsAccountId: $shopifyPaymentsAccountId, supportedDigitalWallets: $supportedDigitalWallets)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PaymentSettings &&
            (identical(other.acceptedCardBrands, acceptedCardBrands) ||
                const DeepCollectionEquality()
                    .equals(other.acceptedCardBrands, acceptedCardBrands)) &&
            (identical(other.cardVaultUrl, cardVaultUrl) ||
                const DeepCollectionEquality()
                    .equals(other.cardVaultUrl, cardVaultUrl)) &&
            (identical(other.countryCode, countryCode) ||
                const DeepCollectionEquality()
                    .equals(other.countryCode, countryCode)) &&
            (identical(other.currencyCode, currencyCode) ||
                const DeepCollectionEquality()
                    .equals(other.currencyCode, currencyCode)) &&
            (identical(other.enabledPresentmentCurrencies,
                    enabledPresentmentCurrencies) ||
                const DeepCollectionEquality().equals(
                    other.enabledPresentmentCurrencies,
                    enabledPresentmentCurrencies)) &&
            (identical(
                    other.shopifyPaymentsAccountId, shopifyPaymentsAccountId) ||
                const DeepCollectionEquality().equals(
                    other.shopifyPaymentsAccountId,
                    shopifyPaymentsAccountId)) &&
            (identical(
                    other.supportedDigitalWallets, supportedDigitalWallets) ||
                const DeepCollectionEquality().equals(
                    other.supportedDigitalWallets, supportedDigitalWallets)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(acceptedCardBrands) ^
      const DeepCollectionEquality().hash(cardVaultUrl) ^
      const DeepCollectionEquality().hash(countryCode) ^
      const DeepCollectionEquality().hash(currencyCode) ^
      const DeepCollectionEquality().hash(enabledPresentmentCurrencies) ^
      const DeepCollectionEquality().hash(shopifyPaymentsAccountId) ^
      const DeepCollectionEquality().hash(supportedDigitalWallets);

  @JsonKey(ignore: true)
  @override
  _$PaymentSettingsCopyWith<_PaymentSettings> get copyWith =>
      __$PaymentSettingsCopyWithImpl<_PaymentSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PaymentSettingsToJson(this);
  }
}

abstract class _PaymentSettings extends PaymentSettings {
  const factory _PaymentSettings(
          {@CardBrandJson()
              required List<CardBrand> acceptedCardBrands,
          required String cardVaultUrl,
          @CountryCodeJson()
              required CountryCode countryCode,
          @CurrencyCodeJson()
              required CurrencyCode currencyCode,
          @CurrencyCodeJson()
              required List<CurrencyCode> enabledPresentmentCurrencies,
          String? shopifyPaymentsAccountId,
          @DigitalWalletJson()
              required List<DigitalWallet> supportedDigitalWallets}) =
      _$_PaymentSettings;
  const _PaymentSettings._() : super._();

  factory _PaymentSettings.fromJson(Map<String, dynamic> json) =
      _$_PaymentSettings.fromJson;

  @override

  /// List of the card brands which the shop accepts.
  @CardBrandJson()
  List<CardBrand> get acceptedCardBrands => throw _privateConstructorUsedError;
  @override

  /// The url pointing to the endpoint to vault credit cards.
  String get cardVaultUrl => throw _privateConstructorUsedError;
  @override

  /// The country where the shop is located.
  @CountryCodeJson()
  CountryCode get countryCode => throw _privateConstructorUsedError;
  @override

  /// The three-letter code for the shop's primary currency.
  @CurrencyCodeJson()
  CurrencyCode get currencyCode => throw _privateConstructorUsedError;
  @override

  /// A list of enabled currencies (ISO 4217 format) that the shop accepts. Merchants can enable currencies from their Shopify Payments settings in the Shopify admin.
  @CurrencyCodeJson()
  List<CurrencyCode> get enabledPresentmentCurrencies =>
      throw _privateConstructorUsedError;
  @override

  /// The shop’s Shopify Payments account id.
  String? get shopifyPaymentsAccountId => throw _privateConstructorUsedError;
  @override

  /// List of the digital wallets which the shop supports.
  @DigitalWalletJson()
  List<DigitalWallet> get supportedDigitalWallets =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PaymentSettingsCopyWith<_PaymentSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
