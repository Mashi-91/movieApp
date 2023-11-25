import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieapp/model/MovieModel.dart';
import 'package:movieapp/routes/appRoutes.dart';
import 'package:movieapp/screens/homescreen/homecontroller.dart';
import 'package:movieapp/utils/Utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E725B), Color(0xFF5C3E2B), Color(0xFF3B2417)],
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: Get.height * 0.09,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/applogo.png', width: 50),
                      InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.searchScreen);
                          },
                          child: const Icon(Icons.search,
                              color: Colors.white, size: 16)),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: FutureBuilder<List<MovieModel>?>(
              future: controller.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading movies'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No movies available'),
                  );
                } else {
                  final List<MovieModel>? data = snapshot.data;
                  final MovieModel movie = data![0];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customCard(
                            imgUrl: movie.imageUrl,
                            onTap: () {
                              Get.toNamed(AppRoutes.detailScreen,
                                  arguments: movie);
                            }),
                        SizedBox(height: Get.height * 0.02),
                        Utils.customText(
                          text: 'Popular on Popcorn',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        customSliderForPopular(data),
                        SizedBox(height: Get.height * 0.02),
                        Utils.customText(
                          text: 'For You',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        SizedBox(height: Get.height * 0.02),
                        customSliderForYou(data),
                        SizedBox(height: Get.height * 0.02),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customCard({required String imgUrl, required Function onTap}) {
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: InkWell(
        onTap: () => onTap(),
        child: Card(
          shadowColor: Colors.black,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imgUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: Get.height * 0.01,
                width: Get.width / 1,
                left: Get.width * 0.08,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => onTap(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.black),
                          SizedBox(width: Get.width * 0.01),
                          const Text('Play  ',
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    SizedBox(width: Get.width * 0.06),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          SizedBox(width: Get.width * 0.02),
                          const Text('My List',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customSliderForPopular(List<MovieModel>? data) {
    if (data != null && data.length > 1) {
      // Skip the first movie and take the next 4 movies
      final List<MovieModel> nextFourMovies = data.skip(1).take(5).toList();

      final List<Widget> items = nextFourMovies.map((movie) {
        return InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.detailScreen, arguments: movie);
          },
          child: customImage(imgUrl: movie.imageUrl),
        );
      }).toList();

      return CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          aspectRatio: 4 / 3,
          viewportFraction: 1 / 3,
          initialPage: 1,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: items,
      );
    } else {
      // Handle the case when there are no movies available
      return const Center(
        child: Text('No movies available'),
      );
    }
  }

  Widget customSliderForYou(List<MovieModel>? data) {
    if (data != null && data.isNotEmpty) {
      // Shuffle the list of movies to get random order
      final List<MovieModel> shuffledData = [...data]..shuffle();

      // Take the first 5 movies
      final List<MovieModel> randomMovies = shuffledData.take(6).toList();

      final List<Widget> items = randomMovies.map((movie) {
        return InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.detailScreen, arguments: movie);
            },
            child: customImage(imgUrl: movie.imageUrl));
      }).toList();

      return CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          aspectRatio: 4 / 3,
          viewportFraction: 1 / 3,
          initialPage: 1,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ),
        items: items,
      );
    } else {
      // Handle the case when there are no movies available
      return const Center(
        child: Text('No movies available'),
      );
    }
  }

  Widget customImage({required String imgUrl}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
