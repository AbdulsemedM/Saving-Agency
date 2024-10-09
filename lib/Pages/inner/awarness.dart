import 'dart:convert';

import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as customCarousel;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/youtubePlayer.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class Awarness extends StatefulWidget {
  const Awarness({super.key});

  @override
  State<Awarness> createState() => _AwarnessState();
}

class AwarenessData {
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;

  AwarenessData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
  });
}

class _AwarnessState extends State<Awarness> {
  var awareness = true;
  var loading = false;
  List<AwarenessData> awarenesses = [];
  // late YoutubePlayerController _controller;
  // late TextEditingController _idController;
  // late TextEditingController _seekToController;

  // late PlayerState _playerState;
  // late YoutubeMetaData _videoMetaData;
  // double _volume = 100;
  // bool _muted = false;
  // bool _isPlayerReady = false;
  // final List<String> _ids = [
  //   'nPt8bK2gbaU',
  //   'gQDByCdjUXw',
  //   'iLnmTe5Q2Qw',
  //   '_WoCV4c6XOE',
  //   'KmzdUe0RSJo',
  //   '6jZDSSZZxjQ',
  //   'p2lYr3vM_1w',
  //   '7QUtEmBT_-w',
  //   '34_PXCzGw1M',
  // ];
  @override
  void initState() {
    super.initState();
    fetchAwareness();
  }

  // final customCarousel.CarouselController _controller =
  //     customCarousel.CarouselController();

  // void listener() {
  //   if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  //     setState(() {
  //       _playerState = _controller.value.playerState;
  //       _videoMetaData = _controller.metadata;
  //     });
  //   }
  // }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   _controller.pause();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   _idController.dispose();
  //   _seekToController.dispose();
  //   super.dispose();
  // }

  List<String> ids = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new_sharp)),
                    Image(
                        height: MediaQuery.of(context).size.height * 0.05,
                        image: const AssetImage("assets/images/vsla.png"))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF89520), // Background color
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Adjust padding as needed
                    hintText: "Health, Tips & Tricks...".tr,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ), // Text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          7), // Border radius for curvature
                    ),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.black), // Search icon
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 8),
                    child: Text(
                      "Be aware of...".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              // CarouselSlider(
              //     items: [
              //       Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               color: Color(0xFFF89520), // Background color
              //               borderRadius: BorderRadius.circular(
              //                   20), // Border radius for the curved effect
              //             ),
              //             child: GestureDetector(
              //               onTap: () {
              //                 showDialog(
              //                   context: context,
              //                   builder: (context) {
              //                     return AlertDialog(
              //                       content: Container(
              //                         width: 300,
              //                         child: YoutubePlayer(
              //                           controller: YoutubePlayerController(
              //                             initialVideoId: 'v=IcFW2abCl4M',
              //                             flags: YoutubePlayerFlags(
              //                               autoPlay: true,
              //                             ),
              //                           ),
              //                           showVideoProgressIndicator: true,
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 );
              //               },
              //               child: Column(
              //                 children: <Widget>[
              //                   Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: ClipRRect(
              //                         borderRadius: BorderRadius.circular(
              //                             20), // Adjust the radius as needed
              //                         child: Image.asset(
              //                           'assets/images/Locust.jpg',
              //                           fit: BoxFit.cover,
              //                           height: 150,
              //                           width: 300,
              //                         ),
              //                       )),
              //                   Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Row(
              //                       children: [
              //                         Expanded(
              //                           child: Text(
              //                             'How to effectively control desert Locust swarms',
              //                             style: GoogleFonts.poppins(
              //                                 fontSize: 14,
              //                                 color: Colors.white),
              //                           ),
              //                         ),
              //                         // const SizedBox(
              //                         //   width:
              //                         //       0.1, // Adjust this value as needed for the gap between the widgets
              //                         // ),
              //                         Expanded(
              //                             child: Icon(
              //                           Icons.play_circle_filled_rounded,
              //                           color: Colors.black,
              //                         ))
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               color: Color(0xFFF89520), // Background color
              //               borderRadius: BorderRadius.circular(
              //                   20), // Border radius for the curved effect
              //             ),
              //             child: Column(
              //               children: <Widget>[
              //                 Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(
              //                           20), // Adjust the radius as needed
              //                       child: Image.asset(
              //                         'assets/images/covid-19.jpg',
              //                         fit: BoxFit.cover,
              //                         height: 150,
              //                         width: 300,
              //                       ),
              //                     )),
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Row(
              //                     children: [
              //                       Expanded(
              //                         child: Text(
              //                           'How to effectively control desert Locust swarms',
              //                           style: GoogleFonts.poppins(
              //                               fontSize: 14,
              //                               color: Colors.white),
              //                         ),
              //                       ),
              //                       // const SizedBox(
              //                       //   width:
              //                       //       0.1, // Adjust this value as needed for the gap between the widgets
              //                       // ),
              //                       Expanded(
              //                           child: Icon(
              //                         Icons.play_circle_filled_rounded,
              //                         color: Colors.black,
              //                       ))
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //     options: CarouselOptions(
              //       height: 305,
              //       aspectRatio: 16 / 9,
              //       viewportFraction: 0.8,
              //       initialPage: 0,
              //       enableInfiniteScroll: true,
              //       reverse: false,
              //       padEnds: true,
              //       autoPlay: true,
              //       autoPlayInterval: Duration(seconds: 3),
              //       autoPlayAnimationDuration: Duration(milliseconds: 800),
              //       autoPlayCurve: Curves.fastOutSlowIn,
              //       enlargeCenterPage: true,
              //       enlargeFactor: 0.3,
              //       scrollDirection: Axis.horizontal,
              //     )),
              loading
                  ? const CircularProgressIndicator()
                  : CarouselSlider.builder(
                      itemCount: awarenesses
                          .length, // Replace yourItemList with the list of items
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.35,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        padEnds: true,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Container(
                          // Your item widget here
                          decoration: BoxDecoration(
                            color: Color(0xFFF89520),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print(awarenesses[index].videoUrl);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YoutubePlayerMy(
                                            videoId:
                                                awarenesses[index].videoUrl,
                                            ids: ids,
                                          )));
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       content: Container(
                              //         width: 300,
                              //         child: YoutubePlayer(
                              //           onReady: () {
                              //             _isPlayerReady = true;
                              //           },
                              //           controller: _controller,
                              //           showVideoProgressIndicator: true,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      awarenesses[index]
                                          .imageUrl, // Replace with your image path
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 300,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              awarenesses[index]
                                                  .title, // Replace with your title
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Icon(
                                              Icons.play_circle_filled_rounded,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        awarenesses[index].description.length >
                                                20
                                            ? '${awarenesses[index].description.substring(0, 70)}...'
                                            : awarenesses[index].description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "All Videos".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              CarouselSlider(
                  items: [
                    Column(
                      children: [
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      20), // Adjust the radius as needed
                                  child: Image.asset(
                                    'assets/images/livestock.jpg',
                                    fit: BoxFit.cover,
                                    height: 170,
                                    width: 150,
                                  ),
                                )),
                          ],
                        ),
                        Expanded(
                            child: Text(
                          "Coffee shop tips...".tr,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0xFFF89520)),
                        )),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      20), // Adjust the radius as needed
                                  child: Image.asset(
                                    'assets/images/business.jpg',
                                    fit: BoxFit.cover,
                                    height: 170,
                                    width: 150,
                                  ),
                                )),
                          ],
                        ),
                        Expanded(
                            child: Text(
                          "Coffee shop tips...",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0xFFF89520)),
                        )),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      20), // Adjust the radius as needed
                                  child: Image.asset(
                                    'assets/images/coffee.jpg',
                                    fit: BoxFit.cover,
                                    height: 170,
                                    width: 150,
                                  ),
                                )),
                          ],
                        ),
                        Expanded(
                            child: Text(
                          "Coffee shop tips...",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0xFFF89520)),
                        )),
                      ],
                    )
                  ],
                  options: CarouselOptions(
                    height: 300,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.4,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    padEnds: true,
                    autoPlay: false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchAwareness() async {
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getStringList("_keyUser");
    final String authToken = accessToken![0];

    try {
      final client = createIOClient();

      var response = await client.get(
        Uri.https(baseUrl, "api/v1/awareness/by-group"),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          for (var aware in data) {
            // print(transaction.date);
            var myAware = AwarenessData(
                title: aware['title'],
                description: aware['description'],
                imageUrl: aware['imageUrl'],
                videoUrl: aware['videoUrl']);
            awarenesses.add(myAware);
            ids.add(myAware.videoUrl);
          }
          print(awarenesses.length);
          loading = false;
        });

        setState(() {
          loading = false;
        });
      } else if (response.statusCode != 201) {
        final responseBody = json.decode(response.body);
        final description =
            responseBody?['message']; // Extract 'description' field
        if (description == "Something went wrong, please try again".tr) {
          Fluttertoast.showToast(
              msg: "Something went wron, please try again", fontSize: 18);
        } else {
          var message =
              description ?? "Something went wrong, please try again".tr;
          Fluttertoast.showToast(msg: message, fontSize: 18);
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      var message = e.toString();
      print(e.toString());
      'Something went wrong, please Check your network connection';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
