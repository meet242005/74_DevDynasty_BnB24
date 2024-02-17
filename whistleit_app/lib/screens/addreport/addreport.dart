import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:whistleit_app/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../../package/mapsearch.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController _caseTitle = new TextEditingController();
  TextEditingController _caseDescription = new TextEditingController();
  TextEditingController _dateOfOccurence = new TextEditingController();
  TextEditingController _involvedParty = new TextEditingController();
  TextEditingController _contactName = new TextEditingController();
  TextEditingController _contactNumber = new TextEditingController();

  TextEditingController myController = TextEditingController();
  String? _caseCategory = "Fraud";
  var is_anonymous = true;
  // late MapController controller;
  var occurence_location, latitude, longitude;

  final formKey = GlobalKey<FormState>();
  List places = [];
  List file_data = [];

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
    // controller = MapController(
    //   initMapWithUserPosition: true,
    // );
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      try {
        Reference storageRef = FirebaseStorage.instance
            .ref('evidences')
            .child(DateTime.now().toString() + file.name);
        UploadTask uploadTask = storageRef.putFile(File(file.path!));
        await uploadTask.whenComplete(
          () {
            print('File uploaded successfully');
            file_data.add([file.name, storageRef.getDownloadURL()]);
            setState(() {});
          },
        );
      } catch (e) {
        print('Error uploading file: $e');
      }
    } else {
      print('User canceled file picker');
      Get.snackbar('Error', 'User canceled file picker');
    }
  }

  _printLatestValue() {
    print("Textfield value: ${myController.text}");
    for (int i = 0; i < places.length; i++) {
      if (places[i].toString().split(";")[0] == myController.text) {
        occurence_location = places[i].toString().split(";")[0];
        latitude = places[i].toString().split(";")[1];
        longitude = places[i].toString().split(";")[2];
        // changeLocation();
      }
    }
  }

  // Future changeLocation() async {
  //   await controller.changeLocation(GeoPoint(
  //       latitude: double.parse(latitude!),
  //       longitude: double.parse(longitude!)));
  // }

  Future<List> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    String _inputText = myController.text;

    var response = await http.get(
      Uri.https(
        "nominatim.openstreetmap.org",
        '',
        {'q': _inputText, 'format': 'json', 'countrycodes': 'in', 'limit': '6'},
      ),
    );
    print('Response status: ${response.statusCode}');
    List<dynamic> jsonData = json.decode(response.body);

    List _list = [];
    _list.clear();
    places.clear();
    try {
      for (int i = 0; i < jsonData.length; i++) {
        _list.add(jsonData[i]['display_name']);
        places.add(jsonData[i]['display_name'] +
            ";" +
            jsonData[i]['lat'] +
            ";" +
            jsonData[i]['lon']);
        print(places);
      }
    } catch (Exception) {}
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          toolbarHeight: 100,
          title: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_new),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WhistleIt",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            fontSize: 24),
                      ),
                      Text(
                        "Create New Report",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Case Title",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return "Enter Case Title";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _caseTitle,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Enter Case Title',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: secondaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //
                //
                const Text(
                  "Case Description",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return "Enter Case Description";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 10,
                      controller: _caseDescription,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Enter Case Description',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: secondaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //
                //
                const Text(
                  "Case Category",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input == null) return "Please choose case category";
                      },
                      //elevation: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      value: _caseCategory,
                      iconEnabledColor: secondaryColor,
                      items: <String>[
                        "Fraud",
                        "Bribery",
                        "Kickbacks",
                        "Embezzlement",
                        "Collusion",
                        "Insider Trading",
                        "Money Laundering",
                        "Conflict of Interest",
                        "Nepotism",
                        "Extortion",
                        "Influence Peddling",
                        "Graft",
                        "Favoritism",
                        "Patronage",
                        "Abuse of Power",
                        "Misuse of Public Funds",
                        "Cronyism",
                        "Bid Rigging",
                        "Unfair Competition",
                        "Tax Evasion",
                        "Identity Theft",
                        "Black Market",
                        "Trafficking",
                        "Cybercrime"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      hint: const Text(
                        "Please choose case category",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, color: secondaryColor),
                      ),
                      onChanged: (String? value) {
                        setState(() {});
                        _caseCategory = value!;
                      },
                    ),
                  ),
                ),
                //
                //
                const Text(
                  "Date of Occurence",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _dateOfOccurence,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input != "") {
                          return null;
                        } else {
                          return "Choose a date";
                        }
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, color: secondaryColor),
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          color: secondaryColor,
                        ),
                        hintText: "Choose Date of Occurence",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: secondaryColor),
                        border: InputBorder.none,
                      ),
                      onChanged: ((value) {}),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050));

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                          setState(() {
                            _dateOfOccurence.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const Text(
                  "Involved Party",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return "Enter Involved Names";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _involvedParty,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Enter Involved Party',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: secondaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //
                //
                const Text(
                  "Location of Occurence",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFieldSearch(
                        label: "label",
                        controller: myController,
                        textStyle: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: secondaryColor),
                            hintText: "Enter Location of Occurence",
                            border: InputBorder.none),
                        future: () {
                          return fetchData();
                        }),
                  ),
                ),
                //
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upload Evidence(s)",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                          fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        pickFile();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "UPLOAD",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
                for (var i = 0; i < file_data.length; i++)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: thirdColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: file_data[i][0],
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: secondaryColor),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            file_data.removeAt(i);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.clear,
                            color: secondaryColor,
                          ),
                        )
                      ],
                    ),
                  ),

                //
                //
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Report Anonymously?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                          fontSize: 15),
                    ),
                    ToggleSwitch(
                      cornerRadius: 8,
                      animate: true,
                      initialLabelIndex: is_anonymous ? 0 : 1,
                      minHeight: 30,
                      activeBgColor: [primaryColor],
                      inactiveBgColor: thirdColor,
                      activeFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: ['Yes', 'No'],
                      onToggle: (index) {
                        setState(() {});
                        is_anonymous = !is_anonymous;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                is_anonymous
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Contact Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: secondaryColor,
                                fontSize: 15),
                          ),

                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: thirdColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: TextFormField(
                                controller: _contactName,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Contact Name',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: secondaryColor),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          //
                          //
                          const Text(
                            "Contact Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: secondaryColor,
                                fontSize: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: thirdColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: TextFormField(
                                controller: _contactNumber,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Contact Number',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: secondaryColor),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          try {
            if (formKey.currentState!.validate()) {
              var upload =
                  await FirebaseFirestore.instance.collection("cases").add({
                'case_title': _caseTitle.text,
                'case_description': _caseDescription.text,
                'location_place': occurence_location.toString(),
                'location_x': latitude,
                'location_y': longitude,
                'is_anonymous': is_anonymous.toString(),
                'contact_name': _contactName.text,
                'contact_phone': _contactNumber.text,
                'date_of_incident': _dateOfOccurence.text,
                'category': _caseCategory,
                'involved_party': _involvedParty.text,
                'current_status': "REGISTERED",
                'created_time': DateTime.now(),
                'modified_time': DateTime.now(),
                'assigned_to': ''
              });

              await FirebaseFirestore.instance
                  .collection("cases")
                  .doc(upload.id)
                  .update({
                'case_id': upload.id,
              });
              var batch = FirebaseFirestore.instance.batch();
              for (var i = 0; i < file_data.length; i++) {
                var ref = FirebaseFirestore.instance
                    .collection("cases")
                    .doc(await upload.id)
                    .collection("evidences")
                    .doc();

                batch.set(ref, {
                  'document_name': await file_data[i][0],
                  'document_link': await file_data[i][1],
                });
              }

              await batch.commit();

              Get.snackbar(
                  "Report Successful", "Your report was added successfully");
            }
          } on FirebaseException catch (e) {
            Get.snackbar("Error Creating Report", e.toString());
          }
        },
        child: Container(
          height: 60,
          decoration: const BoxDecoration(color: primaryColor),
          child: const Center(
            child: Text(
              'Submit Report',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
