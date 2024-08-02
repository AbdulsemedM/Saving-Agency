import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/allTrnx.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/role.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class AttendanceData {
  final String userId;
  final String fullName;
  final String gender;
  final String proxy;
  final String round;

  AttendanceData(
      {required this.userId,
      required this.fullName,
      required this.round,
      required this.proxy,
      required this.gender});
}

class _AttendanceState extends State<Attendance> {
  var loading = true;
  List<AttendanceData> allMembers = [];
  final PageController _pageController = PageController();
  var _isCheckedList;

  var admin = GlobalStrings.getGlobalString() == "GROUP_ADMIN" ? true : false;
  @override
  void initState() {
    super.initState();
    fetchMembersRound();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: screenWidth * 0.3,
        height: 50,
        child: admin
            ? ElevatedButton(
                onPressed: () async {
                  bool process = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Caution'.tr),
                        content: Text(
                            "Are you sure, This process is irreversible".tr),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true);
                            },
                            child: Text('Yes'.tr),
                          ),
                        ],
                      );
                    },
                  );
                  if (process) {
                    await apply();
                  }
                },
                child: Text(
                  "Save".tr,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.05),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              )
            : Container(
                width: 0,
              ),
      ),
      body: Container(
        child: Column(
          children: [
            loading
                ? Center(
                    child: const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
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
                            // if (GlobalStrings.getGlobalString() ==
                            //     "GROUP_ADMIN") {
                            //   allMembers[index].proxy.toLowerCase() == "true"
                            //       ? editModal(allMembers[index])
                            //       : null;
                            // }
                          },
                          child: Card(
                            color: Colors.grey[50],
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
                                                child: Text("Round".tr,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors
                                                            .orange[900])),
                                              ),
                                              Text(
                                                " ${allMembers[index].round.toString()}",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    admin
                                        ? Checkbox(
                                            value: _isCheckedList[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _isCheckedList[index] =
                                                    value ?? false;

                                                print(_isCheckedList[index]);
                                              });
                                            },
                                          )
                                        : Container(
                                            width: 0,
                                          ),
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

  Future<void> apply() async {
    print("mybodyyyyy");
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getStringList("_keyUser");
    final String authToken = accessToken![0];
    final String groupId = accessToken[2];
    List<Map<String, dynamic>> meetingDataList = [];
    for (int i = 0; i < allMembers.length; i++) {
      Map<String, dynamic> meetingData = {
        'isPresent': _isCheckedList[i],
        'meetingDate':
            DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'meetingRound': allMembers[i].round,
        'user': {
          'userId': allMembers[i].userId,
        },
      };

      meetingDataList.add(meetingData);
    }
    print(meetingDataList[0]);
    final body = meetingDataList;
    print("mybodyyyyy");
    print(body);
    try {
      var response = await http.post(
        Uri.https(baseUrl, "/api/v1/Attendance/add"),
        headers: <String, String>{
          // 'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        fetchMembersRound();
        setState(() {
          loading = false;
          // currentRound.clear();
          // loanDescController.clear();
          // loanInterestController.clear();
          // selectedMember = "";
          // selectedPlan = "";
        });
        var message = 'Attendance saved successfully'.tr;
        Future.delayed(const Duration(milliseconds: 100), () {
          Fluttertoast.showToast(msg: message, fontSize: 18);
        });

        // ignore: use_build_context_synchronously

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const Otp()));
        setState(() {
          loading = false;
        });
      } else if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        final description =
            responseBody?['message'];
        print(description);
        if (description == "Something went wrong, please try again") {
          Fluttertoast.showToast(
              msg: "Something went wrong, please try again", fontSize: 18);
        } else {
          var message = description ?? "Something went wrong, please try again";
          Fluttertoast.showToast(msg: message, fontSize: 18);
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      var message = e.toString();
      print(e.toString());
      Fluttertoast.showToast(msg: message, fontSize: 18);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> fetchMembersRound() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];

      final response = await http.get(
        Uri.https(
            baseUrl, '/api/v1/groups/$groupId/constributors/roundPayment'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);

      List<AttendanceData> newMember = [];
      for (var member in data) {
        newMember.add(AttendanceData(
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
      _isCheckedList = List.generate(allMembers.length, (index) => false);
      print(allMembers.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
        // group = groupId;
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong, please Check your network connection';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
