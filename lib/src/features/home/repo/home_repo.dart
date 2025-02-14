import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:oruphones_assignment/src/utils/SharedPrefHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/services/snackBar_service.dart';
import '../../../modals/faqModel.dart';
import '../../../modals/productModel.dart';
import '../../../res/endpoints.dart';

final HomeRepoProvider = Provider<HomeRepo>((ref) {
  return HomeRepo();
});

class HomeRepo {
  // static final HomeRepo _instance = HomeRepo._internal();

  // factory HomeRepo() => _instance;
  // final http.Client _client = http.Client();

  static const String baseUrl = "http://40.90.224.241:5000";

  // HomeRepo._internal();
  Future<List<ProductModel>> fetchProducts({
    required int page,
    Map<String, dynamic>? filters,
  }) async {
    try {
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
            "page": page,
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);
        print(responseData['data']['data']);

        final List<dynamic> productsJson = responseData['data']['data'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> fetchBrands() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/makeWithImages"));

      print(" Fetching Brands ---  Response Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");
      // print(response.headers);

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == "SUCCESS") {
        List brands = responseBody['dataObject'];
        return brands
            .map((brand) => {
                  'make': brand['make'],
                  'imagePath': brand['imagePath'],
                })
            .toList();
      } else {
        print("fetching top brands failed:}");
        return null;
      }
    } catch (e) {
      print("fetching top brands failed:}");
      print("exception-- $e");
      return null;
    }
  }

  Future<List<FAQModel>?> fetchFaq() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/faq"));

      print(" Fetching Faq qusetions ---  Response Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");
      // print(response.headers);

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        List faqs = responseBody["FAQs"] ?? [];

        return faqs.map((faq) => FAQModel.fromJson(faq)).toList();
      } else {
        print("fetching faqs failed:}");
        return null;
      }
    } catch (e) {
      print("fetching faqs failed:}");
      print("exception-- $e");
      return null;
    }
  }

  Future<void> addtoFav({required BuildContext context, required WidgetRef ref, required String listingID, required bool toggleValue}) async {
    try {
      print("astarting add to fav");
      print("listing id id$listingID");
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie');
      final sessionData = await SharedPrefHelper.loadSession();

      print("cookie is ${cookie}");
      print("token is ${sessionData.csrfToken}");
      final response = await http.post(
        Uri.parse("http://40.90.224.241:5000/favs"),
        headers: {'Content-Type': 'application/json', "Cookie": "$cookie", "X-Csrf-Token": "${sessionData.csrfToken}"},
        body: jsonEncode({"listingId": listingID, "isFav": toggleValue}),
      );
      final Map<String, dynamic> responseBody = json.decode(response!.body);

      if (response.statusCode == 200) {
        SharedPrefHelper.updateFavoriteList(listingID, toggleValue, ref);
        print("adding succesfulll");
        // Successfully updated favorite status
      } else {
        print("adding failed");
        SnackBarService.showSnackBar(context: context, message: responseBody["message"]);
        // Handle failure
      }
      print("ending add to fav");
    } catch (e) {
      print("adding favourite failed:}");
      print("exception-- $e");
    }
  }
}
