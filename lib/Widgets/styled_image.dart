import 'package:cached_network_image/cached_network_image.dart';
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
              dotColor: Color.fromARGB(150, 82, 72, 200),
              activeDotColor: Color.fromARGB(255, 82, 72, 200),
              dotHeight: 13,
              dotWidth: 13),
        ),
      );

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        hasInternet = true;
      });
      print('YAY! Free cute dog pics!');
    } else {
      setState(() {
        hasInternet = false;
      });
      print('No internet :( Reason:');
    }
  }

  @override
  void initState() {
    super.initState();

    InternetConnectionChecker().onStatusChange.listen((status) {
      print("status is $status");
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 82, 72, 200),
            width: 5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                    height: (MediaQuery.of(context).size.height) * 0.5,
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
                          ?
                          // : Image.network(
                          //     widget.imageUrl[index],
                          //     fit: BoxFit.cover,
                          //
                          //   )
                          CachedNetworkImage(
                              imageUrl: "${widget.imageUrl[index]}",
                              placeholder: (context, url) =>
                                  Lottie.asset("assets/loadpaperplane.json"),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Lottie.asset("assets/noInternetConnection.json"));
                },
              ),
            ),
            Expanded(flex: 1, child: buildIndicator()),
          ],
        ),
      ),
    );
  }
}
