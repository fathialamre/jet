import 'package:dio/dio.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/models.dart';
import '../../../models/product.dart';


final productsProvider =
    AutoDisposeFutureProvider.family<PaginationResponse<Product>, int>(
      (ref, skip) async {
        try {
          final dio = Dio();

          final response = await dio.get(
            'https://dummyjson.com/products?limit=20&skip=$skip',
          );

          return PaginationResponse.fromDummyJson(
            response.data,
            (json) => Product.fromJson(json),
            'products',
          );
        } catch (error) {
          rethrow;
        }
      },
    );
