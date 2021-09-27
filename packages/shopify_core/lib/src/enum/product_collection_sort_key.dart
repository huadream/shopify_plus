import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopify_core/util/string_extension.dart';

/// The set of valid sort keys for the ProductCollection query
enum ProductCollectionSortKey {
  /// Sort by the best-selling value.
  bestSelling,

  /// Sort by the collection-default value.
  collectionDefault,

  /// Sort by the created value.
  created,

  /// Sort by the id value.
  id,

  /// Sort by the manual value.
  manual,

  /// Sort by the price value.
  price,

  /// During a search (i.e. when the query parameter has been specified on the connection)
  /// this sorts the results by relevance to the search term(s).
  relevance,

  /// Sort by the title value.
  title,
}

/// {@macro json_converter}
class ProductCollectionSortKeyJson
    extends JsonConverter<ProductCollectionSortKey, String> {
  /// {@macro json_converter}
  const ProductCollectionSortKeyJson();

  static const _bestSellingName = 'BEST_SELLING';
  static const _collectionDefaultName = 'COLLECTION_DEFAULT';
  static const _createdName = 'CREATED';
  static const _idName = 'ID';
  static const _manualName = 'MANUAL';
  static const _priceName = 'PRICE';
  static const _relevanceName = 'RELEVANCE';
  static const _titleName = 'TITLE';

  @override
  ProductCollectionSortKey fromJson(String json) {
    switch (json.toLowerCase()) {
      case _bestSellingName:
        return ProductCollectionSortKey.bestSelling;
      case _collectionDefaultName:
        return ProductCollectionSortKey.collectionDefault;
      case _createdName:
        return ProductCollectionSortKey.created;
      case _idName:
        return ProductCollectionSortKey.id;
      case _manualName:
        return ProductCollectionSortKey.manual;
      case _priceName:
        return ProductCollectionSortKey.price;
      case _relevanceName:
        return ProductCollectionSortKey.relevance;
      case _titleName:
        return ProductCollectionSortKey.title;

      default:
        throw Exception('Unknown ProductCollectionSortKey: $json');
    }
  }

  @override
  String toJson(ProductCollectionSortKey object) => object.name;
}

/// {@macro enum_x}
extension ProductCollectionSortKeyX on ProductCollectionSortKey {
  /// {@macro enum_x.map}
  T map<T>({
    required T bestSelling,
    required T collectionDefault,
    required T created,
    required T id,
    required T manual,
    required T price,
    required T relevance,
    required T title,
  }) {
    switch (this) {
      case ProductCollectionSortKey.bestSelling:
        return bestSelling;
      case ProductCollectionSortKey.collectionDefault:
        return collectionDefault;
      case ProductCollectionSortKey.created:
        return created;
      case ProductCollectionSortKey.id:
        return id;
      case ProductCollectionSortKey.manual:
        return manual;
      case ProductCollectionSortKey.price:
        return price;
      case ProductCollectionSortKey.relevance:
        return relevance;
      case ProductCollectionSortKey.title:
        return title;
    }
  }

  /// {@macro enum_x.name}
  String get name {
    return map(
      bestSelling: ProductCollectionSortKeyJson._bestSellingName,
      collectionDefault: ProductCollectionSortKeyJson._collectionDefaultName,
      created: ProductCollectionSortKeyJson._createdName,
      id: ProductCollectionSortKeyJson._idName,
      manual: ProductCollectionSortKeyJson._manualName,
      price: ProductCollectionSortKeyJson._priceName,
      relevance: ProductCollectionSortKeyJson._relevanceName,
      title: ProductCollectionSortKeyJson._titleName,
    );
  }

  /// {@macro enum_x.displayName}
  String get displayName => name.capitalize();

  /// {@macro enum_x.description}
  String get description {
    return map(
      bestSelling: 'Sort by the best-selling value.',
      collectionDefault: 'Sort by the collection-default value.',
      created: 'Sort by the created value.',
      id: 'Sort by the id value.',
      manual: 'Sort by the manual value.',
      price: 'Sort by the price value.',
      relevance:
          'During a search (i.e. when the query parameter has been specified on the connection) this sorts the results by relevance to the search term(s). When no search query is specified, this sort key is not deterministic and should not be used.',
      title: 'Sort by the title value.',
    );
  }
}
