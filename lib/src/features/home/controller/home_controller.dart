import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/features/home/repo/home_repo.dart';
import 'package:oruphones_assignment/src/modals/faqModel.dart';

final brandProvider = FutureProvider<List<Map<String, dynamic>>?>((ref) async {
  return ref.read(HomeRepoProvider).fetchBrands();
});

final faqProvider = FutureProvider<List<FAQModel>?>((ref) async {
  return ref.read(HomeRepoProvider).fetchFaq();
});
