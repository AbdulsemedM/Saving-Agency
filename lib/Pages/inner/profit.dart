import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/utils/api_config.dart';

class Profits extends StatefulWidget {
  const Profits({super.key});

  @override
  State<Profits> createState() => _ProfitsState();
}

class ProfitData {
  final String memberName;
  final String profit;
  final String debt;
  final String totalContribution;

  ProfitData({
    required this.memberName,
    required this.profit,
    required this.debt,
    required this.totalContribution,
  });
}

class _ProfitsState extends State<Profits> {
  var members = true;
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  List<ProfitData> allMembers = [];

  var loading = true;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total Profits",
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 15, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total members",
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () {
                          fetchMembers();
                        },
                        child: const Icon(Icons.refresh, size: 25)),
                    Text(
                      allMembers.length.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 0, 15, 4),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const AddMember()));
              //         },
              //         child: Container(
              //           height: screenWidth * 0.12,
              //           width: screenWidth * 0.12,
              //           decoration: BoxDecoration(
              //               color: Colors.orange,
              //               borderRadius: BorderRadius.circular(
              //                   screenWidth * 0.12)),
              //           child: const Center(
              //             child: Icon(FontAwesomeIcons.plus),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              loading
                  ? const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.59,
                      width: MediaQuery.of(context).size.width * 1,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _pageController,
                        itemCount: allMembers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      allMembers[index]
                                                          .memberName,
                                                      style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: Text(
                                                        "Profit: ${allMembers[index].profit} ETB",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .orange),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: Text(
                                                        " Total Contribution: ${allMembers[index].totalContribution} ETB",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .blue[400]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "Debt: ${allMembers[index].debt} ETB",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.orange[
                                                                      900])),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchMembers() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/Transactions/getAllTransactions/report'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      List<ProfitData> newMember = [];
      for (var member in data) {
        newMember.add(ProfitData(
          memberName: member['memberName'],
          profit: member['profit'],
          debt: member['debt'],
          totalContribution: member['totalContribution'],
        ));
      }
      allMembers.clear();
      allMembers.addAll(newMember);
      print(allMembers.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
