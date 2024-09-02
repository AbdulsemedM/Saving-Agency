import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/profit.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:vsla/Pages/inner/addMember.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
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
  final String vslaRole;

  MemberData(
      {required this.userId,
      required this.fullName,
      required this.phoneNumber,
      required this.proxy,
      required this.loanBalance,
      required this.paid,
      required this.totalOwning,
      required this.vslaRole,
      required this.gender});
}

class _MembersState extends State<Members> {
  var members = true;
  var role = '';
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  // void fetchRole() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var my = prefs.getStringList("_keyUser");
  //   setState(() {
  //     role = my![4];
  //   });
  //   print(role);
  // }

  List<MemberData> allMembers = [];
  var male = 0;
  var female = 0;
  var loading = true;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
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
                        "Members".tr,
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
                        "Total members".tr,
                        style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       fetchMembers();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                FontAwesomeIcons.mars,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Male'.tr,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors
                                            .black, // Make sure to set the color since default is white
                                      ),
                                    ),
                                    TextSpan(
                                      text: ": $male",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors
                                            .black, // Make sure to set the color since default is white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: screenWidth * 0.015,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                FontAwesomeIcons.venus,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Female'.tr,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors
                                            .black, // Make sure to set the color since default is white
                                      ),
                                    ),
                                    TextSpan(
                                      text: ": $female",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors
                                            .black, // Make sure to set the color since default is white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemCount: allMembers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print(GlobalStrings.getGlobalString());
                                if (GlobalStrings.getGlobalString() ==
                                    "GROUP_ADMIN") {
                                  editModal(allMembers[index]);
                                }
                              },
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: screenWidth * 0.05,
                                                backgroundColor: Colors.white,
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        allMembers[index]
                                                            .fullName,
                                                        style:
                                                            GoogleFonts.roboto(
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
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Text(
                                                          "Phone".tr,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .orange),
                                                        ),
                                                      ),
                                                      Text(
                                                        " :${allMembers[index].phoneNumber.toString()}",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Row(
                                                          children: [
                                                            Text("Proxy".tr,
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                            .blue[
                                                                        400])),
                                                            Text(" :")
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        allMembers[index].proxy
                                                            ? "Yes".tr
                                                            : "No".tr,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .blue[400]),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text("Gender".tr,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                        .orange[
                                                                    900])),
                                                  ),
                                                  Text(
                                                    allMembers[index].gender.tr,
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                      allMembers[index]
                                                          .vslaRole
                                                          .tr,
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black)),
                                                ],
                                              ),
                                              Container(
                                                height: screenWidth * 0.05,
                                                width: screenWidth * 0.05,
                                                color: Colors.orange,
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .diagramProject,
                                                  size: screenWidth * 0.04,
                                                ),
                                              )
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
          if (GlobalStrings.getGlobalString() == "GROUP_ADMIN")
            Positioned(
              bottom: 4.0, // Adjust this value as needed
              right: 16.0, // Adjust this value as needed
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMember()),
                  );
                  if (result != null) {
                    print("poppeeddd");
                    fetchMembers();
                  }
                },
                child: Container(
                  height: screenWidth * 0.12,
                  width: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(screenWidth * 0.12),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.plus,
                          weight: 5,
                          size: 16,
                        ),
                        Text(
                          "Add Member".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Positioned(
          //   bottom: 16.0, // Adjust this value as needed
          //   left: 16.0, // Adjust this value as needed
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const AddMember()),
          //       );
          //     },
          //     child: Container(
          //       height: screenWidth * 0.12,
          //       width: screenWidth * 0.12,
          //       decoration: BoxDecoration(
          //         color: Colors.orange,
          //         borderRadius: BorderRadius.circular(screenWidth * 0.12),
          //       ),
          //       child: const Center(
          //         child: Icon(Icons.add),
          //       ),
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }

  Future<void> fetchMembers() async {
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
        Uri.https(baseUrl, '/api/v1/groups/$groupId/members'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<MemberData> newMember = [];
      for (var member in data['memberList']) {
        newMember.add(MemberData(
          phoneNumber: member['phoneNumber'],
          proxy: member['proxy'],
          userId: member['userId'],
          fullName: utf8.decode(member['fullName'].runes.toList()),
          gender: member['gender'],
          loanBalance: member['loanBalance'],
          paid: member['paid'],
          totalOwning: member['totalOwning'],
          vslaRole: member['vslaRole'],
        ));
      }

      setState(() {
        male = data['genderStatics']['male'];
        female = data['genderStatics']['female'];
      });
      allMembers.clear();
      allMembers.addAll(newMember);
      print(allMembers.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  void editModal(MemberData allMember) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    var loading1 = false;
    bool selectedProxy = allMember.proxy;
    print(selectedProxy);
    fullNameController.text = allMember.fullName;
    phoneNumberController.text = allMember.phoneNumber;
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
          title: const Text('Edit Member'), // Set your dialog title
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
              child: TextFormField(
                validator: _validateField,
                controller: fullNameController,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<bool>(
                value: selectedProxy,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  labelText: "Proxy enabled *",
                  hintText: "yes / no",
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFFF89520)),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFFF89520)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xFFF89520)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xFFF89520)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xFFF89520)),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                items: [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Center(
                      child: Text('Yes',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Center(
                      child: Text('No',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedProxy = value!;
                    print("herrreree");
                    print(selectedProxy);
                  });
                },
                hint: Text("yes / no",
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFFF89520))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                validator: _validateField,
                controller: phoneNumberController,
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
                  labelText: "Phone number / Username *",
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFFF89520)),
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this user?'),
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
                                Navigator.of(context)
                                    .pop(true); // User confirms deletion
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmDelete) {
                      loading1 = true;
                      if (fullNameController.text.isEmpty) {
                        const message = 'Full name is mandatory';
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Fluttertoast.showToast(msg: message, fontSize: 18);
                        });
                      } else if (phoneNumberController.text.length != 9 ||
                          phoneNumberController.text == "") {
                        const message = 'Invalid phone number format';
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Fluttertoast.showToast(msg: message, fontSize: 18);
                        });
                      } else {
                        setState(() {
                          loading = true;
                        });
                        // final body = {
                        //   "phoneNumber": phoneNumberController.text,
                        //   "fullName": fullNameController.text,
                        //   "proxyEnabled": selectedProxy
                        // };
                        // print(body);
                        try {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var accessToken = prefs.getStringList("_keyUser");
                          final String authToken = accessToken![0];
                          final client = createIOClient();

                          var response = await client.delete(
                            Uri.https(baseUrl,
                                "/api/v1/groups/delete-member/${allMember.userId}"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization': 'Bearer $authToken',
                            },
                          );
                          // print("here" + "${response.statusCode}");
                          // print(response.body);
                          if (response.statusCode == 200) {
                            setState(() {
                              loading1 = false;
                            });
                            const message = 'Account Deleted Successfuly!';
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              Fluttertoast.showToast(
                                  msg: message, fontSize: 18);
                            });
                            Navigator.of(context)
                                .pop(); // Close the dialog when the user presses the button
                          } else if (response.statusCode != 200) {
                            final responseBody = json.decode(response.body);
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
                                  "Account creation failed please try again";
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
                          Fluttertoast.showToast(msg: message, fontSize: 18);
                        } finally {
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    }
                  },
                  child: loading1
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : Text('Delete User',
                          style: GoogleFonts.poppins(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () async {
                    loading1 = true;
                    if (fullNameController.text.isEmpty) {
                      const message = 'Full name is mandatory';
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      });
                    } else if (phoneNumberController.text.length != 9 ||
                        phoneNumberController.text == "") {
                      const message = 'Invalid phone number format';
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      });
                    } else {
                      setState(() {
                        loading = true;
                      });
                      final body = {
                        "phoneNumber": phoneNumberController.text,
                        "fullName": fullNameController.text,
                        "proxyEnabled": selectedProxy
                      };
                      print(body);
                      try {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var accessToken = prefs.getStringList("_keyUser");
                        final String authToken = accessToken![0];
                        final client = createIOClient();

                        var response = await client.put(
                          Uri.https(baseUrl,
                              "/api/v1/groups/edit-member/${allMember.userId}"),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
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
                          const message = 'Account Updated Successfuly!';
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Fluttertoast.showToast(msg: message, fontSize: 18);
                          });
                          fetchMembers();
                          Navigator.of(context)
                              .pop(); // Close the dialog when the user presses the button
                        } else if (response.statusCode != 200) {
                          final responseBody = json.decode(response.body);
                          final description = responseBody?[
                              'message']; // Extract 'description' field
                          if (description == "Phone number is already taken") {
                            Fluttertoast.showToast(
                                msg: "This phone number is already registered",
                                fontSize: 18);
                          } else {
                            var message = description ??
                                "Account creation failed please try again";
                            Fluttertoast.showToast(msg: message, fontSize: 18);
                          }
                          setState(() {
                            loading1 = false;
                          });
                        }
                      } catch (e) {
                        var message = e.toString();
                        'Please check your network connection';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  child: loading1
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : Text(
                          'Edit',
                          style: GoogleFonts.poppins(color: Colors.green),
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
