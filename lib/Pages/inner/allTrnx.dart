import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:http/http.dart' as http;

class AllTrnx extends StatefulWidget {
  const AllTrnx({super.key});

  @override
  State<AllTrnx> createState() => _AllTrnxState();
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

class _AllTrnxState extends State<AllTrnx> {
  var members = true;
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  List<MemberData> allMembers = [];
  var male = 0;
  var female = 0;
  var loading = true;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return members == false
        ? const Home3()
        : WillPopScope(
            onWillPop: () async {
              if (members) {
                // Set the new state outside onWillPop
                setState(() {
                  members = false;
                });
                // Allow back navigation
                return false;
              } else {
                // Set the new state outside onWillPop
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
                                members = false;
                              });
                            },
                            child: const Icon(Icons.arrow_back_ios_new_sharp)),
                        Image(
                            height: MediaQuery.of(context).size.height * 0.05,
                            image: const AssetImage("assets/images/vsla.png"))
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
                                  editModal(allMembers[index]);
                                },
                                child: Card(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          allMembers[index]
                                                              .fullName,
                                                          style: GoogleFonts
                                                              .roboto(
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
                                                            "Loan balance",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    color: Colors
                                                                            .red[
                                                                        400]),
                                                          ),
                                                        ),
                                                        Text(
                                                          allMembers[index]
                                                              .loanBalance
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                          .red[
                                                                      400]),
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
                                                          child: Text(
                                                            " Paid",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    color: Colors
                                                                            .blue[
                                                                        400]),
                                                          ),
                                                        ),
                                                        Text(
                                                          allMembers[index]
                                                              .paid
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                          .blue[
                                                                      400]),
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
                                                      child: Text("Total Owing",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                          .orange[
                                                                      900])),
                                                    ),
                                                    Text(
                                                      " ${allMembers[index].totalOwning.toString()} ETB",
                                                      style: GoogleFonts.roboto(
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

  Future<void> fetchMembers() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];

      final response = await http.get(
        Uri.http('10.1.177.121:8111', '/api/v1/groups/$groupId/members'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
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
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  void editModal(MemberData allMember) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    var loading1 = false;
    var selectedProxy = allMember.proxy;
    fullNameController.text = allMember.fullName;
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
          title: const Text('Add Round Payment'), // Set your dialog title
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
              child: TextFormField(
                readOnly: true,
                controller: fullNameController,
                validator: _validateField,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFF89520)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFF89520)),
                  ),
                  labelText: "Full name *",
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFF89520)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                value: selectedProxy.toString(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  labelText: "Proxy enabled *",
                  hintText: "yes / no",
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFF89520)),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFF89520)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFF89520)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFF89520)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFF89520)),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: "true",
                    child: Center(
                      child: Text('Yes',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "false",
                    child: Center(
                      child: Text('No',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedProxy = value as bool;
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
              children: [
                // TextButton(
                //   onPressed: () async {
                //     bool confirmDelete = await showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: Text('Confirm Deletion'),
                //           content: Text(
                //               'Are you sure you want to delete this user?'),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop(
                //                     false); // User does not confirm deletion
                //               },
                //               child: Text('Cancel'),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context)
                //                     .pop(true); // User confirms deletion
                //               },
                //               child: Text('Delete'),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //     if (confirmDelete) {
                //       loading1 = true;
                //       if (fullNameController.text.isEmpty) {
                //         const message = 'Full name is mandatory';
                //         Future.delayed(const Duration(milliseconds: 100), () {
                //           Fluttertoast.showToast(msg: message, fontSize: 18);
                //         });
                //       } else {
                //         setState(() {
                //           loading = true;
                //         });
                //         // final body = {
                //         //   "phoneNumber": phoneNumberController.text,
                //         //   "fullName": fullNameController.text,
                //         //   "proxyEnabled": selectedProxy
                //         // };
                //         // print(body);
                //         try {
                //           final SharedPreferences prefs =
                //               await SharedPreferences.getInstance();
                //           var accessToken = prefs.getStringList("_keyUser");
                //           final String authToken = accessToken![0];
                //           var response = await http.delete(
                //             Uri.http("10.1.177.121:8111",
                //                 "/api/v1/groups/delete-member/${allMember.userId}"),
                //             headers: <String, String>{
                //               'Content-Type': 'application/json; charset=UTF-8',
                //               'Authorization': 'Bearer $authToken',
                //             },
                //           );
                //           // print("here" + "${response.statusCode}");
                //           // print(response.body);
                //           if (response.statusCode == 200) {
                //             setState(() {
                //               loading1 = false;
                //             });
                //             const message = 'Account Deleted Successfuly!';
                //             Future.delayed(const Duration(milliseconds: 100),
                //                 () {
                //               Fluttertoast.showToast(
                //                   msg: message, fontSize: 18);
                //             });
                //             Navigator.of(context)
                //                 .pop(); // Close the dialog when the user presses the button
                //           } else if (response.statusCode != 200) {
                //             final responseBody = json.decode(response.body);
                //             final description = responseBody?[
                //                 'message']; // Extract 'description' field
                //             if (description ==
                //                 "Phone number is already taken") {
                //               Fluttertoast.showToast(
                //                   msg:
                //                       "This phone number is already registered",
                //                   fontSize: 18);
                //             } else {
                //               var message = description ??
                //                   "Account creation failed please try again";
                //               Fluttertoast.showToast(
                //                   msg: message, fontSize: 18);
                //             }
                //             setState(() {
                //               loading1 = false;
                //             });
                //           }
                //         } catch (e) {
                //           var message = e.toString();
                //           'Please check your network connection';
                //           Fluttertoast.showToast(msg: message, fontSize: 18);
                //         } finally {
                //           setState(() {
                //             loading = false;
                //           });
                //         }
                //       }
                //     }
                //   },
                //   child: loading1
                //       ? CircularProgressIndicator(
                //           color: Colors.orange,
                //         )
                //       : Text('Delete User',
                //           style: GoogleFonts.poppins(color: Colors.red)),
                // ),
                TextButton(
                  onPressed: () async {
                    loading1 = true;
                    if (fullNameController.text.isEmpty) {
                      const message = 'Full name is mandatory';
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      });
                    } else {
                      setState(() {
                        loading = true;
                      });
                      final body = {
                        "amount": amountController.text,
                        "fullName": fullNameController.text,
                        "proxyEnabled": selectedProxy
                      };
                      print(body);
                      try {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var accessToken = prefs.getStringList("_keyUser");
                        final String authToken = accessToken![0];
                        var response = await http.put(
                          Uri.http("10.1.177.121:8111",
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
                          const message = 'Payment added Successfuly!';
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Fluttertoast.showToast(msg: message, fontSize: 18);
                          });
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
                          'Add',
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
