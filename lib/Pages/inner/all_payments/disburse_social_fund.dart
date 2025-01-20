// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/allTrnx.dart';
import 'package:vsla/login.dart';
// import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class DisburseSocialFunds extends StatefulWidget {
  const DisburseSocialFunds({super.key});

  @override
  State<DisburseSocialFunds> createState() => _DisburseSocialFundsState();
}

class SocialFundsTrnx {
  final String amount;
  final String name;
  final String status;
  final String gender;

  SocialFundsTrnx({
    required this.amount,
    required this.name,
    required this.gender,
    required this.status,
  });
}

class MemberData {
  final int userId;
  final String fullName;
  final String phoneNumber;
  final double loanBalance;
  final double paid;
  final double totalOwning;
  final String gender;
  final bool proxy;

  MemberData(
      {required this.userId,
      required this.fullName,
      required this.phoneNumber,
      required this.proxy,
      required this.loanBalance,
      required this.paid,
      required this.totalOwning,
      required this.gender});
}

class _DisburseSocialFundsState extends State<DisburseSocialFunds> {
  // final PageController _pageController = PageController();
  var loading = false;
  var payment = false;
  List<SocialFundsTrnx> allTrnx = [];
  List<MemberData> allMembers = [];
  @override
  void initState() {
    super.initState();
    fetchSocialFundsTrnx();
    fetchMembers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void valuechanged(value) {}
    var screenWidth = MediaQuery.of(context).size.width;
    return payment
        ? const AllTrnx(payment: "socialFund")
        : Scaffold(
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
                              child:
                                  const Icon(Icons.arrow_back_ios_new_sharp)),
                          Image(
                              height: MediaQuery.of(context).size.height * 0.05,
                              image: const AssetImage("assets/images/vsla.png"))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 6),
                          child: Text(
                            "Social Funds",
                            style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap:
                              GlobalStrings.getGlobalString() == 'GROUP_ADMIN'
                                  ? () {
                                      donate(type: "wedding");
                                    }
                                  : null,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.pink[400],
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.handHoldingHeart,
                                  color: Colors.white,
                                )),
                              ),
                              const Text("Wedding")
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              GlobalStrings.getGlobalString() == 'GROUP_ADMIN'
                                  ? () {
                                      donate(type: "Graduation");
                                    }
                                  : null,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.blue[600],
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.graduationCap,
                                  color: Colors.white,
                                )),
                              ),
                              const Text("Graduation")
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              GlobalStrings.getGlobalString() == 'GROUP_ADMIN'
                                  ? () {
                                      donate(type: "Energency");
                                    }
                                  : null,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.kitMedical,
                                  color: Colors.white,
                                )),
                              ),
                              const Text("Emergency")
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              GlobalStrings.getGlobalString() == 'GROUP_ADMIN'
                                  ? () {
                                      donate(type: "Mourning");
                                    }
                                  : null,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.lime[700],
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.faceSadTear,
                                  color: Colors.white,
                                )),
                              ),
                              const Text("Mourning")
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange[50],
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(builder: (context) {
                                  return Row(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        "A problem shared\n is a problem halved",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.06,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]);
                                }),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 6),
                                      child: Text(
                                        "Let’s collaborate and make the \nimpossible possible.",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        // onTap: () {
                                        //   setState(() {
                                        //     payment = true;
                                        //   });
                                        // },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                          child: Text(
                                            "Give your contribution",
                                            style: GoogleFonts.poppins(
                                                color: Colors.orange,
                                                fontSize: screenWidth * 0.045,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // const Padding(
                                      //   padding:
                                      //       EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      //   child: Icon(
                                      //     FontAwesomeIcons.plus,
                                      //     color: Colors.orange,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              FontAwesomeIcons.handshakeAngle,
                              size: screenWidth * 0.18,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth * 0.2,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange[50],
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(builder: (context) {
                                  return Row(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        "A problem shared\n is a problem halved",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.06,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]);
                                }),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 6),
                                      child: Text(
                                        "Let’s collaborate and make the \nimpossible possible.",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        // onTap: () {
                                        //   setState(() {
                                        //     payment = true;
                                        //   });
                                        // },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                          child: Text(
                                            "Give your contribution",
                                            style: GoogleFonts.poppins(
                                                color: Colors.orange,
                                                fontSize: screenWidth * 0.045,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // const Padding(
                                      //   padding:
                                      //       EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      //   child: Icon(
                                      //     FontAwesomeIcons.plus,
                                      //     color: Colors.orange,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              FontAwesomeIcons.handshakeAngle,
                              size: screenWidth * 0.18,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.29,
                    //   width: MediaQuery.of(context).size.width * 1,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       controller: _pageController,
                    //       itemCount: allTrnx.length,
                    //       itemBuilder: (context, index) {
                    //         return Card(
                    //           child: SizedBox(
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.1,
                    //             child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.start,
                    //                       children: [
                    //                         CircleAvatar(
                    //                           radius: screenWidth * 0.05,
                    //                           backgroundColor: Colors.white,
                    //                           backgroundImage: AssetImage(
                    //                               "assets/images/${allTrnx[index].gender.toLowerCase() == "male" ? "male" : "female"}.png"),
                    //                         ),
                    //                         Column(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.center,
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.start,
                    //                               children: [
                    //                                 Padding(
                    //                                   padding: const EdgeInsets
                    //                                       .fromLTRB(
                    //                                       0, 00, 0, 8.0),
                    //                                   child: Text(
                    //                                     allTrnx[index].name,
                    //                                     style:
                    //                                         GoogleFonts.roboto(
                    //                                       fontWeight:
                    //                                           FontWeight.w500,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment
                    //                                       .spaceBetween,
                    //                               children: [
                    //                                 Padding(
                    //                                   padding: const EdgeInsets
                    //                                       .fromLTRB(
                    //                                       10, 0, 10, 0),
                    //                                   child: Container(
                    //                                     height: MediaQuery.of(
                    //                                                 context)
                    //                                             .size
                    //                                             .height *
                    //                                         0.03,
                    //                                     width:
                    //                                         screenWidth * 0.25,
                    //                                     decoration: BoxDecoration(
                    //                                         color: allTrnx[index]
                    //                                                     .status
                    //                                                     .toLowerCase() ==
                    //                                                 "recieved"
                    //                                             ? Colors
                    //                                                 .green[300]
                    //                                             : Colors.orange,
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     15)),
                    //                                     child: Center(
                    //                                       child: Row(
                    //                                         mainAxisAlignment:
                    //                                             MainAxisAlignment
                    //                                                 .center,
                    //                                         children: [
                    //                                           const Icon(
                    //                                             FontAwesomeIcons
                    //                                                 .userPlus,
                    //                                             color: Colors
                    //                                                 .white,
                    //                                             size: 13,
                    //                                           ),
                    //                                           Padding(
                    //                                             padding:
                    //                                                 const EdgeInsets
                    //                                                     .fromLTRB(
                    //                                                     10,
                    //                                                     0,
                    //                                                     0,
                    //                                                     0),
                    //                                             child: Text(
                    //                                               allTrnx[index]
                    //                                                   .status,
                    //                                               style: GoogleFonts.poppins(
                    //                                                   fontSize:
                    //                                                       12,
                    //                                                   fontWeight:
                    //                                                       FontWeight
                    //                                                           .w400,
                    //                                                   color: Colors
                    //                                                       .white),
                    //                                             ),
                    //                                           )
                    //                                         ],
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Text(
                    //                           "${allTrnx[index].amount} ETB",
                    //                           style: GoogleFonts.poppins(
                    //                               color: Colors.blue[400],
                    //                               fontWeight: FontWeight.w700),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ]),
                    //           ),
                    //         );
                    //       }),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> fetchSocialFundsTrnx() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl,
            '/api/v1/Transactions/getAllTransactions/socialFund/$groupId'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      List<SocialFundsTrnx> newTransaction = [];
      for (var member in data) {
        newTransaction.add(SocialFundsTrnx(
          gender: member['gender'],
          amount: member['amount'],
          name: member['name'],
          status: member['status'],
        ));
      }

      allTrnx.addAll(newTransaction);
      print(allTrnx.length);

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

  Future fetchMembers() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/groups/$groupId/members'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);

      List<MemberData> newMember = [];
      for (var member in data['memberList']) {
        newMember.add(MemberData(
          phoneNumber: member['phoneNumber'],
          proxy: member['proxy'],
          userId: member['userId'],
          fullName: member['fullName'],
          gender: member['gender'],
          loanBalance: member['loanBalance'],
          paid: member['paid'],
          totalOwning: member['totalOwning'],
        ));
      }

      allMembers.clear();
      allMembers.addAll(newMember);

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

  Future donate({required String type}) async {
    String? selectedMember;
    var loading1 = false;
    TextEditingController amountController = TextEditingController();
    TextEditingController descController = TextEditingController();
    void onChanged(String? value) {
      // print(value);
      setState(() {
        selectedMember = value;
      });
    }

    String? validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.white,

            title: Text(
              'Disburse Fund for $type',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ), // Set your dialog title
            // content: Text(allMember.fullName), // Set your dialog content
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Text(
                          "Select a member",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      12, 10.0, 12.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade100),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                value:
                                    selectedMember, // Initially selected value (can be null)
                                onChanged:
                                    onChanged, // Function to handle value changes

                                items: allMembers.map((MemberData members) {
                                  return DropdownMenuItem<String>(
                                    value: members.userId.toString(),
                                    child: Text(
                                      members.fullName,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: validateField,
                  controller: amountController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF89520)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF89520)),
                    ),
                    labelText: "Amount *",
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFFF89520)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int currentAmount =
                            int.tryParse(amountController.text) ?? 0;
                        amountController.text = (currentAmount + 25).toString();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("25"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int currentAmount =
                            int.tryParse(amountController.text) ?? 0;
                        amountController.text = (currentAmount + 50).toString();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("50"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int currentAmount =
                            int.tryParse(amountController.text) ?? 0;
                        amountController.text =
                            (currentAmount + 100).toString();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("100"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int currentAmount =
                            int.tryParse(amountController.text) ?? 0;
                        amountController.text =
                            (currentAmount + 200).toString();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("200"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int currentAmount =
                            int.tryParse(amountController.text) ?? 0;
                        amountController.text =
                            (currentAmount + 500).toString();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("500"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  maxLines: 2,
                  // keyboardType: TextInputType.number,
                  validator: validateField,
                  controller: descController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF89520)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF89520)),
                    ),
                    labelText: "Description",
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFFF89520)),
                  ),
                ),
              ),
              Row(
                children: [
                  loading1
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : TextButton(
                          onPressed: () async {
                            bool confirmFund = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    title: Text(
                                      'Code of conduct',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    content: Text(
                                      '''1. Zero Tolerance for FGM:
- Strictly prohibit Female Genital Mutilation (FGM) within the group.
2. No Forced Marriages:
- Forbid engagement in or support for forced marriages.
3. Campaign Against Child Marriage:
- Actively participate in campaigns against child marriages, emphasizing the importance of education.
4. Abolish Harmful Widowhood Practices:
- Prohibit harmful widowhood practices, such as widow inheritance or forced isolation.
5. Challenge Harmful Rituals:
- Actively challenge and discourage harmful rituals that endanger health or well-being.
6. Promote Gender Equality:
- Commit to promoting gender equality and challenging discriminatory cultural norms.
7. Support for Victims:
- Establish a support system for victims of harmful practices, providing emotional support and resources.''',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // User does not confirm deletion
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // User confirms deletion
                                        },
                                        child: const Text('Agree'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            if (confirmFund) {
                              setState(() {
                                loading1 = true;
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var accessToken = prefs.getStringList("_keyUser");
                              final String authToken = accessToken![0];
                              final String groupId = accessToken[2];
                              final body = {
                                "groupId": groupId,
                                "payerId": selectedMember,
                                "payementTypeId": 5,
                                "amount": amountController.text,
                                "description": descController.text
                              };
                              print(body);
                              try {
                                final client = createIOClient();

                                var response = await client.post(
                                  Uri.https(baseUrl,
                                      "/api/v1/Transactions/addTransaction"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Bearer $authToken',
                                  },
                                  body: jsonEncode(body),
                                );
                                // print("here" + "${response.statusCode}");
                                // print(response.body);
                                if (response.statusCode == 200) {
                                  setState(() {
                                    loading1 = false;
                                  });
                                  const message = 'Payment added Successfuly!';
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    Fluttertoast.showToast(
                                        msg: message, fontSize: 18);
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog when the user presses the button
                                } else if (response.statusCode != 200) {
                                  final responseBody =
                                      json.decode(response.body);
                                  final description = responseBody?[
                                      'message']; // Extract 'description' field
                                  if (description ==
                                      "Phone number is already taken") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "This phone number is already registered",
                                        fontSize: 18);
                                  } else {
                                    var message = description ??
                                        "payment process failed; please try again";
                                    Fluttertoast.showToast(
                                        msg: message, fontSize: 18);
                                  }
                                  setState(() {
                                    loading1 = false;
                                  });
                                }
                              } catch (e) {
                                var message = e.toString();
                                'Please check your network connection';
                                Fluttertoast.showToast(
                                    msg: message, fontSize: 18);
                              } finally {
                                setState(() {
                                  loading1 = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            'Add',
                            style: GoogleFonts.poppins(color: Colors.orange),
                          ),
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
