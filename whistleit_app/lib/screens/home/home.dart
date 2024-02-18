import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:whistleit_app/constants/colors.dart';
import 'package:whistleit_app/screens/addreport/addreport.dart';
import 'package:whistleit_app/screens/casedetails/casedetails.dart';
import 'package:whistleit_app/screens/history/history.dart';
import 'package:whistleit_app/screens/initial/splashscreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var cases_reported = 0;
  var cases_in_review = 0;
  var cases_completed = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateStats();
  }

  Future calculateStats() async {
    await FirebaseFirestore.instance
        .collection("cases")
        .where('uploaded_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        cases_reported = value.docs.length;
      });
    });

    await FirebaseFirestore.instance
        .collection("cases")
        .where('uploaded_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('current_status', isEqualTo: "completed")
        .get()
        .then((value) {
      setState(() {
        cases_completed = value.docs.length;
      });
    });

    cases_in_review = cases_reported - cases_completed;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
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
                              fontSize: 24),
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
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Dashboard',
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/svg/Book.svg'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          cases_reported.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 36,
                          ),
                        ),
                        const Text(
                          'Cases Reported',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Added space between containers
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: thirdColor,
                            border: Border.all(color: Colors.grey.shade200)),
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/svg/HourGlass.svg'),
                            Column(
                              children: [
                                Text(
                                  cases_in_review.toString(),
                                  style: const TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 36,
                                  ),
                                ),
                                const Text(
                                  'In Review',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Added space between containers
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10),
                          color: thirdColor,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/svg/Completed.svg'),
                            Column(
                              children: [
                                Text(
                                  cases_completed.toString(),
                                  style: const TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 36,
                                  ),
                                ),
                                const Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white,
            ),
            const Text(
              'Recently Reported',
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
            ),
            //

            StreamBuilder(
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
                  return SizedBox(
                    height: 160,
                    child: PageView.builder(
                        itemCount: snapshot.data!.docs.length,
                        scrollDirection: Axis.horizontal,
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
                        }),
                  );
                }
              },
            ),

            const Text(
              'Report an Issue',
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
            ),
            Column(
              children: [
                Text(
                  'Don’t let crime go unnoticed, report an issue to resolve it safely and anonymously.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Get.to(const AddReport(), transition: Transition.fadeIn);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    'Create a Report',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: primaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
                color: Colors.grey[400],
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
        height: 160,
        width: 100,
        decoration: BoxDecoration(
            color: thirdColor,
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
                        '${caseTitle}',
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
}
