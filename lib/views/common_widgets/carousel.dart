import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holmon/constants/assets.dart';

class Carousel extends StatefulWidget {
  Carousel({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _pageController = PageController(initialPage: 2);
  int _currentPage = 2;
  Timer? _timer;

  final List<AssetImage> imgList = [
    AssetImage(Assets.imagesBanner1),
    AssetImage(Assets.imagesBanner2),
    AssetImage(Assets.imagesBanner3),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < imgList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item.assetName,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width - 48,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();

    return RepaintBoundary(
      child: Column(
        children: [
          Container(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: imageSliders.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: imageSliders[index],
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imgList.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
