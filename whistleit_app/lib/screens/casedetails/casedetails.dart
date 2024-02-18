import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whistleit_app/constants/colors.dart';

class CaseDetails extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  CaseDetails(DocumentSnapshot this.documentSnapshot, {Key? key});

  @override
  State<CaseDetails> createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100,
        title: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                      color: thirdColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
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
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "View Case Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Case ID: ${widget.documentSnapshot['case_id']}',
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Case Title: ${widget.documentSnapshot['case_title']}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.documentSnapshot['current_status']
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       'Modified on: ${widget.documentSnapshot['modified_time']}',
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //         color: secondaryColor,
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 10,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Created time: ${widget.documentSnapshot['modified_time']}',
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //         color: secondaryColor,
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 10,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 152,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryColor),
              ),
              child: Text(
                widget.documentSnapshot['case_description'].toString(),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: secondaryColor,
                      size: 14,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Category: ${widget.documentSnapshot['category']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: secondaryColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Party Involved:  ${widget.documentSnapshot['involved_party']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: secondaryColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Incident Date:  ${widget.documentSnapshot['date_of_incident']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.assignment,
                      color: secondaryColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Assigned To:  ${widget.documentSnapshot['assigned_to']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: secondaryColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location:  ${widget.documentSnapshot['location_place']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://maps.geoapify.com/v1/staticmap?style=osm-bright-grey&width=1200&height=2000&center=lonlat:${widget.documentSnapshot['location_y']},${widget.documentSnapshot['location_x']}&zoom=10&marker=lonlat:${widget.documentSnapshot['location_y']},${widget.documentSnapshot['location_x']};size:large&apiKey=f9351bb499d244a8b43036c84893a902"),
                      opacity: 0.1,
                      fit: BoxFit.cover)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [Icon(Icons.phone)],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Contact Details:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            ' ${widget.documentSnapshot['contact_name']},  ${widget.documentSnapshot['contact_phone']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Chat With Investigator',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
