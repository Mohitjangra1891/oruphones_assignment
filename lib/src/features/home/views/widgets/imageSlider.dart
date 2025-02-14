import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ImageCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(); // No viewportFraction
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    // Listen to page changes
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      if (_currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_currentIndex < widget.imageUrls.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width, // Full width
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            physics: BouncingScrollPhysics(), // Optional: Smooth scrolling
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width, // Ensure full width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    widget.imageUrls[index],
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.grey : Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
            ),
          ),
        ),
      ],
    );
  }
}
