// ignore: file_names
import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/home1.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/Pages/inner/meeting_tabs/active.dart';
import 'package:vsla/login.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class CreatGroup extends StatefulWidget {
  const CreatGroup({super.key});

  @override
  State<CreatGroup> createState() => _CreatGroupState();
}

class RegionData {
  final int regionId;
  final String regionName;

  RegionData({
    required this.regionId,
    required this.regionName,
  });
}

class ZoneData {
  final int zoneId;
  final String zoneName;

  ZoneData({
    required this.zoneId,
    required this.zoneName,
  });
}

class IntervalData {
  final int meetingIntervalId;
  final String meetingIntervalName;

  IntervalData({
    required this.meetingIntervalId,
    required this.meetingIntervalName,
  });
}

class GroupData {
  final int groupTypeId;
  final String groupTypeName;

  GroupData({
    required this.groupTypeId,
    required this.groupTypeName,
  });
}

class ProjectData {
  final int projectId;
  final String projectName;

  ProjectData({
    required this.projectId,
    required this.projectName,
  });
}

class _CreatGroupState extends State<CreatGroup> {
  // String? selectedInterval;
  String? selectedGroup;
  String? selectedProject;
  MeetingIntevalData? selectedMeetingInterval;
  TimeOfDay selectedTime = TimeOfDay.now();

  void onChanged(String? value) {
    // print(value);
    setState(() {
      // selectedInterval = value;
    });
  }

  void onChangedGroup(String? value) {
    // print(value);
    setState(() {
      selectedGroup = value;
    });
  }

  void onChangedProject(String? value) {
    // print(value);
    setState(() {
      selectedProject = value;
    });
  }

  String selectedDate = "";
  List<MeetingIntevalData> interval = [];
  List<GroupData> groupTypes = [];
  List<ZoneData> myZones = [];
  List<RegionData> myRegions = [];
  List<ProjectData> projects = [];
  RegionData? selectedRegion;
  ZoneData? selectedZone;
  TextEditingController groupNameController = new TextEditingController();
  TextEditingController woredaController = new TextEditingController();
  TextEditingController entryFeeController = new TextEditingController();
  TextEditingController cycleController = new TextEditingController();
  TextEditingController interestRateController = new TextEditingController();
  TextEditingController socialFundAmountController =
      new TextEditingController();
  TextEditingController groupSizeController = TextEditingController();
  TextEditingController kebeleController = new TextEditingController();
  var loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final String groupName = groupNameController.text;
      final int groupSize = int.parse(groupSizeController.text);
      final int entryFee = int.parse(entryFeeController.text);
      final int socialFundAmount = int.parse(socialFundAmountController.text);
      final double interestRate = double.parse(interestRateController.text);
      final String woreda = woredaController.text;
      final String kebele =
          kebeleController.text != '' ? kebeleController.text : '';
      final Map<String, dynamic> requestBody = {
        "groupName": groupName,
        "groupSize": groupSize,
        "shareAmount": entryFee,
        "socialFundAmount": socialFundAmount,
        "interestRate": interestRate,
        "meetingIntervalId": selectedMeetingInterval!.meetingIntervalId,
        "projectId": selectedProject,
        "groupTypeId": selectedGroup,
        "meetingDate":
            "$selectedDate ${selectedTime.hour.toString().length == 1 ? '0${selectedTime.hour}' : selectedTime.hour}:${selectedTime.minute.toString().length == 1 ? '0${selectedTime.minute}' : selectedTime.minute}:00",
        "cycleSize": cycleController.text,
        "meetingIntervalDays": selectedMeetingInterval!.intervalInDays,
        "meetingIntervalName": selectedMeetingInterval!.meetingIntervalName,
        "entryFee": 0,
        "address": {
          "region": selectedRegion!.regionName,
          "zone": selectedZone!.zoneName,
          "woreda": woreda,
          "kebele": kebele == "" ? "null" : kebele,
        }
      };
      print(requestBody);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String phone = accessToken[1];
      final String orgId = accessToken[2];
      final String role = accessToken[3];
      final client = createIOClient();

      final response = await client.post(Uri.https(baseUrl, '/api/v1/groups'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestBody));
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        var groupId = data['groupId'];
        List<String> newUser = [
          authToken,
          phone,
          groupId.toString(),
          orgId,
          role
        ];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList("_keyUser", newUser);
        print(newUser);
        setState(() {
          loading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home1()));
        print("saved");
        // Successful response, handle it as needed
        // You can navigate to a success screen or perform other actions.
      } else {
        setState(() {
          loading = false;
        });
        print(response.body);
        // Handle errors or failed requests
        // You can show an error message or perform error-specific actions.
      }
    }
  }

  String? _validateGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    // Use a regular expression to check if the input contains only letters
    final RegExp alphaRegex = RegExp(r'^[A-Za-z]+$');
    if (!alphaRegex.hasMatch(value)) {
      return 'Please enter only letters';
    }
    return null;
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateDate(DateTime? value) {
    if (value == null) {
      return 'This field is required';
    }
    return null;
  }

  int groupSize = 5;
  void incrementCounter() {
    setState(() {
      groupSize++;
    });
  }

  void decrementCounter() {
    setState(() {
      groupSize--;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMeetingIntervals();
    fetchGroup();
    fetchProject();
    fetchRegions();
  }

  @override
  Widget build(BuildContext context) {
    void valuechanged(_value) {}

    final groupName = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.name,
        validator: _validateField,
        controller: groupNameController,
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
          labelText: "Group Name *",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );
    final region = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Region *",
          hintText: "Choose Region",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
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
        items: myRegions.map((RegionData regions) {
          return DropdownMenuItem<String>(
            value: regions.regionId.toString(),
            child: Text(
              regions.regionName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRegion = myRegions.firstWhere(
              (element) => element.regionId.toString() == value,
            );
            myZones.clear();
            selectedZone = null;
          });
          fetchZone(selectedRegion!.regionId.toString());
        },
        hint: Text("Select Region",
            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );

    final zone = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: myZones.isNotEmpty ? myZones.first.zoneId.toString() : null,
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Zone/ Subcity *",
          hintText: "Choose zone/subcity",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
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
        items: myZones.map((ZoneData zones) {
          return DropdownMenuItem<String>(
            value: zones.zoneId.toString(),
            child: Text(
              zones.zoneName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedZone = myZones.firstWhere(
              (element) => element.zoneId.toString() == value,
              // orElse: () => null,
            );
          });
        },
        hint: Text("Select zone",
            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );

    final woreda = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        validator: _validateField,
        controller: woredaController,
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
          labelText: "Woreda *",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );

    final kebele = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        // validator: ,
        controller: kebeleController,
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
          labelText: "Kebele",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );

    // Initial group size

    final groupSizeWidget = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        validator: _validateField,
        readOnly: true,
        controller: groupSizeController,
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
          labelText: groupSize.toString(),
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {
                  // Increase group size
                  incrementCounter();
                  groupSizeController.text = '$groupSize';
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  // Decrease group size, but not below 5
                  if (groupSize > 5) {
                    '$groupSize';
                    decrementCounter();
                    groupSizeController.text = '$groupSize';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );

    final entryFee = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: _validateField,
        controller: entryFeeController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          labelText: "Share Amount*",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );
    final cycle = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: _validateField,
        controller: cycleController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          labelText: "No. of Cycle(s)*",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );
    final socialFund = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: _validateField,
        controller: socialFundAmountController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          labelText: "Social Fund Amount",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );
    final interest = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: _validateField,
        controller: interestRateController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFF89520)),
          ),
          labelText: "Interest Rate* (%)",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
        ),
      ),
    );
    final firstMeetingDate = Padding(
      padding: const EdgeInsets.all(16.0),
      child: DateTimeFormField(
        firstDate: DateTime.now(),
        validator: _validateDate,
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
          labelText: "First Meeting Date *",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintText: "Select First Meeting Date",
        ),
        mode: DateTimeFieldPickerMode.date,
        onDateSelected: (DateTime value) {
          // Format the selected date as a string
          selectedDate = DateFormat('yyyy-MM-dd').format(value);
          // print('Selected date: $formattedDate'); // Output: 2023-11-17
          // Handle the formatted date as needed
        },
      ),
    );
    final meetingInterval = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        // value: selectedMeetingInterval!.meetingIntervalName,
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Meeting Interval *",
          hintText: "Choose meeting interval",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
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
        items: interval.map((MeetingIntevalData intervals) {
          return DropdownMenuItem<String>(
            value: intervals.meetingIntervalId.toString(),
            child: Text(
              intervals.meetingIntervalName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            // selectedInterval = newValue;
            selectedMeetingInterval = interval.firstWhere(
              (element) => element.meetingIntervalId.toString() == newValue,
              // orElse: () => null,
            );
          });
        },
        hint: Text("Select meeting interval",
            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );
    final groupType = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selectedGroup,
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Group Type *",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
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
        items: groupTypes.map((GroupData intervals) {
          return DropdownMenuItem<String>(
            value: intervals.groupTypeId.toString(),
            child: Text(
              intervals.groupTypeName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: onChangedGroup,
        hint: Text("Group Type",
            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );
    final project = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selectedProject,
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Select Project *",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
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
        items: projects.map((ProjectData intervals) {
          return DropdownMenuItem<String>(
            value: intervals.projectId.toString(),
            child: Text(
              intervals.projectName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: onChangedProject,
        hint: Text("Select Project",
            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _onBackButtonPressed(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new_sharp)),
                    Image(
                        height: MediaQuery.of(context).size.height * 0.05,
                        image: const AssetImage("assets/images/vsla.png"))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 8),
                    child: Text(
                      "Create Group",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              groupName,
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: project,
                  ),
                  const SizedBox(
                    width:
                        1.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: groupType,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: region,
                  ),
                  const SizedBox(
                    width:
                        1.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: zone,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: woreda,
                  ),
                  const SizedBox(
                    width:
                        16.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: kebele,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: socialFund,
                  ),
                  const SizedBox(
                    width:
                        16.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: interest,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 2),
                    child: Text(
                      "Group size *",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Color(0xFFF89520)),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: groupSizeWidget,
                  ),
                  const SizedBox(
                    width:
                        16.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: entryFee,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: cycle,
                  ),
                  const SizedBox(
                    width:
                        16.0, // Adjust this value as needed for the gap between the widgets
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the radius as needed
                            ),
                          ),
                          onPressed: () {
                            _selectTime(context);
                            print(selectedTime.hour.toString().length);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                selectedTime.hour.isNaN
                                    ? "Meeting Time"
                                    : "${selectedTime.hour} : ${selectedTime.minute}",
                                style: TextStyle(color: Color(0xFFF89520)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              firstMeetingDate,
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              meetingInterval,
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFF89520), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Save",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.white),
                      ), // Button text
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ]),
          ),
        )),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
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
      interval.addAll(newMeeting);
      print("meetingInterval");
      print(interval.length);

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

  Future<void> fetchGroup() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      print(accessToken);
      final String authToken = accessToken![0];
      final String orgId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/group-types/by-organization'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<GroupData> newGroupType = [];

      for (var groupType in data) {
        // print(transaction.date);
        var groupTypeData = GroupData(
          groupTypeId: groupType['groupTypeId'],
          groupTypeName: groupType['groupTypeName'],
        );
        newGroupType.add(groupTypeData);
        // print(company);
      }
      groupTypes.addAll(newGroupType);
      print(groupTypes.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      var message =
          'Something went wrong. Please check your internet connection.';
      print(e.toString());
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchRegions() async {
    try {
      // var user = await SimplePreferences().getUser();
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // var accessToken = prefs.getStringList("_keyUser");
      // print(accessToken);
      // final String authToken = accessToken![0];
      // final String orgId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/Regions/getAll'),
        headers: <String, String>{
          // 'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<RegionData> newRegions = [];

      for (var region in data) {
        // print(transaction.date);
        var regionsData = RegionData(
          regionId: region['regionId'],
          regionName: region['regionName'],
        );
        newRegions.add(regionsData);
        // print(company);
      }
      myRegions.addAll(newRegions);
      print(newRegions.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      var message =
          'Something went wrong. Please check your internet connection.';
      print(e.toString());
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchZone(String regionId) async {
    try {
      // var user = await SimplePreferences().getUser();
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // var accessToken = prefs.getStringList("_keyUser");
      // print(accessToken);
      // final String authToken = accessToken![0];
      // final String orgId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/Zone/getAll/$regionId'),
        headers: <String, String>{
          // 'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<ZoneData> newZoneData = [];

      for (var zone in data) {
        // print(transaction.date);
        var zonesData = ZoneData(
          zoneId: zone['zoneId'],
          zoneName: zone['zoneName'],
        );
        newZoneData.add(zonesData);
        // print(company);
      }
      setState(() {
        myZones.addAll(newZoneData);
      });
      print(myZones.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      var message =
          'Something went wrong. Please check your internet connection.';
      print(e.toString());
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchProject() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String orgId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/projects/by-organization'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<ProjectData> newProject = [];

      for (var project in data) {
        // print(transaction.date);
        var intervalData = ProjectData(
          projectId: project['projectId'],
          projectName: project['projectName'],
        );
        newProject.add(intervalData);
        // print(company);
      }
      projects.addAll(newProject);
      print(projects.length);

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
}
