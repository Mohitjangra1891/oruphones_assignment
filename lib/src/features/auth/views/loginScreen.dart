import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/features/auth/controller/authController.dart';
import 'package:oruphones_assignment/src/res/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool chechBoxValue = true;
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final createOtpState = ref.watch(createOtpStateProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Center(
                child: Image.asset(
                  'assets/Logo.png', // Replace with your logo asset
                  height: 60,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary_color,
                ),
              ),
              const Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: AppColors.greyText_color),
              ),
              const SizedBox(height: 150),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your Phone Number',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkGreyText_color),
                ),
              ),
              const SizedBox(height: 4),
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
                            border: InputBorder.none, // No border
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
              const SizedBox(height: 20),
              Spacer(),
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
              const SizedBox(height: 20),
              createOtpState.when(
                data: (_) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Next button pressed with valid input");
                          ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: false);
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
                          ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context,isBottomSheet: false);
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

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
