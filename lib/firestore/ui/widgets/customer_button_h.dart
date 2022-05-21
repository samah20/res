import 'package:flutter/material.dart';
import 'package:restaurants/firestore/data/router_helper.dart';

import 'package:restaurants/firestore/ui/screen/admin_home.dart';

class CustomerButtonHome extends StatelessWidget {
  const CustomerButtonHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        width: 360,
        height: 300,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Xiaomi Mijia",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    "\$1.5/hr",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Light Pavement e-Scooter",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                      child: Row(
                    children: [
                      Icon(
                        Icons.battery_full_rounded,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            "Power",
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Text(
                            "93%",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      child: Row(
                    children: [
                      Icon(
                        Icons.battery_full_rounded,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            "Power",
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Text(
                            "93%",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      margin: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage(
                              'assets/images/scooter1.jpeg',
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 100,
                      margin: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage(
                              'assets/images/scooter5.jpeg',
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  RouterHelper.routerHelper
                      .routingToSpecificWidgetWithPop(AdminHome());
                },
                label: Text(
                  'SHOW DETAILS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoNaskhArabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                    primary: Colors.orange),
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:restaurants/firestore/data/router_helper.dart';
// import 'package:restaurants/firestore/providers/app_provider.dart';

// import 'package:restaurants/firestore/ui/screen/details_home.dart';

// class CustomerButtonHome extends StatelessWidget {
//   CustomerButtonHome({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     int index;
//     return SingleChildScrollView(
//       child: Consumer<AppProvider>(builder: (context, provider, x) {
//         return SingleChildScrollView(
//           child: Container(
//             margin: EdgeInsets.all(10),
//             width: 360,
//             height: 300,
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         provider.allProducts[index].title,
//                         style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                       Spacer(),
//                       Text(
//                         provider.allProducts[index].price.toString(),
//                         // "\$ "provider.allProducts[index].price "/hr",
//                         style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       provider.allProducts[index].name,
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                           child: Row(
//                         children: [
//                           Icon(
//                             Icons.battery_full_rounded,
//                             color: Colors.white,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 "Power",
//                                 style: TextStyle(
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                               Text(
//                                 provider.allProducts[index].status,
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Container(
//                           child: Row(
//                         children: [
//                           Icon(
//                             Icons.location_city,
//                             color: Colors.white,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 "Addres",
//                                 style: TextStyle(
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                               Text(
//                                 provider.allProducts[index].location.addres,
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                     ],
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           height: 100,
//                           margin: EdgeInsets.all(10),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image(
//                                 image: NetworkImage(
//                                   provider.allProducts[index].photos[0],
//                                 ),
//                                 fit: BoxFit.cover),
//                           ),
//                         ),
//                         Container(
//                           width: 120,
//                           height: 100,
//                           margin: EdgeInsets.all(10),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image(
//                                 image: NetworkImage(
//                                   provider.allProducts[index].photos[1],
//                                 ),
//                                 fit: BoxFit.cover),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       RouterHelper.routerHelper
//                           .routingToSpecificWidgetWithPop(DetailsHome());
//                     },
//                     label: Text(
//                       'SHOW DETAILS',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontFamily: 'NotoNaskhArabic',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 15, horizontal: 60),
//                         primary: Colors.orange),
//                     icon: Icon(
//                       Icons.arrow_forward,
//                       color: Colors.white,
//                       size: 24.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
