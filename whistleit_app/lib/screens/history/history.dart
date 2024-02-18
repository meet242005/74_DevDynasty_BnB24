import 'package:flutter/material.dart';
import 'package:whistleit_app/constants/colors.dart';

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
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      " Hey, Meet Chavan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(Icons.logout),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 700,
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card();
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
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
              color: Colors.grey[400],
            ),
            label: 'My reports')
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 55,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
        ),
      ),
    );
  }
}

Widget Card() {
  return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      margin: EdgeInsets.all(10),
      height: 142,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case ID: #abcdef1234',
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Case Title: Bribery Report',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            'IN REVIEW',
                            style: TextStyle(
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
          SizedBox(
            height: 1,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'description about the case in about 3 three lines with text overflow Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor dhfbs Lorem ipsum dolor sit amet, consectetur adipiscing elit, sanjkds...',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: secondaryColor,
                          size: 12,
                        ),
                        Text(
                          'Location: Vile Parle, Mumbai',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: secondaryColor,
                          size: 12,
                        ),
                        Text(
                          'Category: Bribery',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
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
                      Icon(
                        Icons.people,
                        color: secondaryColor,
                        size: 12,
                      ),
                      Text(
                        'Party Involved: XYZ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: secondaryColor,
                        size: 12,
                      ),
                      Text(
                        'Reported On: 17/02/2024',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
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
