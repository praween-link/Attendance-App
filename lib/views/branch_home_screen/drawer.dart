import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/test.dart';
import '../add/branch/connect_new_sheet.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
    required this.data,
  }) : super(key: key);
  final dynamic data;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // Future<void> _launchInBrawser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'header_key': 'header_value0'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColor.buttonSplaceColor2,
              image: DecorationImage(
                image: const AssetImage(
                  "assets/img/ghublogo.png",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.1), BlendMode.dstATop),
              ),
            ),
            child: null,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add_comment_rounded),
                      title: const Text('Connect New Sheet'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConnectNewSheet(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_comment_rounded),
                      title: const Text('Test'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 20),
                    child: Column(
                      children: [
                        Divider(
                          color: MyColor.appBarColor,
                        ),
                        const Text(
                          'Created by',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        const Text(
                          'Geeta Technical Hub',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),

      // child: ListView(
      //   children: [
      //     DrawerHeader(
      //       decoration: BoxDecoration(
      //         color: MyColor.buttonSplaceColor2,
      //         image: DecorationImage(
      //           image: const AssetImage(
      //             "assets/img/ghublogo.png",
      //           ),
      //           fit: BoxFit.cover,
      //           colorFilter: ColorFilter.mode(
      //               Colors.grey.withOpacity(0.1), BlendMode.dstATop),
      //         ),
      //       ),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: const [
      //           Text(
      //             'Geeta Technical Hub',
      //             style: TextStyle(
      //                 fontWeight: FontWeight.w600,
      //                 fontSize: 22,
      //                 color: Colors.white),
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //     ),
      //     ListTile(
      //       leading: const Icon(Icons.event_available_rounded),
      //       title: const Text('Connect New Sheet'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const ConnectNewSheet(),
      //           ),
      //         );
      //       },
      //     ),

      // Wrap(
      //   children: [
      //     GestureDetector(
      //       onTap: () async {
      //         const url = 'https://www.linkedin.com/in/praween-link/';
      //         _launchInBrawser(url);
      //       },
      //       child: Image.asset(
      //         'assets/img/facebook.png',
      //         height: 60,
      //         width: 60,
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () async {
      //         const url = 'https://www.linkedin.com/in/praween-link/';
      //         if (await canLaunch(url)) {
      //           await launch(url);
      //         }
      //       },
      //       child: Image.asset(
      //         'assets/img/linkedin.png',
      //         height: 60,
      //         width: 60,
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () async {
      //         const url = 'https://www.linkedin.com/in/praween-link/';
      //         if (await canLaunch(url)) {
      //           await launch(url);
      //         }
      //       },
      //       child: Image.asset(
      //         'assets/img/instagram.png',
      //         height: 60,
      //         width: 60,
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () async {
      //         const url = 'https://www.linkedin.com/in/praween-link/';
      //         if (await canLaunch(url)) {
      //           await launch(url);
      //         }
      //       },
      //       child: Image.asset(
      //         'assets/img/twitter.png',
      //         height: 60,
      //         width: 60,
      //       ),
      //     ),
      //   ],
      // ),
      //     ],
      //   ),
    );
  }
}
