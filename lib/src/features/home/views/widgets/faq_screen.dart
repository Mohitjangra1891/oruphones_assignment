import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/home_controller.dart';

class FAQScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsyncValue = ref.watch(faqProvider);

    return faqAsyncValue.when(
      data: (faqList) {
        if (faqList == null) {
          return Center(child: Text("No FAQs available."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 6 ,horizontal: 12),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Optional: Round corners
                ),
                expansionAnimationStyle: AnimationStyle(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 350),

                ),
                // Set tile background color to grey

                collapsedBackgroundColor: Colors.grey[200], // Ensure it's grey when collapsed
                backgroundColor: Colors.grey[200], // Ensure it's grey when collapsed
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment : Alignment.topLeft,
                visualDensity: VisualDensity.compact,
                title: Text(
                  faqList[index].question!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Container(
                    color: Colors.white70,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(faqList[index].answer!),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Failed to load FAQs")),
    );
  }
}
