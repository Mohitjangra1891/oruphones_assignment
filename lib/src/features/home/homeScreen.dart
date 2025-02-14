import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oruphones_assignment/src/features/home/drawer.dart';
import 'package:oruphones_assignment/src/features/home/views/products_screen.dart';
import 'package:oruphones_assignment/src/features/home/views/show_products.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/customSellButton.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/faq_screen.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/imageSlider.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/products_Card.dart';
import 'package:oruphones_assignment/src/features/home/views/widgets/topBrands_widget.dart';

import '../../common/providers/common_providers.dart';
import '../../res/colors.dart';
import '../../utils/router.dart';
import 'controller/products_provider.dart';

class homeScreen extends ConsumerStatefulWidget {
  const homeScreen({super.key});

  @override
  ConsumerState<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends ConsumerState<homeScreen> {
  Future<void> _refreshData() async {
    ref.read(productProvider.notifier).fetchProducts(); // Ensure refresh logic works
  }

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 700) {
      ref.read(productProvider.notifier).fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false   ,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        splashColor: Colors.transparent,
                        child: Image.asset(
                          'assets/leading_icon.png',
                          height: 40,
                        ),
                      ),
                      Spacer(),
                      const Text(
                        'India',
                        style: TextStyle(color: Colors.black),
                      ),
                      const Icon(Icons.location_on_outlined, color: Colors.black, size: 20),
                      const SizedBox(width: 8),
                      if (isLoggedIn) IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active_outlined)),
                      if (!isLoggedIn) //show login button
                        GestureDetector(
                          onTap: (){
                            context.pushNamed(routeNames.LoginScreen);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB800),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Navigation Tabs
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true, // Keep only bottom widgets pinned
                delegate: _StickyHeaderDelegate(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Navigation Tabs

                      SizedBox(
                        height: 22,
                      ),
                      ImageCarousel(
                        imageUrls: ["assets/banner1.png", "assets/banner2.png", "assets/banner3.png", "assets/banner4.png", "assets/banner5.png"],
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      // Quick Actions
                      const QuickActions(),
                      SizedBox(
                        height: 12,
                      ),
                      // Top Brands
                      TopBrands(),
                      SizedBox(
                        height: 12,
                      ),
                      Align(alignment: Alignment.center, child: CustomSellButton()),
                      SizedBox(
                        height: 16,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Best Deals ",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromRGBO(82, 82, 82, 1)),
                            ),
                            const TextSpan(
                              text: "in India",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 08),
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.border_color,
                                )),
                            child: Row(
                              children: [
                                Icon(Icons.compare_arrows_outlined),
                                Text(
                                  " Sort",
                                  style: TextStyle(
                                    color: Color.fromRGBO(18, 18, 18, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down_sharp)
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 08),
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.border_color,
                                )),
                            child: Row(
                              children: [
                                Icon(Icons.sort_rounded),
                                Text(
                                  " Filters",
                                  style: TextStyle(
                                    color: Color.fromRGBO(18, 18, 18, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down_sharp)
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: ProductList(
              )),
              SliverToBoxAdapter(
                child: // Notification Banner
                    FAQScreen(),
              ),
              SliverToBoxAdapter(
                child: // Notification Banner
                    footer_widget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class footer_widget extends StatelessWidget {
  const footer_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 22),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.amber,
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                'Get Notified About Our\nLatest Offers and Price Drops',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your email here',
                          // filled: true,
                          // fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Send'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Color.fromRGBO(54, 54, 54, 1),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Download Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Image.asset("assets/Frame.png"),
              SizedBox(height: 26),
              Text(
                'Invite a Friend',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
        ),
        Stack(
          children: [
            Column(
              children: [
                Container(height: 160, color: Color.fromRGBO(54, 54, 54, 1)), // Grey background
                Container(height: 250, color: Colors.grey[300]), // Black background
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(35)),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'Invite a friend to ORUphones application.Tap to copy the respective download link to the clipboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Image.asset("assets/playstore_button.png"),
                        SizedBox(height: 16),
                        Image.asset("assets/appstore_button.png"),
                        SizedBox(height: 26),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Or Share", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: Image.asset("assets/insta.png"), onPressed: () {}),
                      IconButton(icon: Image.asset("assets/telegram.png"), onPressed: () {}),
                      IconButton(icon: Image.asset("assets/twitter.png"), onPressed: () {}),
                      IconButton(icon: Image.asset("assets/whatsapp.png"), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 120; // Minimum height when collapsed
  @override
  double get maxExtent => 120; // Max height (same to keep it fixed)

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply blur effect

        child: Container(
          color: Colors.white.withOpacity(0.8), // Semi-transparent for better effect

          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
          child: Column(
            children: [
              // const SizedBox(height: 12),
              Container(
                child: TextField(
                  onTapOutside: (PointerDownEvent) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search phones with make, model...',
                    hintStyle: TextStyle(color: Color.fromRGBO(112, 112, 112, 1)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.yellow_color,
                    ),
                    suffixIcon: const Icon(
                      Icons.mic_none_outlined,
                      color: Colors.black45,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey, width: 1), // Apply same border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const NavigationTabs(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class NavigationTabs extends StatelessWidget {
  const NavigationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTab('Sell Used Phones', true),
            _buildTab('Buy Used Phones', false),
            _buildTab('Compare Prices', false),
            _buildTab('Compare Prices', false),
            _buildTab('Compare Prices', false),
            _buildTab('Compare Prices', false),
            _buildTab('Compare Prices', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border_color,
          )),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What’s on your mind?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromRGBO(82, 82, 82, 1)),
          ),
          SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickAction("assets/img1.png", 'Buy Used\nPhones'),
                _buildQuickAction("assets/img2.png", 'Sell Used\nPhones'),
                _buildQuickAction("assets/img3.png", 'Compare\nPrices'),
                _buildQuickAction("assets/img4.png", 'My Profile'),
                _buildQuickAction("assets/img5.png", 'My Listings'),
                _buildQuickAction("assets/img7.png", 'Batter Health\nCheck'),
                _buildQuickAction("assets/img8.png", 'Verified\Phones'),
                _buildQuickAction("assets/img9.png", 'My Favourites'),
                // _buildQuickAction(Icons.sell, 'Sell Used\nPhones'),
                // _buildQuickAction(Icons.compare_arrows, 'Compare\nPrices'),
                // _buildQuickAction(Icons.person, 'My Profile'),
                // _buildQuickAction(Icons.more_horiz, 'More'),
                // _buildQuickAction(Icons.sell, 'Sell Used\nPhones'),
                // _buildQuickAction(Icons.compare_arrows, 'Compare\nPrices'),
                // _buildQuickAction(Icons.person, 'My Profile'),
                // _buildQuickAction(Icons.more_horiz, 'More'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String img, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset(
            img,
            fit: BoxFit.cover,
            height: 65,
            width: 65, // Ensures it fills the available space
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(18, 18, 18, 1)),
          ),
        ],
      ),
    );
  }
}
