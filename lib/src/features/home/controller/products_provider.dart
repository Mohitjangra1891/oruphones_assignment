import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/features/home/repo/home_repo.dart';

import '../../../modals/productModel.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier() : super(ProductState()) {
    fetchProducts();
  }

  static const String baseUrl = "http://40.90.224.241:5000";

  Future<void> fetchProducts({Map<String, dynamic>? filters}) async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);
    final nextPage = state.page + 1;

    final response = await http.post(
      Uri.parse('$baseUrl/filter'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "filter": {
          "condition": filters?['condition'] ?? [],
          "make": filters?['make'] ?? [],
          "storage": filters?['storage'] ?? [],
          "ram": filters?['ram'] ?? [],
          "warranty": filters?['warranty'] ?? [],
          "priceRange": filters?['priceRange'] ?? [],
          "verified": true,
          "sort": filters?['sort'] ?? {},
          "page": nextPage,
        }
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productsJson = responseData['data']['data'];
      final fetchedProducts = productsJson.map((json) => ProductModel.fromJson(json)).toList();
      state = state.copyWith(
        products: [...state.products, ...fetchedProducts],
        page: nextPage,
        isLoading: false,
        isLastPage: fetchedProducts.isEmpty,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

class ProductState {
  final List<ProductModel> products;
  final int page;
  final bool isLoading;
  final bool isLastPage;

  ProductState({
    this.products = const [],
    this.page = 0,
    this.isLoading = false,
    this.isLastPage = false,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    int? page,
    bool? isLoading,
    bool? isLastPage,
  }) {
    return ProductState(
      products: products ?? this.products,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}