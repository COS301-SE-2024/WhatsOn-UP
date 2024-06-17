import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchImageTile.dart';

class SearchTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        LikedCategory(),

      ],
    );
  }
}

class LikedCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: Column(
        children: [
          Center(
            child: Text(
              'Ideas for you',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.height / 400,
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return SearchImageTile();
              }),
        ],
      ),
    );
  }
}
