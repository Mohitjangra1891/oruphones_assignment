import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/features/auth/controller/authController.dart';
import 'package:oruphones_assignment/src/res/colors.dart';

class addNameScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<addNameScreen> createState() => _addNameScreenState();
}

class _addNameScreenState extends ConsumerState<addNameScreen> {
 final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addNameState = ref.watch(addNameStateProvider);
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
                  'Please Tell Us Your Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkGreyText_color),
                ),
              ),
              const SizedBox(height: 4),
              Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: false,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(204, 204, 204, 1), fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    print("Name entered: $value");
                  },
                ),
              ),
              const SizedBox(height: 20),
              Spacer(),
              const SizedBox(height: 20),
              addNameState.when(
                data: (_) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Next button pressed with valid input");
                          ref.read(authProvider.notifier).updateUserName(91, _nameController.text, context, ref);
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
                            'Confirm Name',
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
                          ref.read(authProvider.notifier).updateUserName(91, _nameController.text, context, ref);
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
                            'Confirm Name',
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
