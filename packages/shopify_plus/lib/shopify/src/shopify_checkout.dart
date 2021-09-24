import 'package:shopify_plus/enums/src/payment_token_type.dart';
import 'package:shopify_plus/enums/src/sort_key_order.dart';

import 'package:shopify_plus/mixins/src/shopfiy_error.dart';
import 'package:shopify_plus/models/src/checkout/line_item/line_item.dart';
import 'package:shopify_plus/models/src/order/order.dart';
import 'package:shopify_plus/models/src/order/orders/orders.dart';
import 'package:shopify_plus/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_plus/models/src/shopify_user/address/address.dart';
import 'package:graphql/client.dart';

import '../../models/src/checkout/checkout.dart';
import '../../shopify_config.dart';

/// ShopifyCheckout provides various method in order to work with checkouts.
class ShopifyCheckout with ShopifyError {
  ShopifyCheckout._();
  static final ShopifyCheckout instance = ShopifyCheckout._();

  GraphQLClient? get _graphQLClient => ShopifyConfig.graphQLClient;

  /// Returns a [Checkout] object.
  ///
  /// Returns the Checkout object of the checkout with the [checkoutId].
  Future<Checkout> getCheckoutInfoQuery(String checkoutId,
      {bool getShippingInfo = true,
      bool withPaymentId = false,
      bool deleteThisPartOfCache = false}) async {
    final _optionsRequireShipping = WatchQueryOptions(
        document: gql(getCheckoutInfoAboutShipping),
        variables: {
          'id': checkoutId,
        });
    final result = await _graphQLClient!.query(_optionsRequireShipping);

    final _options = WatchQueryOptions(
        document: gql(_requiresShipping(result) == true && getShippingInfo
            ? withPaymentId
                ? getCheckoutInfoWithPaymentId
                : getCheckoutInfo
            : withPaymentId
                ? getCheckoutInfoWithPaymentIdWithoutShipping
                : getCheckoutInfoWithoutShipping),
        variables: {
          'id': checkoutId,
        });
    final _queryResult = (await _graphQLClient!.query(_options));
    checkForError(_queryResult);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(_queryResult.data!['node']);
  }

  bool? _requiresShipping(QueryResult result) {
    return ((result.data ?? const {})['node'] ?? const {})['requiresShipping'];
  }

  /// Updates the attributes of a [Checkout]
  Future<void> updateAttributes(
    String checkoutId, {
    bool? allowPartialAddresses,
    Map<String, String>? customAttributes,
    String? note,
    bool deleteThisPartOfCache = false,
  }) async {
    final _options = MutationOptions(
      document: gql(checkoutAttributesUpdateMutation),
      variables: {
        'checkoutId': checkoutId,
        'input': {
          if (allowPartialAddresses != null)
            'allowPartialAddresses': allowPartialAddresses,
          if (customAttributes != null)
            'customAttributes': [
              for (var entry in customAttributes.entries)
                {
                  'key': entry.key,
                  'value': entry.value,
                }
            ],
          if (note != null) 'note': note,
        },
      },
    );
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutAttributesUpdateV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Returns all [Order] in a List of Orders.
  ///
  /// Returns a List of Orders from the Customer with the [customerAccessToken].
  Future<List<Order>?> getAllOrders(String customerAccessToken,
      {SortKeyOrder sortKey = SortKeyOrder.PROCESSED_AT,
      bool reverse = true,
      bool deleteThisPartOfCache = false}) async {
    final QueryOptions _options =
        WatchQueryOptions(document: gql(getAllOrdersQuery), variables: {
      'accessToken': customerAccessToken,
      'sortKey': sortKey.parseToString(),
      'reverse': reverse
    });
    final result = await ShopifyConfig.graphQLClient!.query(_options);
    checkForError(result);
    final orders = Orders.fromJson(
        (((result.data ?? const {})['customer'] ?? const {})['orders'] ??
            const {}));
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return orders.orderList;
  }

  /// Updates the shipping address on given [checkoutId]
  Future<Checkout> shippingAddressUpdate(
    String checkoutId,
    Address address, {
    bool deleteThisPartOfCache = false,
  }) async {
    final variables = address.toJson();
    variables['checkoutId'] = checkoutId;
    final _options = MutationOptions(
      document: gql(checkoutShippingAddressUpdateMutation),
      variables: variables,
    );
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutShippingAddressUpdateV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutShippingAddressUpdateV2'] ??
                const {})['checkout'] ??
            const {}));
  }

  /// Updates the shipping address on given [checkoutId]
  Future<String?> completeCheckoutWithTokenizedPaymentV2({
    required String checkoutId,
    required PriceV2 price,
    required Address billingAddress,
    required String impotencyKey,
    required String tokenizedPayment,
    required String type,
    bool test = false,
    bool deleteThisPartOfCache = false,
  }) async {
    final _options = MutationOptions(
      document: gql(compCheckoutWithTokenizedPaymentV2),
      variables: {
        'checkoutId': checkoutId,
        'payment': {
          'paymentAmount': {
            'amount': price.amount,
            'currencyCode': price.currencyCode
          },
          'idempotencyKey': impotencyKey,
          'billingAddress': {
            'firstName': billingAddress.firstName,
            'lastName': billingAddress.lastName,
            'address1': billingAddress.address1,
            'province': billingAddress.province,
            'country': billingAddress.country,
            'city': billingAddress.city,
            'zip': billingAddress.zip
          },
          'paymentData': tokenizedPayment,
          'type': type
        }
      },
    );
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCompleteWithTokenizedPaymentV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return (result.data!['checkoutCompleteWithTokenizedPaymentV2'] ??
        const {})['payment']['id'];
  }

  /// Helper method for transforming a list of variant ids into a List Of Map<String, dynamic> which looks like this:
  ///
  /// [{'quantity':AMOUNT,'variantId':'YOUR_VARIANT_ID'}]
  List<Map<String, dynamic>> transformVariantIdListIntoListOfMaps(
      List<String> variantIdList) {
    final lineItemList = <Map<String, dynamic>>[];
    for (final e in variantIdList) {
      if (lineItemList.indexWhere((test) => e == test['variantId']) == -1)
        lineItemList.add({
          'quantity': variantIdList.where((id) => e == id).toList().length,
          'variantId': e
        });
    }
    return lineItemList;
  }

  /// Associates the [Customer] that [customerAccessToken] belongs to, to the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutCustomerAssociate(
      String checkoutId, String customerAccessToken,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(associateCustomer),
        variables: {
          'checkoutId': checkoutId,
          'customerAccessToken': customerAccessToken
        });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCustomerAssociateV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Disassociates the [Customer] from the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutCustomerDisassociate(String checkoutId,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutCustomerDisassociateMutation),
        variables: {'id': checkoutId});
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCustomerDisassociateV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Applies [discountCode] to the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutDiscountCodeApply(String checkoutId, String discountCode,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutDiscountCodeApplyMutation),
        variables: {'checkoutId': checkoutId, 'discountCode': discountCode});
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutDiscountCodeApplyV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Removes the applied discount from the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutDiscountCodeRemove(String checkoutId,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutDiscountCodeRemoveMutation),
        variables: {'checkoutId': checkoutId});
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutDiscountCodeRemove',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Appends the [giftCardCodes] to the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutGiftCardAppend(
      String checkoutId, List<String> giftCardCodes,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutGiftCardsAppendMutation),
        variables: {'checkoutId': checkoutId, 'giftCardCodes': giftCardCodes});
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutGiftCardsAppend',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  Future<Checkout> createCheckout(List<LineItem> lineItems,
      {Address? mailingAddress, bool deleteThisPartOfCache = false}) async {
    final _options =
        MutationOptions(document: gql(createCheckoutMutation), variables: {
      'input': mailingAddress == null
          ? {
              'lineItems': [
                for (var lineItem in lineItems)
                  {
                    'variantId': lineItem.variantId,
                    'quantity': lineItem.quantity,
                  }
              ],
            }
          : {
              'lineItems': [
                for (var lineItem in lineItems)
                  {
                    'variantId': lineItem.variantId,
                    'quantity': lineItem.quantity,
                  }
              ],
              'shippingAddress': {
                'address1': mailingAddress.address1,
                'address2': mailingAddress.address2,
                'city': mailingAddress.city,
                'company': mailingAddress.company,
                'country': mailingAddress.country,
                'firstName': mailingAddress.firstName,
                'lastName': mailingAddress.lastName,
                'phone': mailingAddress.phone,
                'province': mailingAddress.province,
                'zip': mailingAddress.zip
              }
            }
    });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCreate',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutCreate'] ?? const {})['checkout'] ?? const {}));
  }

  Future<Checkout> addLineItemsToCheckout(
      {required String checkoutId,
      required List<LineItem> lineItems,
      bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(addLineItemsToCheckoutMutation),
        variables: {
          'checkoutId': checkoutId,
          'lineItems': [
            for (var lineItem in lineItems)
              {
                'variantId': lineItem.id,
                'quantity': lineItem.quantity,
              }
          ],
        });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'addLineItemsToCheckout',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutLineItemsAdd'] ?? const {})['checkout'] ??
            const {}));
  }

  Future<Checkout> updateLineItemsInCheckout(
      {required String checkoutId,
      required List<LineItem> lineItems,
      bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(updateLineItemsInCheckoutMutation),
        variables: {
          'checkoutId': checkoutId,
          'lineItems': [
            for (var lineItem in lineItems)
              {
                'variantId': lineItem.id,
                'quantity': lineItem.quantity,
              }
          ],
        });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'updateLineItemsInCheckout',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutLineItemsUpdate'] ?? const {})['checkout'] ??
            const {}));
  }

  Future<Checkout> removeLineItemsFromCheckout(
      {required String checkoutId,
      required List<LineItem> lineItems,
      bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(removeLineItemsFromCheckoutMutation),
        variables: {
          'checkoutId': checkoutId,
          'lineItemIds': [for (var lineItem in lineItems) lineItem.id],
        });

    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'removeLineItemsFromCheckout',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutLineItemsRemove'] ?? const {})['checkout'] ??
            const {}));
  }

  /// Removes the Gift card that [appliedGiftCardId] belongs to, from the [Checkout] that [checkoutId] belongs to.
  Future<void> checkoutGiftCardRemove(
      String appliedGiftCardId, String checkoutId,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutGiftCardRemoveMutation),
        variables: {
          'appliedGiftCardId': appliedGiftCardId,
          'checkoutId': checkoutId
        });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutGiftCardRemoveV2',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  /// Removes the Gift card that [appliedGiftCardId] belongs to, from the [Checkout] that [checkoutId] belongs to.
  Future<Checkout> checkoutShippingLineUpdate(
      String checkoutId, String shippingRateHandle,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutShippingLineUpdateMutation),
        variables: {
          'shippingRateHandle': shippingRateHandle,
          'checkoutId': checkoutId
        });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutShippingLineUpdate',
      errorKey: 'checkoutUserErrors',
    );
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return Checkout.fromJson(
        ((result.data!['checkoutShippingLineUpdate'] ?? const {})['checkout'] ??
            const {}));
  }

  /// Complete [Checkout] without providing payment information.
  /// You can use this mutation for free items or items whose purchase price is covered by a gift card
  Future<void> checkoutCompleteFree(String checkoutId,
      {bool deleteThisPartOfCache = false}) async {
    final _options = MutationOptions(
        document: gql(checkoutCompleteFreeMutation),
        variables: {'checkoutId': checkoutId});
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCompleteFree',
      errorKey: 'checkoutUserErrors',
    );

    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
  }

  Future<String?> checkoutCompleteWithTokenizedPaymentV3(String checkoutId,
      {required Checkout checkout,
      required String token,
      required PaymentTokenType paymentTokenType,
      required String idempotencyKey,
      required String amount,
      required String currencyCode,
      bool deleteThisPartOfCache = false}) async {
    final _options =
        MutationOptions(document: gql(completeCheckoutWithTokenV3), variables: {
      'checkoutId': checkoutId,
      'payment': {
        'paymentAmount': {'amount': amount, 'currencyCode': currencyCode},
        'idempotencyKey': idempotencyKey,
        'billingAddress': {},
        'paymentData': token,
        'type': paymentTokenType.toString()
      }
    });
    final result = await _graphQLClient!.mutate(_options);
    checkForError(
      result,
      key: 'checkoutCompleteWithTokenizedPaymentV3',
      errorKey: 'checkoutUserErrors',
    );

    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }

    return result.data?['checkoutCompleteWithTokenizedPaymentV3']['payment']
        ['id'];
  }
}
