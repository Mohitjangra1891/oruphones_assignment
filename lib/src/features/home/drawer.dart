import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oruphones_assignment/src/common/providers/common_providers.dart';
import 'package:oruphones_assignment/src/modals/userModel.dart';
import 'package:oruphones_assignment/src/res/colors.dart';
import 'package:oruphones_assignment/src/utils/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/SharedPrefHelper.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  // bool isLoggedIn = false; // Default to false
  UserModel? userData; // Default to false

  @override
  void initState() {
    super.initState();
    _loadUserdata();
  }

  Future<void> _loadUserdata() async {
    final userdata = await SharedPrefHelper.getUserData();
    setState(() {
      userData = userdata; // Update state based on session
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.blue.shade200),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            // Header with logo and close button
            Container(
              // color: Color.fromRGBO(244, 244, 244, 1),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/Logo.png', // Replace with your logo asset
                    height: 35,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Main action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  if (isLoggedIn)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D"),
                      ),
                      title: Text(
                        userData?.userName== '' ? "ORU user" :userData!.userName,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Joined: ${userData?.createdDate}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  if (!isLoggedIn)
                    CustomButton(
                      text: 'Login/SignUp',
                      color: const Color(0xFF4A4DE7),
                      textColor: Colors.white,
                      onPressed: () {
                        context.pushNamed(routeNames.LoginScreen);
                        context.pop();
                      },
                    ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Sell Your Phone',
                    color: AppColors.yellow_color,
                    textColor: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    await SharedPrefHelper.clearSession();
                    await SharedPrefHelper.clearUserData();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('auth_cookie');
                    ref.read(userProvider.notifier).state = null;
                    context.go(routeNames.splash);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
              ),
            const Spacer(),

            // Bottom navigation grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: const [
                  NavItem(
                    icon: Icons.shopping_cart_checkout_rounded,
                    label: 'How to Buy',
                  ),
                  NavItem(
                    icon: Icons.monetization_on_outlined,
                    label: 'How to Sell',
                  ),
                  NavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Our Guide',
                  ),
                  NavItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                  ),
                  NavItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                  ),
                  NavItem(
                    icon: Icons.question_answer_outlined,
                    label: 'FAQs',
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

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border_color,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
