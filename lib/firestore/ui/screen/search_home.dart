import 'package:flutter/material.dart';

class SearchHomeScreen extends StatelessWidget {
  const SearchHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = new TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/back.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.6),
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    hintText: 'Search Podcast',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
          ),

          // Container(
          //   width: double.infinity,
          //   height: 50,
          //   decoration: BoxDecoration(
          //       color: Color(0xFFe9eaec),
          //       borderRadius: BorderRadius.circular(15)),
          //   child: TextField(
          //     cursorColor: Color(0xFF000000),
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //         prefixIcon: Icon(
          //           Icons.search,
          //           color: Color(0xFF000000).withOpacity(0.5),
          //         ),
          //         hintText: "Search",
          //         border: InputBorder.none),
          //   ),
          // ),
        ),
      ),
    );
  }
}
