import 'package:dio/dio.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/models/pagination_response.dart';
import '../../../models/product.dart';

// Updated to support pagination with skip parameter
final productsProvider =
    AutoDisposeFutureProvider.family<PaginationResponse<Product>, int>(
      (ref, skip) async {
        print('====done');
        // DummyJSON API call with pagination
        final dio = Dio();
        final response = await dio.get(
          'https://dummyjson.com/products?limit=20&skip=$skip',
        );

        print('====done');
        print(response.data);
        print('====done');

        // Use the convenient fromDummyJson factory
        return PaginationResponse.fromDummyJson(
          response.data,
          (json) => Product.fromJson(json),
          'products', // The key containing the products array
        );
      },
    );
