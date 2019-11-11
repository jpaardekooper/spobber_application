import 'package:flutter/material.dart';

class FavoriteLocationDropDown extends StatefulWidget {
  FavoriteLocationDropDown({Key key}) : super(key: key);
  static String currentImage;

  @override
  createState() => FavoriteLocationDropDownState();
}

class FavoriteLocationDropDownState extends State<FavoriteLocationDropDown> {
  final Map<String, String> favoriteLocationImage = {
    "House": "assets/images/house.png",
    "Store": "assets/images/store.png",
    "Hotel": "assets/images/hotel.png",
    "School": "assets/images/school.png",
    "Bank": "assets/images/bank.png",
    "Hospital": "assets/images/hospital.png",
  };
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    FavoriteLocationDropDown.currentImage = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String imageKey in favoriteLocationImage.keys) {
      items.add(new DropdownMenuItem(
        value: favoriteLocationImage[imageKey],
        child: Wrap(
          children: <Widget>[
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.white,
              child: Image.asset( favoriteLocationImage[imageKey] ),
            ),
            Container(
              padding: new EdgeInsets.only( top: 10.0, left: 4.0 ),
              child: Text( "$imageKey" ),
            ),
          ],
        ),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(12.0),
      // Ensure the desired width on different devices
      width: MediaQuery.of( context ).size.width / 2.5,
      //dropDown Background Color
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: new Center(
          child: new Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //new Container(),
          DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: FavoriteLocationDropDown.currentImage,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
              iconSize: 30.0,
            ),
          )
        ],
      )),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      FavoriteLocationDropDown.currentImage = selectedCity;
    });
  }
}
