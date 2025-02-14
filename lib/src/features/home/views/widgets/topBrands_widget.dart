import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/res/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/home_controller.dart';

class TopBrands extends ConsumerWidget {
  const TopBrands({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandData = ref.watch(brandProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Brands',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromRGBO(82, 82, 82, 1)),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 80, // Set height for horizontal list
          child: brandData.when(
            data: (brands) {
              // Show only first 7 brands + "View All" button
              final limitedBrands = brands?.take(9).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: limitedBrands!.length + 1, // +1 for "View All" button
                itemBuilder: (context, index) {
                  if (index < limitedBrands.length) {
                    final brand = limitedBrands[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8 ,horizontal: 8),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(242, 242, 242, 1),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                brand['imagePath']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // "View All" Button as Last Item
                    return GestureDetector(
                      onTap: () {
                        // Navigate to full brand list screen
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                shape: BoxShape.circle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "View All",
                                    style: TextStyle(fontSize: 13, color: AppColors.primary_color),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.primary_color,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
            loading: () => ShimmerLoadingWidget(), // Show shimmer effect
            error: (err, stack) => Center(child: Text("Error loading brands")),
          ),
        )
      ],
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 50,
                  height: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
