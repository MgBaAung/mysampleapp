import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Developed By",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("MgBa", style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 5,
                  ),
                  SelectableText("Gmail: Mgba@gmail.com")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
