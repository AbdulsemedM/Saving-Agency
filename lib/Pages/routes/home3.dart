import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/allTrnx.dart';
import 'package:vsla/Pages/inner/all_payments/payments.dart';
import 'package:vsla/Pages/inner/loan.dart';
import 'package:vsla/Pages/inner/meetings.dart';
import 'package:vsla/Pages/inner/transactions.dart';
import 'package:vsla/Pages/inner/members.dart';
import 'package:vsla/Pages/inner/awarness.dart';
import 'package:vsla/login.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class Home3 extends StatefulWidget {
  const Home3({super.key});

  @override
  State<Home3> createState() => _Home3State();
}

class ContributionData {
  final double amount;
  final String contributor;
  final String date;

  ContributionData({
    required this.amount,
    required this.contributor,
    required this.date,
  });
}

class TipsData {
  final String title;
  final String description;

  TipsData({
    required this.title,
    required this.description,
  });
}

class _Home3State extends State<Home3> {
  final PageController _pageController = PageController();
  var members = false;
  var awareness = false;
  var loan = false;
  var transaction = false;
  var loading = true;
  var trnx = false;
  @override
  void initState() {
    super.initState();
    fetchDashBoardData();
    fetchTips();
  }

  String groupName = "";
  double totalAmount = 0;
  List<int> mileStone = [];
  List<String> tipOfTheDay = [];
  List<ContributionData> allContribution = [];
  List<TipsData> allTips = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return members == true
        ? const Members()
        : awareness == true
            ? const Awarness()
            : loan == true
                ? const Transaction()
                : transaction == true
                    ? const Loan()
                    : trnx == true
                        ? const AllTrnx(payment: "roundPayment")
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _onBackButtonPressed(context);
                                          },
                                          child: const Icon(
                                              Icons.arrow_back_ios_new_sharp)),
                                      Image(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          image: const AssetImage(
                                              "assets/images/vsla.png"))
                                    ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          utf8.decode(groupName.runes.toList()),
                                          style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.06,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Loanable Fund".tr,
                                        style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "${totalAmount.toString()} ETB",
                                        style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 20, 8, 0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.,
                                          children: [
                                            Container(
                                              height: screenWidth * 0.115,
                                              width: screenWidth * 0.115,
                                              decoration: BoxDecoration(
                                                  color: loading
                                                      ? Colors.grey[200]
                                                      : mileStone[0] == 2
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 138, 46, 46)
                                                          : Colors.grey[200],
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              138,
                                                              46,
                                                              46)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.115)),
                                              child: Center(
                                                  child: loading
                                                      ? Container()
                                                      : mileStone[0] == 2
                                                          ? const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const Icon(
                                                              Icons.adjust,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      138,
                                                                      46,
                                                                      46))),
                                            ),
                                            Container(
                                              height: 3,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              height: screenWidth * 0.115,
                                              width: screenWidth * 0.115,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              100,
                                                              98,
                                                              98)),
                                                  color: loading
                                                      ? Colors.grey[200]
                                                      : mileStone[1] == 2
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 100, 98, 98)
                                                          : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.115)),
                                              child: Center(
                                                child: loading
                                                    ? Container()
                                                    : mileStone[1] == 2
                                                        ? const Icon(
                                                            Icons.done,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons.adjust,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    100,
                                                                    98,
                                                                    98)),
                                              ),
                                            ),
                                            Container(
                                              height: 3,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              height: screenWidth * 0.115,
                                              width: screenWidth * 0.115,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              164,
                                                              125,
                                                              8)),
                                                  color: loading
                                                      ? Colors.grey[200]
                                                      : mileStone[2] == 2
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 164, 125, 8)
                                                          : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.115)),
                                              child: Center(
                                                  child: loading
                                                      ? Container()
                                                      : mileStone[2] == 2
                                                          ? const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const Icon(
                                                              Icons.adjust,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      164,
                                                                      125,
                                                                      8))),
                                            ),
                                            Container(
                                              height: 3,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              height: screenWidth * 0.115,
                                              width: screenWidth * 0.115,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 8, 40, 250)),
                                                  color: loading
                                                      ? Colors.grey[200]
                                                      : mileStone[3] == 2
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 8, 40, 250)
                                                          : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.115)),
                                              child: Center(
                                                  child: loading
                                                      ? Container()
                                                      : mileStone[3] == 2
                                                          ? const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const Icon(
                                                              Icons.adjust,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      8,
                                                                      40,
                                                                      250))),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 8, 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.,
                                          children: [
                                            Container(
                                              height: 0,
                                              width: screenWidth * 0.04,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenWidth * 0.04,
                                              width: screenWidth * 0.115,
                                              child: Center(
                                                child: Text(
                                                  "Bronze".tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.03),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenWidth * 0.04,
                                              width: screenWidth * 0.115,
                                              child: Center(
                                                child: Text(
                                                  "Silver".tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.03),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenWidth * 0.04,
                                              width: screenWidth * 0.115,
                                              child: Center(
                                                child: Text(
                                                  "Gold".tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.03),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenWidth * 0.115,
                                              width: screenWidth * 0.15,
                                              child: Center(
                                                child: Text(
                                                  "Premium".tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.03),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 7, 0, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const Members())));
                                            },
                                            child: Column(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.userGroup,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Members".tr,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Transaction()));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 7, 0, 0),
                                            child: Column(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.rightLeft,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Transactions".tr,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () async {
                                        //     final result = await Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 const Loan()));
                                        //     if (result) {
                                        //       fetchDashBoardData();
                                        //       fetchTips();
                                        //     }
                                        //     // setState(() {
                                        //     //   transaction = true;
                                        //     // });
                                        //   },
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.fromLTRB(
                                        //         0, 7, 0, 0),
                                        //     child: GestureDetector(
                                        //       child: Column(
                                        //         children: [
                                        //           const Icon(
                                        //             FontAwesomeIcons
                                        //                 .circleDollarToSlot,
                                        //             color: Colors.white,
                                        //           ),
                                        //           Text(
                                        //             "Loans".tr,
                                        //             style: GoogleFonts.poppins(
                                        //                 color: Colors.white),
                                        //           )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        width: screenWidth * 0.22,
                                        // color: Colors.amber,
                                        child: GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   awareness = true;
                                            // });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Awarness()));
                                          },
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Image(
                                                  image: const AssetImage(
                                                    "assets/images/Awareness.png",
                                                  ),
                                                  width: screenWidth * 0.19,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                ),
                                              ),
                                              Text(
                                                "Awareness".tr,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        width: screenWidth * 0.22,
                                        // color: Colors.amber,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool process = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Start Meeting'.tr),
                                                  content: Text(
                                                      "Do you want to start/continue the meeting?"
                                                          .tr),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text('No'.tr),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        bool start =
                                                            await fetchStart();
                                                        if (start) {
                                                          Navigator.of(context)
                                                              .pop(start);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "The meeting date is not due."
                                                                      .tr,
                                                              fontSize: 18);
                                                          Navigator.of(context)
                                                              .pop(start);
                                                        }
                                                      },
                                                      child: Text('Yes'.tr),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (process) {
                                              final result =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Payments()));
                                              if (result) {
                                                fetchDashBoardData();
                                                fetchTips();
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Image(
                                                  image: const AssetImage(
                                                    "assets/images/payment.png",
                                                  ),
                                                  width: screenWidth * 0.19,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                ),
                                              ),
                                              Text(
                                                "Start".tr,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.09,
                                      //   width: screenWidth * 0.22,
                                      //   // color: Colors.amber,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   const Meetings()));
                                      //     },
                                      //     child: Column(
                                      //       children: [
                                      //         Center(
                                      //           child: Image(
                                      //             image: const AssetImage(
                                      //               "assets/images/Meeting.png",
                                      //             ),
                                      //             width: screenWidth * 0.19,
                                      //             height: MediaQuery.of(context)
                                      //                     .size
                                      //                     .height *
                                      //                 0.04,
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           "Meetings",
                                      //           style: GoogleFonts.poppins(
                                      //               color: Colors.black),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.09,
                                      //   width: screenWidth * 0.22,
                                      //   // color: Colors.amber,
                                      //   child: Column(
                                      //     children: [
                                      //       Center(
                                      //         child: Image(
                                      //           image: const AssetImage(
                                      //             "assets/images/More.png",
                                      //           ),
                                      //           width: screenWidth * 0.19,
                                      //           height: MediaQuery.of(context)
                                      //                   .size
                                      //                   .height *
                                      //               0.04,
                                      //         ),
                                      //       ),
                                      //       Text(
                                      //         "More",
                                      //         style: GoogleFonts.poppins(
                                      //             color: Colors.black),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Text(
                                                    "Tip of the day".tr,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize:
                                                            screenWidth * 0.07,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ]),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 6),
                                                    child: Text(
                                                      loading || allTips.isEmpty
                                                          ? ""
                                                          : utf8.decode(allTips[
                                                                  allTips.length -
                                                                      1]
                                                              .title
                                                              .runes
                                                              .toList()),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.035,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 0),
                                                    child: Text(
                                                      loading || allTips.isEmpty
                                                          ? ""
                                                          : insertNewLines(utf8
                                                              .decode(allTips[
                                                                      allTips.length -
                                                                          1]
                                                                  .description
                                                                  .runes
                                                                  .toList())),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.03,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            FontAwesomeIcons.lightbulb,
                                            size: screenWidth * 0.25,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Recent Updates".tr,
                                      style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.orange,
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            controller: _pageController,
                                            itemCount: allContribution.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                child: SizedBox(
                                                  height: 60,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                child: Icon(
                                                                    FontAwesomeIcons
                                                                        .rotate),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    loading
                                                                        ? ""
                                                                        : allContribution[index]
                                                                            .contributor
                                                                            .tr,
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    loading
                                                                        ? ""
                                                                        : DateFormat('MMM d-yyyy')
                                                                            .format(DateTime.parse(allContribution[index].date)),
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(loading
                                                                      ? ""
                                                                      : allContribution[
                                                                              index]
                                                                          .amount
                                                                          .toString()),
                                                                  Text(
                                                                    " ETB",
                                                                    style: GoogleFonts.roboto(
                                                                        color: Colors.grey[
                                                                            400],
                                                                        fontSize:
                                                                            10),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              );
                                            }),
                                      ),
                              ],
                            ),
                          );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Confirm Exit"),
            content: const Text("Do you want to Logout?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    List<String> user = [];
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs.setStringList("_keyUser", user);
                    GlobalStrings.setGlobalString("");
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  Future<void> fetchDashBoardData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/home-page'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      // print(response.body);
      allContribution.clear();
      for (var recentContributions in data['recentContributions']) {
        allContribution.add(ContributionData(
          amount: recentContributions['amount'],
          contributor: recentContributions['contributor'],
          date: recentContributions['date'],
        ));
      }
      print("hereeeeee");
      print(allContribution.length);

      setState(() {
        totalAmount = data['totalAmount'];
        groupName = (data['groupName']);

        mileStone.clear();
        mileStone.add(data['milestone']['bronze']);
        mileStone.add(data['milestone']['silver']);
        mileStone.add(data['milestone']['gold']);
        mileStone.add(data['milestone']['premium']);
        tipOfTheDay.add(data['tipOfTheDay']["title"]);
        tipOfTheDay.add(data['tipOfTheDay']["description"]);
        loading = false;
      });

      print(mileStone);
      print(utf8.decode(groupName.runes.toList()));
    } catch (e) {
      var message = e.toString();
      print(e
          .toString()); // 'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchTips() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/Tips/getTips/App'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      print(data);
      if (data.length > 0) {
        for (var tips in data) {
          setState(() {
            allTips.add(TipsData(
              title: tips['title'],
              description: tips['description'],
            ));
          });
        }
      }
      print("hereeeeee");
      print(allTips.length);
    } catch (e) {
      var message = e.toString();
      print(e.toString());
      // 'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  String insertNewLines(String input) {
    const int maxLength = 36;
    List<String> lines = [];
    for (int i = 0; i < input.length; i += maxLength) {
      lines.add(input.substring(
          i, i + maxLength > input.length ? input.length : i + maxLength));
    }
    return lines.join('\n');
  }

  Future<bool> fetchStart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getStringList("_keyUser");
    final String authToken = accessToken![0];
    final client = createIOClient();

    final response1 = await client.get(
      Uri.https(baseUrl, '/api/v1/meetings/CheckMeeetingDate'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
        // 'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // transactions = parseTransactions(response.body);
    var data = jsonDecode(response1.body);
    print(data);
    data = data['isMeetingDate'];
    // setState(() {
    //   isAttendanceFilled = data1;
    // });
    return data == true ? data : false;
  }
}
