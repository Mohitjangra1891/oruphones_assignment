import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../res/colors.dart';
import '../../controller/authController.dart';

class LoginBottomSheet extends ConsumerStatefulWidget {
  final String listingId;

  const LoginBottomSheet({Key? key, required this.listingId}) : super(key: key);

  @override
  ConsumerState createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends ConsumerState<LoginBottomSheet> {
  bool chechBoxValue = true;
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final createOtpState = ref.watch(createOtpStateProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Title + Close Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Phone Number Label
          Text(
            "Enter Your Phone Number",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),

          // Phone Number Input
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "+91",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      onTapOutside: (PointerDownEvent) {
                        FocusScope.of(context).unfocus();
                      },
                      autofocus: false,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(204, 204, 204, 1), fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        // No border
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.replaceAll(RegExp(r'\D'), '').length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        print("Phone number entered: $value");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Checkbox(
                  activeColor: AppColors.primary_color,
                  value: chechBoxValue,
                  onChanged: (value) {
                    chechBoxValue = !chechBoxValue;
                    setState(() {});
                  }),
              const Text('Accept '),
              GestureDetector(
                onTap: () {}, // Navigate to terms & conditions
                child: const Text(
                  'Terms and condition',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          createOtpState.when(
            data: (_) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Next button pressed with valid input");
                      ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: true ,listingId: widget.listingId);
                    } else {
                      print("Validation failed");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary_color,
            )),
            error: (Object error, StackTrace stackTrace) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Next button pressed with valid input");
                      ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: true,listingId: widget.listingId);
                    } else {
                      print("Validation failed");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
            // Show loader while API call is in progress
            // error: (err, _) => Text('Error: $err'),
          ),
        ],
      ),
    );
  }
}
