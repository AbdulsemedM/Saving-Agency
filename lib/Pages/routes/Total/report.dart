import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:vsla/Pages/inner/addMember.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';

class TotalReports extends StatefulWidget {
  const TotalReports({super.key});

  @override
  State<TotalReports> createState() => _TotalReportsState();
}

class ProfitData {
  final String memberName;
  final String grossShare;
  final String profit;
  final String debt;
  final String totalContribution;

  ProfitData({
    required this.memberName,
    required this.grossShare,
    required this.profit,
    required this.debt,
    required this.totalContribution,
  });
}

class _TotalReportsState extends State<TotalReports> {
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
                padding: const EdgeInsets.fromLTRB(10, 0, 15, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Loan Priority List",
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   allMembers.length.toString(),
                    //   style: GoogleFonts.poppins(
                    //       fontSize: screenWidth * 0.045,
                    //       fontWeight: FontWeight.bold),
                    // ),
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
                      height: MediaQuery.of(context).size.height * 0.7,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        "Net Share: ${allMembers[index].profit} ETB",
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
                                                        " Gross Share: ${allMembers[index].grossShare} ETB",
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: Text(
                                                        "Contr.: ${allMembers[index].totalContribution} ETB",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .blue[400]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
          grossShare: member['grossShare'],
          profit: member['netShare'],
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
