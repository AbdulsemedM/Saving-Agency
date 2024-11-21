import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/Pages/inner/meeting_tabs/active.dart';
import 'package:vsla/Pages/inner/meeting_tabs/inactive.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings>
    with SingleTickerProviderStateMixin {
  List<MeetingTypeData> meetingTypes = [];
  List<MeetingIntevalData> meetingIntervals = [];
  TextEditingController currentRound = new TextEditingController();
  // TextEditingController meetingReason = new TextEditingController();
  String? meeetingType;
  String? meetingInterval;
  String? meeetingTypeId;
  String? meetingIntervalId;
  String? nextMeetingDate;
  String? intervalDays;
  final GlobalKey<FormState> myKey = GlobalKey();
  TabController? _tabController;
  var loading = false;
  String selectedDate = "";
  bool? done;

  final List<Tab> _tabs = const [
    Tab(text: "Active"),
    Tab(text: "Inactive"),
  ];
  final List<Widget> _pages = const [
    ActiveMeeting(),
    InactiveMeeting(),
  ];
  void initState() {
    super.initState();
    fetchMeetingTypes();
    fetchMeetingIntervals();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    // var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.orange,
                      labelColor: Colors.orange,
                      controller: _tabController,
                      tabs: _tabs),
                  SizedBox(
                    height: sHeight * 0.85,
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (GlobalStrings.getGlobalString() == 'GROUP_ADMIN')
          Positioned(
            bottom: 0,
            // left: ,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Issue a meeting'),
                        // content: Text(""),
                        content: SingleChildScrollView(
                          child: Form(
                              key: myKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12.0, 10.0, 12.0, 10.0),
                                            labelText: "Meeting Type*",
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          items: meetingTypes
                                              .map((MeetingTypeData meetTs) {
                                            return DropdownMenuItem<String>(
                                              value: meetTs.meetingTypeId
                                                  .toString(),
                                              child: Text(
                                                meetTs.meetingTypeName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              meeetingTypeId = value;
                                              MeetingTypeData
                                                  selectedMeetingType =
                                                  meetingTypes.firstWhere(
                                                      (meetTs) =>
                                                          meetTs.meetingTypeId
                                                              .toString() ==
                                                          value);
                                              meeetingType = selectedMeetingType
                                                  .meetingTypeName
                                                  .toString();
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return "Meeting type is required.";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8),
                                    //   child: TextFormField(
                                    //     validator: (value) {
                                    //       if (value == null) {
                                    //         return null;
                                    //       } else {
                                    //         return null;
                                    //       }
                                    //     },
                                    //     controller: meetingReason,
                                    //     decoration: InputDecoration(
                                    //       contentPadding: EdgeInsets.fromLTRB(
                                    //           12.0, 10.0, 12.0, 10.0),
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10.0),
                                    //         borderSide: BorderSide(
                                    //             color: Color(0xFFF89520)),
                                    //       ),
                                    //       focusedBorder: OutlineInputBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10.0),
                                    //         borderSide: BorderSide(
                                    //             color: Color(0xFFF89520)),
                                    //       ),
                                    //       labelText: "Meeting Reason",
                                    //       labelStyle: GoogleFonts.poppins(
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12.0, 10.0, 12.0, 10.0),
                                            labelText: "Meeting Interval*",
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFF89520)),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          items: meetingIntervals
                                              .map((MeetingIntevalData meetIs) {
                                            return DropdownMenuItem<String>(
                                              value: meetIs.meetingIntervalId
                                                  .toString(),
                                              child: Text(
                                                meetIs.meetingIntervalName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              meetingIntervalId = value;
                                              MeetingIntevalData
                                                  selectedMeetingInterval =
                                                  meetingIntervals.firstWhere(
                                                      (meetIs) =>
                                                          meetIs
                                                              .meetingIntervalId
                                                              .toString() ==
                                                          value);
                                              intervalDays =
                                                  selectedMeetingInterval
                                                      .intervalInDays
                                                      .toString();
                                              meetingInterval =
                                                  selectedMeetingInterval
                                                      .meetingIntervalName
                                                      .toString();
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return "Meeting inteval is required.";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DateTimeFormField(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12.0, 10.0, 12.0, 10.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF89520)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF89520)),
                                          ),
                                          labelText: "Next Meeting Date *",
                                          labelStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color(0xFFF89520)),
                                          hintText: "Select next Meeting Date",
                                        ),
                                        mode: DateTimeFieldPickerMode.date,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Next date is required.";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onDateSelected: (DateTime value) {
                                          // Format the selected date as a string
                                          nextMeetingDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(value);
                                          print(
                                              'Selected date: $nextMeetingDate'); // Output: 2023-11-17
                                          // Handle the formatted date as needed
                                        },
                                        firstDate: DateTime.now(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: TextFormField(
                                        controller: currentRound,
                                        validator: (value) {
                                          if (value == null) {
                                            return null;
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12.0, 10.0, 12.0, 10.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF89520)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF89520)),
                                          ),
                                          labelText: "Current Round*",
                                          labelStyle: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // User does not confirm deletion
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await apply();
                                            if (done == true) {
                                              Navigator.of(context).pop(
                                                  true); // User confirms deletion
                                            } else {
                                              const message =
                                                  'Please check your network connection';
                                              Fluttertoast.showToast(
                                                  msg: message, fontSize: 18);
                                            }
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_card_sharp,
                      color: Colors.black,
                    ),
                    Text(
                      'Add meeting',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    ));
  }

  Future<void> apply() async {
    print("mybodyyyyy");
    if (myKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final body = {
        "currentRound": int.parse(currentRound.text),
        "nextMeetingDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateTime.parse(nextMeetingDate!)),
        "meetingInterval": meetingInterval,
        "meetingIntervalId": meetingIntervalId,
        "intervalDays": intervalDays,
        "meetingType": meeetingType,
        "meetingTypeId": meeetingTypeId,
        // "meetingReason": meetingReason.text,
        "group": {"groupId": groupId}
      };
      print("mybodyyyyy");
      print(body);
      try {
        final client = createIOClient();

        var response = await client.post(
          Uri.https(baseUrl, "/api/v1/meetings/createMeeting"),
          headers: <String, String>{
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        // print("here" + "${response.statusCode}");
        // print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
            done = true;
            // currentRound.clear();
            // loanDescController.clear();
            // loanInterestController.clear();
            // selectedMember = "";
            // selectedPlan = "";
          });
          const message = 'Meeting created successfully';
          Future.delayed(const Duration(milliseconds: 100), () {
            Fluttertoast.showToast(msg: message, fontSize: 18);
          });

          // ignore: use_build_context_synchronously

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Otp()));
          setState(() {
            loading = false;
          });
        } else if (response.statusCode != 201) {
          final responseBody = json.decode(response.body);
          final description =
              responseBody?['message']; // Extract 'description' field
          if (description == "Something went wrong, please try again") {
            Fluttertoast.showToast(
                msg: "Something went wrong, please try again", fontSize: 18);
          } else {
            var message =
                description ?? "Something went wrong, please try again";
            Fluttertoast.showToast(msg: message, fontSize: 18);
          }
          setState(() {
            loading = false;
          });
        }
      } catch (e) {
        var message = e.toString();
        print(e.toString());
        'Please check your network connection';
        Fluttertoast.showToast(msg: message, fontSize: 18);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> fetchMeetingTypes() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/meeting-types/getAll/App'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<MeetingTypeData> newMeeting = [];

      for (var meet in data) {
        // print(transaction.date);
        var meetings = MeetingTypeData(
            meetingTypeId: meet['meetingTypeId'].toString(),
            meetingTypeName: meet['meetingTypeName']);
        newMeeting.add(meetings);
        // print(company);
      }
      meetingTypes.addAll(newMeeting);
      print("meetingTypes");
      print(meetingTypes.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchMeetingIntervals() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/meeting-intervals/getAll/App'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<MeetingIntevalData> newMeeting = [];

      for (var meet in data) {
        // print(transaction.date);
        var meetings = MeetingIntevalData(
            meetingIntervalId: meet['meetingIntervalId'].toString(),
            meetingIntervalName: meet['meetingIntervalName'],
            intervalInDays: meet['intervalInDays']);
        newMeeting.add(meetings);
        // print(company);
      }
      meetingIntervals.addAll(newMeeting);
      print("meetingInterval");
      print(meetingIntervals.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
