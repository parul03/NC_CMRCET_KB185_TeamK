import 'package:flutter/material.dart';

import 'models/models.dart';

class Remark extends StatefulWidget {
  @override
  _RemarkState createState() => _RemarkState();
}

class _RemarkState extends State<Remark> {
  String value;
  @override
  void initState() {
    value = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Your Remarks"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  onChanged: (value) {
                    this.value = value;
                    setState(() {});
                  },
                  maxLines: 50,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ),
          value.length != 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: () {
                      GlobalUser.key.update({"notes": value});
                      GlobalUser.remark = true;
                      remarks = value;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
