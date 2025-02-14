import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/common/providers/common_providers.dart';
import 'package:oruphones_assignment/src/features/home/repo/home_repo.dart';
import 'package:oruphones_assignment/src/utils/SharedPrefHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/services/snackBar_service.dart';
import '../../../../modals/productModel.dart';
import '../../../../modals/userModel.dart';
import 'package:http/http.dart' as http;

import '../../../auth/views/sheets/login_bottom_sheet.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  // bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // _checkIfFavorite();
  }

  Future<void> _toggleFavorite(String listingId, bool toggleValue) async {
    final isloggedIn = ref.watch(isLoggedInProvider);
    if (!isloggedIn) {
      // setState(() {
      //   isFavorite = !isFavorite;
      // });
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => LoginBottomSheet(listingId: listingId),
      );
    } else {
      ref.read(HomeRepoProvider).addtoFav(context: context, ref: ref, listingID: listingId, toggleValue: toggleValue);
      // final prefs = await SharedPreferences.getInstance();
      // final cookie = prefs.getString('auth_cookie');
      // final sessionData = await SharedPrefHelper.loadSession();
      //
      // final response = await http.post(
      //   Uri.parse("http://40.90.224.241:5000/favs"),
      //   headers: {'Content-Type': 'application/json', "Cookie": "$cookie", "X-Csrf-Token": "${sessionData.csrfToken}"},
      //   body: jsonEncode({"listingId": listingId, "isFav": toggleValue}),
      // );
      // final Map<String, dynamic> responseBody = json.decode(response!.body);
      //
      // if (response.statusCode == 200 && responseBody["success"] == true) {
      //   SharedPrefHelper.updateFavoriteList(listingId, toggleValue, ref);
      //
      //   // Successfully updated favorite status
      // } else {
      //   setState(() {
      //     isFavorite = !isFavorite;
      //   });
      //   SnackBarService.showSnackBar(context: context, message: responseBody["message"]);
      //   // Handle failure
      // }
    }
  }

  //
  // void _checkIfFavorite() async {
  //   UserModel? user = await SharedPrefHelper.getUserData();
  //   if (user != null) {
  //     setState(() {
  //       isFavorite = user.favListings.contains(widget.product.listingId);
  //     });
  //   }
  // }
  //
  // bool _checkFavorite(String listId, WidgetRef ref) {
  //   final user = ref.watch(userProvider);
  //
  //   return user?.favListings.contains(listId) ?? false;
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Container(
      margin: EdgeInsets.only(bottom: 5, right: 0),
      decoration: BoxDecoration(
        // color: Colors.red, // Button background color
        borderRadius: BorderRadius.circular(80), // Rounded corners
        // border: Border.all(color
        // : Colors.yellow, width: 3), // Yellow border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 10, // How much blur
            offset: Offset(-5, 5), // Shadow position
          ),
        ],
      ),
      child: Card(
        color: Colors.grey.shade300,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      widget.product.defaultImage.fullImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ORUVerified',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: user?.favListings.contains(widget.product.listingId) ?? false
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      // setState(() {
                      //   isFavorite = !isFavorite;
                      // });
                      _toggleFavorite(widget.product.listingId, !(user?.favListings.contains(widget.product.listingId) ?? false));
                    },
                  ),
                ),
                if (widget.product.openForNegotiation)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PRICE NEGOTIABLE',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.marketingName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.product.deviceStorage} • ${widget.product.deviceCondition}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${widget.product.listingPrice}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 0),
                      Text(
                        '₹81,500',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(45% off)',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // width: 70,
                    flex: 2,
                    child: Text(
                      widget.product.listingLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Text(
                    widget.product.listingDate,
                    style: TextStyle(color: Colors.black54),
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
