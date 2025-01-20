import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/allTrnx.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/role.dart';

class SocialFundsPayment extends StatefulWidget {
  const SocialFundsPayment({super.key});

  @override
  State<SocialFundsPayment> createState() => _SocialFundsPaymentState();
}

class _SocialFundsPaymentState extends State<SocialFundsPayment> {
  @override
  void initState() {
    super.initState();
    fettchShareAmount();
    fetchMembersRound();
  }

  final PageController _pageController = PageController();
  double shareAmount = 0;
  double attendance = 0;
  var admin = GlobalStrings.getGlobalString() == "GROUP_ADMIN" ? true : false;
  List<MemberData> allMembers = [];
  String? group;
  var loading = false;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // floatingActionButton: SizedBox(
      //   width: screenWidth * 0.7,
      //   height: 50,
      //   child: admin
      //       ? ElevatedButton(
      //           onPressed: () async {
      //             bool process = await showDialog(
      //               context: context,
      //               builder: (BuildContext context) {
      //                 return AlertDialog(
      //                   title: const Text('Caution'),
      //                   content:
      //                       Text("Are you sure, This process is irreversible!"),
      //                   actions: <Widget>[
      //                     TextButton(
      //                       onPressed: () {
      //                         Navigator.of(context)
      //                             .pop(true); // User confirms deletion
      //                       },
      //                       child: const Text('Okay'),
      //                     ),
      //                   ],
      //                 );
      //               },
      //             );
      //             if (process) {
      //               await apply();
      //             }
      //           },
      //           child: Text(
      //             "Close Meeting",
      //             style: TextStyle(
      //                 color: Colors.white, fontSize: screenWidth * 0.05),
      //           ),
      //           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      //         )
      //       : Container(
      //           width: 0,
      //         ),
      // ),
      body: loading
          ? const SizedBox(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.76,
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: allMembers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            print(GlobalStrings.getGlobalString());
                            // print(allMembers[index].proxy.toLowerCase());
                            if (GlobalStrings.getGlobalString() ==
                                "GROUP_ADMIN") {
                              if (attendance == 1) {
                                editModal(allMembers[index]);
                              } else {
                                bool rejectLoan = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Caution'.tr),
                                      content: Text(
                                          "Please fill attendace first".tr),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // User confirms deletion
                                          },
                                          child: Text('Okay'.tr),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Card(
                            // shadowColor: Colors.white,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.11,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: screenWidth * 0.05,
                                            backgroundColor: Colors.white,
                                            backgroundImage: allMembers[index]
                                                        .gender
                                                        .toLowerCase() ==
                                                    "male"
                                                ? const AssetImage(
                                                    "assets/images/male.png")
                                                : const AssetImage(
                                                    "assets/images/female.png"),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    allMembers[index].fullName,
                                                    style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Current Round".tr,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors
                                                            .orange[900])),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: allMembers[index]
                                                              .hasPaid ==
                                                          'true'
                                                      ? Colors.green
                                                      : Colors.orange,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    " ${allMembers[index].hasPaid == 'true' ? 'Paid'.tr : 'Unpaid'.tr}",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Container(
                                          //   height: screenWidth * 0.05,
                                          //   width: screenWidth * 0.05,
                                          //   color: Colors.orange,
                                          //   child: Icon(
                                          //     FontAwesomeIcons
                                          //         .diagramProject,
                                          //     size: screenWidth * 0.04,
                                          //   ),
                                          // )
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
    );
  }

  void editModal(MemberData allMember) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController roundController = TextEditingController();
    var loading1 = false;
    roundController.text = allMember.round;
    fullNameController.text = allMember.fullName;
    amountController.text = shareAmount.toString();

    // ignore: no_leading_underscores_for_local_identifiers
    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required'.tr;
      }
      return null;
    }

    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Add Social Fund".tr,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(allMember.round.toString()),
              )
            ],
          ), // Set your dialog title
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
              child: TextFormField(
                readOnly: true,
                controller: fullNameController,
                validator: _validateField,
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
                  labelText: "Full Name".tr,
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFFF89520)),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: TextFormField(
            //     readOnly: true,
            //     controller: roundController,
            //     decoration: InputDecoration(
            //       contentPadding:
            //           const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: const BorderSide(color: Color(0xFFF89520)),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: const BorderSide(color: Color(0xFFF89520)),
            //       ),
            //       labelText: "Round *",
            //       labelStyle: GoogleFonts.poppins(
            //           fontSize: 14, color: const Color(0xFFF89520)),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                readOnly: true,
                keyboardType: TextInputType.number,
                validator: _validateField,
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
                  labelText: "Amount".tr,
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFFF89520)),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           int currentAmount =
            //               int.tryParse(amountController.text) ?? 0;
            //           amountController.text = (currentAmount + 25).toString();
            //         });
            //       },
            //       child: const CircleAvatar(
            //         backgroundColor: Colors.orange,
            //         child: Text("25"),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           int currentAmount =
            //               int.tryParse(amountController.text) ?? 0;
            //           amountController.text = (currentAmount + 50).toString();
            //         });
            //       },
            //       child: const CircleAvatar(
            //         backgroundColor: Colors.orange,
            //         child: Text("50"),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           int currentAmount =
            //               int.tryParse(amountController.text) ?? 0;
            //           amountController.text = (currentAmount + 100).toString();
            //         });
            //       },
            //       child: const CircleAvatar(
            //         backgroundColor: Colors.orange,
            //         child: Text("100"),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           int currentAmount =
            //               int.tryParse(amountController.text) ?? 0;
            //           amountController.text = (currentAmount + 200).toString();
            //         });
            //       },
            //       child: const CircleAvatar(
            //         backgroundColor: Colors.orange,
            //         child: Text("200"),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           int currentAmount =
            //               int.tryParse(amountController.text) ?? 0;
            //           amountController.text = (currentAmount + 500).toString();
            //         });
            //       },
            //       child: const CircleAvatar(
            //         backgroundColor: Colors.orange,
            //         child: Text("500"),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                loading1
                    ? const CircularProgressIndicator(
                        color: Colors.orange,
                      )
                    : TextButton(
                        onPressed: () async {
                          bool confirmDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Payment'.tr),
                                content: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context)
                                        .style, // Use the default style or specify a custom style
                                    children: [
                                      TextSpan(
                                          text: 'Are you sure you want to add '
                                              .tr),
                                      TextSpan(
                                        text:
                                            '${amountController.text} ', // Part 2
                                      ),
                                      TextSpan(text: ' Birr to '.tr),
                                      TextSpan(text: '${allMember.fullName}?'),
                                    ],
                                  ),
                                ),
                                // Text(
                                //     'Are you sure you want to add ${amountController.text} Birr to ${allMember.fullName}?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // User does not confirm deletion
                                    },
                                    child: Text('Cancel'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User confirms deletion
                                    },
                                    child: Text('Yes'.tr),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmDelete) {
                            setState(() {
                              loading1 = true;
                            });
                            final body = {
                              "groupId": group,
                              "payerId": allMember.userId,
                              "payementTypeId": 4,
                              "amount": amountController.text,
                              "round": roundController.text
                            };
                            print(body);
                            // ignore: unnecessary_null_comparison
                            if (amountController.text == null) {
                              var message = 'Please enter an amount'.tr;
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                Fluttertoast.showToast(
                                    msg: message, fontSize: 18);
                              });
                            } else {
                              try {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var accessToken =
                                    prefs.getStringList("_keyUser");
                                final String authToken = accessToken![0];
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
                                  fetchMembersRound();
                                  setState(() {
                                    loading1 = false;
                                  });
                                  var message = 'Payment added Successfuly'.tr;
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    Fluttertoast.showToast(
                                        msg: message, fontSize: 18);
                                  });
                                  // ignore: use_build_context_synchronously
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
                                            "This phone number is already registered"
                                                .tr,
                                        fontSize: 18);
                                  } else {
                                    var message = description ??
                                        "payment process failed; please try again"
                                            .tr;
                                    Fluttertoast.showToast(
                                        msg: message, fontSize: 18);
                                  }
                                  setState(() {
                                    loading1 = false;
                                  });
                                }
                              } catch (e) {
                                var message = e.toString();
                                'Something went wrong, please Check your network connection'
                                    .tr;
                                Fluttertoast.showToast(
                                    msg: message, fontSize: 18);
                              } finally {
                                setState(() {
                                  loading1 = false;
                                });
                              }
                            }
                          }
                        },
                        child: loading1
                            ? const CircularProgressIndicator()
                            : Text(
                                'Add'.tr,
                                style:
                                    GoogleFonts.poppins(color: Colors.orange),
                              ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> fettchShareAmount() async {
    try {
      setState(() {
        loading = true;
      });
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/groups/getSocialFundAmount'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);
      print(data);
      setState(() {
        shareAmount = double.parse(data['socialFundAmount'].toString());
        attendance = double.parse(data['isAttendaceCompleted'].toString());
        loading = false;
      });
      print(shareAmount);
      print(attendance);
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      var message =
          'Something went wrong, please Check your network connection'.tr;
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  // Future<void> apply() async {
  //   print("mybodyyyyy");
  //   setState(() {
  //     loading = true;
  //   });
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var accessToken = prefs.getStringList("_keyUser");
  //   final String authToken = accessToken![0];

  //   try {
  //     var response = await http.put(
  //       Uri.https(baseUrl, "/api/v1/groups/closeMeetingRound"),
  //       headers: <String, String>{
  //         'Authorization': 'Bearer $authToken',
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       fetchMembersRound();
  //       setState(() {
  //         loading = false;
  //       });
  //       const message = 'Meeting closed successfully';
  //       Future.delayed(const Duration(milliseconds: 100), () {
  //         Fluttertoast.showToast(msg: message, fontSize: 18);
  //       });

  //       // ignore: use_build_context_synchronously

  //       // Navigator.push(
  //       //     context, MaterialPageRoute(builder: (context) => const Otp()));
  //       setState(() {
  //         loading = false;
  //       });
  //     } else if (response.statusCode != 200) {
  //       final responseBody = json.decode(response.body);
  //       final description =
  //           responseBody?['message']; // Extract 'description' field
  //       print(description);
  //       if (description == "Something went wrong, please try again") {
  //         Fluttertoast.showToast(
  //             msg: "Something went wron, please try again", fontSize: 18);
  //       } else {
  //         var message = description ?? "Something went wrong, please try again";
  //         Fluttertoast.showToast(msg: message, fontSize: 18);
  //       }
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     var message = e.toString();
  //     print(e.toString());
  //     // 'Please check your network connection';
  //     Fluttertoast.showToast(msg: message, fontSize: 18);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  Future<void> fetchMembersRound() async {
    try {
      setState(() {
        loading = true;
      });
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/groups/$groupId/contributors/socialFund'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      // final json = "[" + response.body + "]";
      var data = jsonDecode(response.body);

      List<MemberData> newMember = [];
      for (var member in data) {
        newMember.add(MemberData(
          round: member['round'],
          hasPaid: member['hasPaidCurrentSocialFund'],
          proxy: member['proxy'],
          userId: member['userId'],
          fullName: member['fullName'],
          gender: member['gender'],
        ));
      }

      // setState(() {
      //   male = data['genderStatics']['male'];
      //   female = data['genderStatics']['female'];
      // });
      allMembers.clear();
      allMembers.addAll(newMember);
      print(allMembers.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
        group = groupId;
        // group = groupId;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      var message =
          'Something went wrong, please Check your network connection'.tr;
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
