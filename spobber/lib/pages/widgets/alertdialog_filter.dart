import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/global_variable.dart';

class AlertDialogFilter extends StatefulWidget {
  AlertDialogFilter(
      {@required this.switchValueisSap,
      @required this.valueChangedisSap,
      @required this.switchValueisSigma,
      @required this.valueChangedisSigma,
      @required this.switchValueisUST02,
      @required this.valueChangedisUST02,
      @required this.switchValueisSpobber,
      @required this.valueChangedisSpobber});

  final bool switchValueisSap;
  final ValueChanged valueChangedisSap;

  final bool switchValueisSigma;
  final ValueChanged valueChangedisSigma;

  final bool switchValueisUST02;
  final ValueChanged valueChangedisUST02;

  final bool switchValueisSpobber;
  final ValueChanged valueChangedisSpobber;

  @override
  _AlertDialogFilter createState() => _AlertDialogFilter();
}

class _AlertDialogFilter extends State<AlertDialogFilter> {
  bool _switchValueSap;
  bool _switchValueSigma;
  bool _switchValueUST02;
  bool _switchValueSpobber;

  @override
  void initState() {
    _switchValueSap = widget.switchValueisSap;
    _switchValueSigma = widget.switchValueisSigma;
    _switchValueUST02 = widget.switchValueisUST02;
    _switchValueSpobber = widget.switchValueisSpobber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        // decoration: BoxDecoration(
        //   // Box decoration takes a gradient
        //   gradient: LinearGradient(
        //     // Where the linear gradient begins and ends
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     // Add one stop for each color. Stops should increase from 0 to 1
        //     stops: [0.1, 0.5, 0.8, 0.9],
        //     colors: [
        //       // Colors are easy thanks to Flutter's Colors class.
        //       Color(0xfffff),
        //       Color(0xff0066C6),
        //       Color(0xff004990),
        //       Color(0xfffff),
        //     ],
        //   ),
        // ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AlertDialog(
          title: Text(
            "Selecteer databronnen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height / 3 ,
            padding:
                MediaQuery.of(context).viewInsets + const EdgeInsets.all(10.0),
            child: ListView(
              shrinkWrap: true,
              //   mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Divider(),
                SwitchListTile(
                    activeColor: Theme.of(context).accentColor,
                    title:  Text('SAP',  style: TextStyle(color: _switchValueSap ? Theme.of(context).accentColor : null),),
                    value: _switchValueSap,
                    onChanged: (bool value) {
                      setState(() {
                        _switchValueSap = value;
                        widget.valueChangedisSap(value);
                        if (value == true) {
                          setDataSource.add("SAP");
                        } else {
                          setDataSource.remove("SAP");
                        }
                      });
                    },
                    secondary: Icon(
                      Icons.tram, color: _switchValueSap ? Theme.of(context).accentColor : null
                    )),

                Divider(),

                SwitchListTile(
                    activeColor: Theme.of(context).accentColor,
                    title:  Text('SIGMA',  style: TextStyle(color: _switchValueSigma ? Theme.of(context).accentColor : null),),
                    value: _switchValueSigma,
                    onChanged: (bool value) {
                      setState(() {
                        _switchValueSigma = value;
                        widget.valueChangedisSigma(value);

                        if (value == true) {
                          setDataSource.add("SIGMA");
                        } else {
                          print("De value van SIGMA is $value");
                          setDataSource.remove("SIGMA");
                        }
                      });
                    },
                    secondary:  Icon(
                      Icons.tram, color: _switchValueSigma ? Theme.of(context).accentColor : null
                    ),),
                Divider(),
                SwitchListTile(
                 activeColor: Theme.of(context).accentColor,
                  title:  Text('UST02 meettrein',  style: TextStyle(color: _switchValueUST02 ? Theme.of(context).accentColor : null),),
                  value: _switchValueUST02,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValueUST02 = value;
                      widget.valueChangedisUST02(value);
                      if (value == true) {
                        setDataSource.add("UST02");
                      } else {
                        setDataSource.remove("UST02");
                      }
                    });
                  },
                  secondary: Icon(Icons.tram, color: _switchValueUST02 ? Theme.of(context).accentColor : null),
                ),
                Divider(),
                SwitchListTile(
               activeColor: Theme.of(context).accentColor,
                  title: Text('Spobber Applicatie', style: TextStyle(color: _switchValueSpobber ? Theme.of(context).accentColor : null)),
                  value: _switchValueSpobber,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValueSpobber = value;
                      widget.valueChangedisSpobber(value);
                      if (value == true) {
                        setDataSource.add("SPOBBER");
                      } else {
                        setDataSource.remove("SPOBBER");
                      }
                    });
                  },
                  secondary: Icon(Icons.tram, color: _switchValueSpobber ? Theme.of(context).accentColor : null),
                )
                // SwitchListTile(
                //     title: const Text('Videoschouwtrein'),
                //     value: isVideo,
                //     onChanged: (bool value) {
                //       setState(() {
                //         isVideo = value;
                //       });
                //     },
                //     secondary: const Icon(Icons.tram)),
              ],
            ),

            //  CupertinoSwitch(
            //     value: _switchValueVideo,
            //     onChanged: (bool value) {
            //       setState(() {
            // _switchValueVideo = value;
            // widget.valueChangedisVideo(value);
            //       });
            //     }),
          ),
        ),
      ),
    );
  }
}
