import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/global_variable.dart';

class AlertDialogFilter extends StatefulWidget {
  AlertDialogFilter(
      {@required this.switchValueisSap,
      @required this.valueChangedisSap,
      @required this.switchValueisSigma,
      @required this.valueChangedisSigma,
      @required this.switchValueisUST02,
      @required this.valueChangedisUST02});

  final bool switchValueisSap;
  final ValueChanged valueChangedisSap;

  final bool switchValueisSigma;
  final ValueChanged valueChangedisSigma;

  final bool switchValueisUST02;
  final ValueChanged valueChangedisUST02;

  @override
  _AlertDialogFilter createState() => _AlertDialogFilter();
}

class _AlertDialogFilter extends State<AlertDialogFilter> {
  bool _switchValueSap;
  bool _switchValueSigma;
  bool _switchValueUST02;

  @override
  void initState() {
    _switchValueSap = widget.switchValueisSap;
    _switchValueSigma = widget.switchValueisSigma;
    _switchValueUST02 = widget.switchValueisUST02;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Selecteer databronnen"),
      titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height / 3 ,
        padding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
                title: const Text('SAP'),
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
                secondary: const Icon(Icons.tram)),
            SwitchListTile(
                title: const Text('SIGMA'),
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
                secondary: const Icon(Icons.tram)),
            SwitchListTile(
                title: const Text('UST02 meettrein'),
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
                secondary: const Icon(Icons.tram)),
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
    );
  }
}
