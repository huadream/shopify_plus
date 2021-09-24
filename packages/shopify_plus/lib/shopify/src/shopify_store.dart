import 'package:shopify_plus/enums/enums.dart';
import 'package:shopify_plus/enums/src/sort_key_collection.dart';
import 'package:shopify_plus/enums/src/sort_key_product.dart';

import 'package:shopify_plus/mixins/src/shopfiy_error.dart';
import 'package:shopify_plus/models/src/collection/collections/collections.dart';
import 'package:shopify_plus/models/src/product/metafield/metafield.dart';
import 'package:shopify_plus/models/src/product/product.dart';
import 'package:shopify_plus/models/src/product/products/products.dart';
import 'package:shopify_plus/models/src/shop/shop.dart';
import 'package:graphql/client.dart';

import '../../models/src/collection/collection.dart';
import '../../shopify_config.dart';

/// ShopifyStore provides various methods related to the shopify store.
class ShopifyStore with ShopifyError {
  ShopifyStore._();

  static final ShopifyStore instance = ShopifyStore._();

  GraphQLClient? get _graphQLClient => ShopifyConfig.graphQLClient;

  /// Returns a List of [Product].
  ///
  /// Simply returns all Products from your Store.
  Future<List<Product>> getAllProducts(
      {String? metafieldsNamespace, bool deleteThisPartOfCache = false}) async {
    var productList = <Product>[];
    Products tempProduct;
    String? cursor;
    WatchQueryOptions _options;
    do {
      _options = WatchQueryOptions(
        document: gql(getProductsQuery),
        variables: {
          'cursor': cursor,
          'metafieldsNamespace': metafieldsNamespace,
        },
      );
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      tempProduct =
          (Products.fromGraphJson((result.data ?? const {})['products'] ?? {}));

      productList += tempProduct.productList;
      cursor = productList.isNotEmpty ? productList.last.cursor : '';
    } while ((tempProduct.hasNextPage == true));
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns a List of [Product].
  ///
  /// Returns the first [limit] Products after the given [startCursor].
  /// [limit] has to be in the range of 0 and 250.
  Future<List<Product>> getXProductsAfterCursor(int limit, String startCursor,
      {bool deleteThisPartOfCache = false,
      bool reverse = false,
      SortKeyProduct sortKeyProduct = SortKeyProduct.TITLE}) async {
    var productList = <Product>[];
    Products tempProduct;
    final cursor = startCursor;
    final _options = WatchQueryOptions(
        document: gql(getXProductsAfterCursorQuery),
        variables: {
          'x': limit,
          'cursor': cursor,
          'reverse': reverse,
          'sortKey': sortKeyProduct.parseToString()
        });
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    tempProduct =
        (Products.fromGraphJson((result.data ?? const {})['products'] ?? {}));
    productList += tempProduct.productList;
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns a List of [Product].
  ///
  /// Returns the Products associated to the given id's in [idList]
  Future<List<Product>?> getProductsByIds(List<String> idList,
      {bool deleteThisPartOfCache = false}) async {
    List<Product>? productList = [];
    final QueryOptions _options = WatchQueryOptions(
        document: gql(getProductsByIdsQuery), variables: {'ids': idList});
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    final response = result.data!;
    final newResponse = {
      'edges': List.generate(response['nodes'].length,
          (index) => {'node': response['nodes'][index]})
    };
    productList = Products.fromGraphJson(newResponse).productList;
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns [n] Products.
  ///
  /// Returns the first [n] sorted by the [sortKey].
  /// [reverse] reverses the returned products if set on true.
  /// [SortKey] is an enum, example use cases:
  ///
  ///  SortKey.TITLE,
  ///  SortKey.PRODUCT_TYPE,
  ///  SortKey.VENDOR,
  ///  SortKey.UPDATED_AT,
  ///  SortKey.CREATED_AT,
  ///  SortKey.BEST_SELLING,
  ///  SortKey.PRICE,
  ///  SortKey.ID,
  ///  SortKey.RELEVANCE,
  Future<List<Product>?> getNProducts(int n,
      {bool deleteThisPartOfCache = false,
      bool? reverse,
      SortKeyProduct sortKey = SortKeyProduct.PRODUCT_TYPE}) async {
    List<Product>? productList = [];
    final _options =
        WatchQueryOptions(document: gql(getNProductsQuery), variables: {
      'n': n,
      'sortKey': sortKey.parseToString(),
      'reverse': reverse,
    });
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    productList =
        (Products.fromGraphJson((result.data ?? const {})['products'] ?? {}))
            .productList;
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns a list of recommended [Product] by given id.
  Future<List<Product>?> getProductRecommendations(String productId,
      {bool deleteThisPartOfCache = false}) async {
    try {
      final _options = WatchQueryOptions(
          document: gql(getProductRecommendationsQuery),
          variables: {'id': productId});
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      if (deleteThisPartOfCache) {
        _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
      }
      final newResponse = List.generate(
          result.data!['productRecommendations']?.length ?? 0,
          (index) => {
                'node':
                    (result.data!['productRecommendations'] ?? const {})[index]
              });
      final tempProducts = {'edges': newResponse};
      return Products.fromGraphJson(tempProducts).productList;
    } catch (e) {
      print(e);
    }
    return [Product.fromGraphJson({})];
  }

  /// Returns a List of [Collection]
  Future<List<Collection>?> getCollectionsByIds(List<String> idList,
      {bool deleteThisPartOfCache = false}) async {
    try {
      final _options = WatchQueryOptions(
          document: gql(getCollectionsByIdsQuery), variables: {'ids': idList});
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      if (deleteThisPartOfCache) {
        _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
      }

      final newResponse = List.generate(result.data!['nodes']?.length ?? 0,
          (index) => {'node': (result.data!['nodes'] ?? const {})[index]});
      final tempCollection = {'edges': newResponse};
      return Collections.fromGraphJson(tempCollection).collectionList;
    } catch (e) {
      print(e);
    }
    return [Collection.fromJson({})];
  }

  /// Returns the Shop.
  Future<Shop> getShop({bool deleteThisPartOfCache = false}) async {
    final _options = WatchQueryOptions(
      document: gql(getShopQuery),
    );
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return Shop.fromJson(result.data!);
  }

  /// Returns a collection by handle.
  Future<Collection> getCollectionByHandle(String collectionName,
      {bool deleteThisPartOfCache = false}) async {
    try {
      final _options = WatchQueryOptions(
          document: gql(getFeaturedCollectionQuery),
          variables: {'query': collectionName});
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      if (deleteThisPartOfCache) {
        _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
      }
      return Collections.fromGraphJson(result.data!['collections'])
          .collectionList[0];
    } catch (e) {
      print(e);
    }
    return Collection.fromGraphJson({});
  }

  /// Returns all available collections.
  ///
  /// Tip: When editing Collections you can choose on which channel or app you want to make them available.
  Future<List<Collection>> getAllCollections(
      {bool deleteThisPartOfCache = false,
      SortKeyCollection sortKeyCollection = SortKeyCollection.UPDATED_AT,
      bool reverse = false}) async {
    var collectionList = <Collection>[];
    Collections tempCollection;
    String? cursor;
    WatchQueryOptions _options;
    do {
      _options = WatchQueryOptions(
          document: gql(getAllCollectionsOptimizedQuery),
          variables: {
            'cursor': cursor,
            'sortKey': sortKeyCollection.parseToString(),
            'reverse': reverse
          });
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      tempCollection = (Collections.fromGraphJson(
          (result.data ?? const {})['collections'] ?? {}));
      collectionList = tempCollection.collectionList + collectionList;
      cursor = collectionList.isNotEmpty ? collectionList.last.cursor : '';
    } while ((tempCollection.hasNextPage == true));
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return collectionList;
  }

  /// Returns N products from each X collections.
  ///
  /// Tip: When editing Collections you can choose on which channel or app you want to make them available.
  Future<List<Collection>?> getXCollectionsAndNProductsSorted(
    int n,
    int x, {
    bool deleteThisPartOfCache = false,
    SortKeyProductCollection sortKeyProductCollection =
        SortKeyProductCollection.CREATED,
    SortKeyCollection sortKeyCollection = SortKeyCollection.UPDATED_AT,
    bool reverse = false,
  }) async {
    List<Collection>? collectionList;
    String? cursor;
    WatchQueryOptions _options;
    _options = WatchQueryOptions(
        document: gql(getXCollectionsAndNProductsSortedQuery),
        variables: {
          'cursor': cursor,
          'sortKey': sortKeyCollection.parseToString(),
          'reverse': reverse,
          'sortKeyProduct': sortKeyProductCollection.parseToString(),
          'x': x,
          'n': n
        });
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    collectionList = (Collections.fromGraphJson(
            (result.data ?? const {})['collections'] ?? {}))
        .collectionList;
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return collectionList;
  }

  /// Returns a List of [Product].
  ///
  /// Returns all Products from the [Collection] with the [id].
  Future<List<Product>> getAllProductsFromCollectionById(String id,
      {bool deleteThisPartOfCache = false,
      SortKeyProductCollection sortKeyProductCollection =
          SortKeyProductCollection.CREATED}) async {
    String? cursor;
    final productList = <Product>[];
    Collection collection;
    QueryOptions _options;
    do {
      _options = WatchQueryOptions(
          document: gql(getCollectionByIdQuery),
          variables: {
            'id': id,
            'cursor': cursor,
            'sortKey': sortKeyProductCollection.parseToString()
          });
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      productList
          .addAll(Collection.fromGraphJson(result.data!).products.productList);
      collection = (Collection.fromGraphJson(result.data!));
      cursor = productList.isNotEmpty ? productList.last.cursor : '';
    } while (collection.products.hasNextPage == true);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns a List of [Product].
  ///
  /// Returns the first [limit] Products after the given [startCursor].
  /// [limit] has to be in the range of 0 and 250.
  Future<List<Product>?> getXProductsAfterCursorWithinCollection(
      String id, int limit,
      {String? startCursor,
      SortKeyProductCollection sortKey = SortKeyProductCollection.BEST_SELLING,
      bool deleteThisPartOfCache = false,
      bool reverse = false}) async {
    final cursor = startCursor;
    final _options = WatchQueryOptions(
        document: gql(getXProductsAfterCursorWithinCollectionQuery),
        variables: {
          'id': id,
          'cursor': cursor,
          'limit': limit,
          'sortKey': sortKey.parseToString(),
          'reverse': reverse,
        });
    final result = await _graphQLClient!.query(_options);
    checkForError(result);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return (Collection.fromGraphJson(result.data!)).products.productList;
  }

  /// Returns a List of [Product].
  ///
  /// Gets all [Product] from a [query] search sorted by [sortKey].
  Future<List<Product>> getAllProductsOnQuery(String cursor, String query,
      {SortKeyProduct? sortKey,
      bool deleteThisPartOfCache = false,
      bool reverse = false}) async {
    String? cursor;
    final productList = <Product>[];
    Products products;
    WatchQueryOptions _options;
    do {
      _options = WatchQueryOptions(
          document: gql(getAllProductsOnQueryQuery),
          variables: {
            'cursor': cursor,
            'sortKey': sortKey?.parseToString(),
            'query': query,
            'reverse': reverse
          });
      final result = await _graphQLClient!.query(_options);
      checkForError(result);
      productList.addAll(
          (Products.fromGraphJson((result.data!)['products'])).productList);
      products =
          (Products.fromGraphJson((result.data ?? const {})['products']));
      cursor = productList.isNotEmpty ? productList.last.cursor : '';
    } while (products.hasNextPage == true);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return productList;
  }

  /// Returns a List of [Product].
  ///
  /// Gets [limit] amount of [Product] from the [query] search, sorted by [sortKey].
  Future<List<Product>?> getXProductsOnQueryAfterCursor(
      String query, int limit, String? cursor,
      {SortKeyProduct? sortKey,
      bool deleteThisPartOfCache = false,
      bool reverse = false}) async {
    final _options = WatchQueryOptions(
        document: gql(getXProductsOnQueryAfterCursorQuery),
        variables: cursor == null
            ? {
                'limit': limit,
                'sortKey': sortKey?.parseToString(),
                'query': query,
                'reverse': reverse
              }
            : {
                'cursor': cursor,
                'limit': limit,
                'sortKey': sortKey?.parseToString(),
                'query': query,
                'reverse': reverse
              });
    final result = await ShopifyConfig.graphQLClient!.query(_options);
    checkForError(result);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return Products.fromGraphJson((result.data ?? const {})['products'])
        .productList;
  }

  /// Returns a List of [Metafield].
  ///
  /// Gets [Metafield]s of [Product] optionally filtered by namespace.
  Future<List<Metafield>> getMetafieldsFromProduct(
      String productHandle, String namespace,
      {bool deleteThisPartOfCache = false}) async {
    final _options = WatchQueryOptions(
        document: gql(getMetafieldsFromProductQuery),
        variables: {'handle': productHandle, 'namespace': namespace});
    final result = await ShopifyConfig.graphQLClient!.query(_options);
    checkForError(result);
    if (deleteThisPartOfCache) {
      _graphQLClient!.cache.writeQuery(_options.asRequest, data: {});
    }
    return (result.data!['productByHandle']['metafields']['edges']
            as List<Object>)
        .map((e) => Metafield.fromGraphJson(e as Map<String, dynamic>))
        .toList();
  }
}
