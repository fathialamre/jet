// This file demonstrates how to use the Jet Error Handling System

import 'package:dio/dio.dart';
import 'errors.dart';

/// Example usage of the Jet Error Handling System
class ErrorHandlingExamples {
  /// Basic error handling example
  void basicErrorHandling() {
    final errorHandler = JetErrorHandler.instance;

    try {
      // Your API call here
      throw DioException(
        requestOptions: RequestOptions(path: '/api/users'),
        type: DioExceptionType.connectionTimeout,
      );
    } catch (error, stackTrace) {
      // Handle the error using Jet Error Handler
      final jetError = errorHandler.handle(error, stackTrace);

      // Use the processed error
      print('Error Type: ${jetError.type}');
      print('Message: ${jetError.message}');
      print('Is No Internet: ${jetError.isNoInternet}');
      print('Is Server Error: ${jetError.isServerError}');
    }
  }

  /// Custom error handler example
  void customErrorHandler() {
    // Create your own custom error handler
    final customHandler = MyCustomErrorHandler();

    try {
      // Your API call here
      throw Exception('Custom error occurred');
    } catch (error, stackTrace) {
      final jetError = customHandler.handle(error, stackTrace);
      print('Custom handled: ${jetError.message}');
    }
  }

  /// Validation error handling example
  void validationErrorExample() {
    final errorHandler = JetErrorHandler.instance;

    try {
      // Simulate a validation error from API
      throw DioException(
        requestOptions: RequestOptions(path: '/api/users'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/users'),
          statusCode: 422,
          data: {
            'errors': {
              'email': ['Email is required', 'Email format is invalid'],
              'password': ['Password is too short'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );
    } catch (error, stackTrace) {
      final jetError = errorHandler.handle(error, stackTrace);

      if (jetError.isValidation) {
        print('Validation Error!');
        print('All errors: ${jetError.allValidationErrors}');
        print('First error: ${jetError.firstValidationError}');

        // Access specific field errors
        jetError.errors?.forEach((field, errors) {
          print('$field: ${errors.join(', ')}');
        });
      }
    }
  }
}

/// Example of creating a custom error handler
class MyCustomErrorHandler extends JetBaseErrorHandler {
  @override
  JetError handle(Object error, [StackTrace? stackTrace]) {
    // Add your custom logic here
    if (error.toString().contains('custom')) {
      return JetError.unknown(
        message: 'This is a custom error message!',
        rawError: error,
        stackTrace: stackTrace,
      );
    }

    // Fall back to default handling
    return super.getErrorMessage(error).isEmpty
        ? JetError.unknown(rawError: error, stackTrace: stackTrace)
        : JetError(
            message: super.getErrorMessage(error),
            type: super.getErrorType(error),
            rawError: error,
            stackTrace: stackTrace,
          );
  }

  @override
  String getErrorMessage(Object error) {
    if (error.toString().contains('timeout')) {
      return 'Custom timeout message: Please wait and try again';
    }
    return super.getErrorMessage(error);
  }
}

/// Integration with JetBuilder and JetPaginator examples
class IntegrationExamples {
  /// Example showing how JetBuilder automatically uses the error handler
  void jetBuilderExample() {
    /* 
    JetBuilder.list(
      provider: postsProvider,
      itemBuilder: (post, index) => PostCard(post: post),
      // Error handling is automatic! The configured error handler
      // in JetConfig will be used to process any errors
    )
    */
  }

  /// Example showing custom error widget with JetBuilder
  void jetBuilderCustomErrorExample() {
    /*
    JetBuilder.list(
      provider: postsProvider,
      itemBuilder: (post, index) => PostCard(post: post),
      error: (error, stackTrace) {
        // Custom error handling - you still get the raw error
        // but can also process it with the error handler if needed
        final jet = context.jet;
        final jetError = jet.config.errorHandler.handle(error, stackTrace);
        
        return CustomErrorWidget(
          title: jetError.isNoInternet 
            ? 'Check your connection'
            : 'Something went wrong',
          message: jetError.message,
          onRetry: () => context.refresh(postsProvider),
        );
      },
    )
    */
  }

  /// Example showing how JetPaginator uses error handling
  void jetPaginatorExample() {
    /*
    JetPaginator.list<Product>(
      fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
      parseResponse: (response, pageKey) => PageInfo(
        items: response['products'].map((json) => Product.fromJson(json)).toList(),
        nextPageKey: response['skip'] + response['limit'] < response['total']
            ? response['skip'] + response['limit']
            : null,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      // Error handling is automatic! Both initial load errors and 
      // pagination errors are handled with appropriate UI
    )
    */
  }
}
