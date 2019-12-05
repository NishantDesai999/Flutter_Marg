import 'package:flutter/material.dart';
import 'dart:io';
import 'page_notification.dart';
import 'page_input_form.dart';
import '../models/model_complaint.dart';
import '../db/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
DBProvider dbProvider=DBProvider.dbProviderInstance;
  String text = '';
  List<ComplaintModel> complaints = [];
  TextStyle textStyle = TextStyle(fontSize: 20, color: Colors.white);

void _addGrievanceToList(ComplaintModel model) {
  print("addGrievanceToList called");
  setState(() {
    complaints.add(model);
  });
  print("-----complaints size="+ complaints.length.toString());
}


@override
  void initState(){
    print(dbProvider);
    dbProvider.getAllComplaints.then((List<ComplaintModel> complaintsFromDB){
      if(complaintsFromDB!=null&&complaintsFromDB.length>0)
      setState(() {
        complaints=complaintsFromDB;
        });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:
          AppBar(title: text.length == 0 ? Text("MargSahayak") : Text("$text")),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications,
                size: 25,
              ),
              color: Theme.of(context).iconTheme.color,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NotificationPage()))),
          IconButton(
              icon: Icon(Icons.list),
              color: Colors.blue,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          child: Wrap(
                        children: <Widget>[
                          ListTile(
                            title: Text("Contact Us"),
                            leading: Icon(Icons.contact_mail),
                            onTap: () {},
                          ),
                          ListTile(
                            title: Text("Help"),
                            leading: Icon(Icons.help_outline),
                            onTap: () {},
                          ),
                          ListTile(
                            title: Text("Logout"),
                            leading: Icon(Icons.power_settings_new),
                            onTap: () {},
                          )
                        ],
                      ));
                    });
              })
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        onPressed: () {
          print("Add complaint called");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      InputFormPage(_addGrievanceToList)));
        },
        icon: Icon(Icons.add),
        label: Text("Add Complaint"),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(DateTime.now().toIso8601String()),
                child: Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Container(
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Text(
                          complaints[index].description,
                          style: textStyle,
                        ),
                        Text(
                          complaints[index].grievanceType,
                          style: textStyle,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        shape: BoxShape.rectangle,
                        color: Color(0xff7c94b6),
                        image: DecorationImage(
                            image: FileImage(File.fromUri(
                                Uri.parse(complaints[index].imageURL))),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop))),

//
                  ),
                ));
          },
          itemCount: complaints.length),
    );
  }
}
