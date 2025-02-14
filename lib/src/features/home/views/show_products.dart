import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/products_Card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:oruphones_assignment/src/features/home/views/show_products.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/products_Card.dart';
import 'dart:convert';

import '../../../modals/productModel.dart';
import '../controller/products_provider.dart';


class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);

    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          ref.read(productProvider.notifier).fetchProducts();
        }
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // Ensure main screen scrolls, not the grid
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: state.products.length + (state.isLoading ? 6 : 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 4,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              if (index < state.products.length) {
                if ((index + 1) % 8 == 0) {
                  return DummyProductCard();
                }
                return ProductCard(product: state.products[index]);
              }
              return ProductShimmer();
            },
          ),
        ],
      ),
    );
  }
}

class DummyProductCard extends StatelessWidget {
  const DummyProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: const Center(child: Text("Ad / Promo", style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}


class ProductShimmer extends StatelessWidget {
  const ProductShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 15,
                    width: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
