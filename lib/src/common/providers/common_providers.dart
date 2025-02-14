import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/modals/userModel.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<UserModel?>((ref) => null);
