// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/Pages/routes/socialFunds.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class AllTrnx extends StatefulWidget {
  final String payment;
  const AllTrnx({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  State<AllTrnx> createState() => _AllTrnxState();
}

class MemberData {
  final String userId;
  final String fullName;
  final String gender;
  final String proxy;
  final String round;
  final String hasPaid;

  MemberData(
      {required this.userId,
      required this.fullName,
      required this.round,
      required this.proxy,
      required this.hasPaid,
      required this.gender});
}

class _AllTrnxState extends State<AllTrnx> {
  var members = true;
  var social = true;
  @override
  void initState() {
    super.initState();
    widget.payment == "roundPayment"
        ? fetchMembersRound()
        : widget.payment == "socialFund"
            ? fetchMembersSocial()
            : null;
  }

  List<MemberData> allMembers = [];
  var group = "";
  var male = 0;
  var female = 0;
  var loading = true;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return members == false
        ? const Home3()
        : social == false
            ? const SocialFunds()
            : WillPopScope(
                onWillPop: () async {
                  if (members) {
                    // Set the new state outside onWillPop
                    setState(() {
                      widget.payment == "roundPayment"
                          ? members = false
                          : widget.payment == "socialFund"
                              ? social = false
                              : null;
                    });
                    // Allow back navigation
                    return false;
                  } else {
                    // Set the new state outside onWillPop
                    social = true;
                    members = true;
                    // Prevent back navigation
                    return false;
                  }
                },
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
                                  setState(() {
                                    widget.payment == "roundPayment"
                                        ? members = false
                                        : widget.payment == "socialFund"
                                            ? social = false
                                            : null;
                                  });
                                },
                                child:
                                    const Icon(Icons.arrow_back_ios_new_sharp)),
                            Image(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                image:
                                    const AssetImage("assets/images/vsla.png"))
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
                            // GestureDetector(
                            //     onTap: () {
                            //       widget.payment == "roundPayment"
                            //           ? fetchMembersRound()
                            //           : fetchMembersSocial();
                            //     },
                            //     child: const Icon(Icons.refresh, size: 25)),
                            Text(
                              allMembers.length.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
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
                              height: MediaQuery.of(context).size.height * 0.76,
                              width: MediaQuery.of(context).size.width * 1,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                controller: _pageController,
                                itemCount: allMembers.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      print(GlobalStrings.getGlobalString());
                                      print(allMembers[index]
                                          .proxy
                                          .toLowerCase());
                                      if (GlobalStrings.getGlobalString() ==
                                          "GROUP_ADMIN") {
                                        allMembers[index].proxy.toLowerCase() ==
                                                "true"
                                            ? editModal(allMembers[index])
                                            : null;
                                      }
                                    },
                                    child: Card(
                                      // shadowColor: Colors.white,
                                      color: allMembers[index].proxy == "true"
                                          ? Colors.white
                                          : Colors.grey[50],
                                      surfaceTintColor: Colors.white,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius:
                                                          screenWidth * 0.05,
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage: allMembers[
                                                                      index]
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              allMembers[index]
                                                                  .fullName,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text("Round",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                              .orange[
                                                                          900])),
                                                        ),
                                                        Text(
                                                          " ${allMembers[index].round.toString()}",
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: Colors.black,
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

  Future<void> fetchMembersSocial() async {
    try {
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
          hasPaid: member['hasPaidCurrentRound'],
          round: member['round'],
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
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchMembersRound() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(
            baseUrl, '/api/v1/groups/$groupId/constributors/roundPayment'),
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
          hasPaid: member['hasPaidCurrentRound'],
          round: member['round'],
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
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  void editModal(MemberData allMember) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController roundController = TextEditingController();
    var loading1 = false;
    roundController.text = allMember.round;
    fullNameController.text = allMember.fullName;

    // ignore: no_leading_underscores_for_local_identifiers
    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
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
                widget.payment == "roundPayment"
                    ? "Add Round Payment"
                    : "Add Social Fund",
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
                  labelText: "Full name *",
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
                      amountController.text = (currentAmount + 100).toString();
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
                      amountController.text = (currentAmount + 200).toString();
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
                      amountController.text = (currentAmount + 500).toString();
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text("500"),
                  ),
                ),
              ],
            ),
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
                                title: const Text('Confirm Payment'),
                                content: Text(
                                    'Are you sure you want to add ${amountController.text} Birr to ${allMember.fullName}?'),
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
                                      widget.payment == "roundPayment"
                                          ? fetchMembersRound()
                                          : fetchMembersSocial();
                                      Navigator.of(context)
                                          .pop(true); // User confirms deletion
                                    },
                                    child: const Text('Yes'),
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
                              "payementTypeId": widget.payment == "roundPayment"
                                  ? 1
                                  : widget.payment == "socialFund"
                                      ? 4
                                      : 2,
                              "amount": amountController.text,
                              "round": roundController.text
                            };
                            print(body);
                            // ignore: unnecessary_null_comparison
                            if (amountController.text == null) {
                              const message = 'Please enter an amount!';
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
                                  setState(() {
                                    loading1 = false;
                                  });
                                  const message = 'Payment added Successfuly!';
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
                          }
                        },
                        child: loading1
                            ? const CircularProgressIndicator()
                            : Text(
                                'Add',
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
}
