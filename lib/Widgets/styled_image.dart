import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StyledImage extends StatefulWidget {
  final dynamic imageUrl;
  const StyledImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  _StyledImageState createState() => _StyledImageState();
}

class _StyledImageState extends State<StyledImage> {
  bool hasInternet = true;
  bool loadingImage = true;

  int activeIndex = 0;
  Widget buildIndicator() => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: widget.imageUrl.length,
          effect: const SwapEffect(
              dotColor: Colors.blue,
              activeDotColor: Colors.white,
              dotHeight: 13,
              dotWidth: 13),
        ),
      );

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      print("status is ${status}");
      setState(() {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            hasInternet = true;
            loadingImage = false;

            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            hasInternet = false;
            loadingImage = false;

            break;
        }
        // hasInternet = status as bool;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
          color: Colors.black12),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  height: (MediaQuery.of(context).size.height) * 0.6,
                  autoPlay: true,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }),
              itemCount: widget.imageUrl.length,
              itemBuilder: (context, index, realindex) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    //width:300,
                    color: Colors.grey,
                    child: hasInternet
                        ? loadingImage
                            ? Lottie.asset("assets/loadpaperplane.json")
                            : Image.network(
                                widget.imageUrl[index],
                                fit: BoxFit.cover,
                              )
                        : Lottie.asset("assets/noInternetConnection.json"));
              },
            ),
          ),
          Expanded(flex: 1, child: buildIndicator()),
        ],
      ),
    );
  }
}
