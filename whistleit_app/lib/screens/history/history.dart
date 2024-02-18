import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whistleit_app/constants/colors.dart';
import 'package:whistleit_app/screens/casedetails/casedetails.dart';

import '../addreport/addreport.dart';
import '../home/home.dart';
import '../initial/splashscreen.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WhistleIt",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName != null
                            ? "Hey, ${FirebaseAuth.instance.currentUser!.displayName} "
                            : "Hey, User",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.offAll(const SplashScreen(),
                                  transition: Transition.circularReveal);
                            },
                            child: const Icon(Icons.logout_outlined)),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My History',
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("cases")
                    .where('uploaded_by',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 160,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () {
                              Get.to(CaseDetails(documentSnapshot),
                                  transition: Transition.downToUp);
                            },
                            child: Card(
                              caseId: documentSnapshot['case_id'],
                              caseTitle: documentSnapshot['case_title'],
                              caseStatus: documentSnapshot['current_status'],
                              caseDesc: documentSnapshot['case_description'],
                              caseLocation: documentSnapshot['location_place'],
                              caseCategory: documentSnapshot['category'],
                              caseParty: documentSnapshot['involved_party'],
                              caseDate: documentSnapshot['date_of_incident'],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey[400],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
                color: primaryColor,
              ),
              label: 'My reports')
        ],
        onTap: (value) {
          if (value == 0) {
            Get.offAll(() => const Home(), transition: Transition.fadeIn);
          }
          if (value == 1) {
            Get.offAll(() => const History(), transition: Transition.fadeIn);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 55,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(const AddReport(), transition: Transition.fadeIn);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
        ),
      ),
    );
  }
}

Widget Card(
    {caseId,
    caseTitle,
    caseStatus,
    caseDesc,
    caseLocation,
    caseCategory,
    caseParty,
    caseDate}) {
  return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case ID: ${caseId}',
                      style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Case Title: ${caseTitle}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            caseStatus.toString().toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseDesc,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: secondaryColor,
                          size: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ${caseLocation}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.category,
                          color: secondaryColor,
                          size: 16,
                        ),
                        Text(
                          ' Category: ${caseCategory}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: secondaryColor,
                        size: 16,
                      ),
                      Text(
                        ' Party Involved: ${caseParty}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: secondaryColor,
                        size: 16,
                      ),
                      Text(
                        ' Reported On: ${caseDate}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ],
      ));
}
