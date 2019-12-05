import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'dart:io';
import '../models/model_complaint.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:intl/intl.dart';
import '../db/db_provider.dart';

class InputFormPage extends StatefulWidget {
  Function _addGrievance;

  InputFormPage(this._addGrievance);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InputFormPageState();
  }
}

class _InputFormPageState extends State<InputFormPage> {
  bool allowWrite = false;
  List<String> _grievances = [
    "DAMAGED BRIDGE",
    "DAMAGED BRIDGE PARAPET",
    "BREACH ON ROAD",
    "DMAGED RAILING",
    "SHARP CURVE",
    "ACCIDENT PRONE ZONE",
    "DAMAGED STRUCTURES",
    "POT HOLES",
    "FALLEN TREE",
    "DEGRADED ROADS"
  ];
  String _currentGrievance;
  File choosenImage;
  String description;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DBProvider dbProvider=DBProvider.dbProviderInstance;
  int id=0;

  @override
  void initState() {
    description = "No Description";

    print("DbProvider------------->"+dbProvider.toString());
    List<ComplaintModel> complaintList;

   dbProvider.getAllComplaints.then((List<ComplaintModel> complaints){
   complaintList=complaints;
   if(complaintList==null){
     id=0;
   }else {
     id = (complaintList.last).id + 1;
   }
   print("----Value of  id ="+id.toString());
   requestWritePermission();
   });

   // TODO: implement initState
//    print("=========================Date ------------>"+DateTime.now().toIso8601String());
//    print("==================Formated Date=========="+DateFormat.yMMMd().format(DateTime.now()));
//    print("===================Formated date"+DateFormat("yyyyMMdd_hhmmss").format(DateTime.now()));
    super.initState();

  }

  void requestWritePermission() async {
    PermissionStatus permissionStatus =
        await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
    if (permissionStatus == PermissionStatus.authorized) {
      setState(() {
        allowWrite = true;
      });
    }
  }

  void _getImage(BuildContext context, ImageSource source) async {
    ImagePicker.pickImage(source: source, maxWidth: 300).then((File image) {
      setState(() {
        choosenImage = image;
      });
//      if(!allowWrite)
//        return;
//
      Navigator.pop(context);
    });
  }

  void _openCaptureImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.center,
//              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Pick An Image",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.black,
                  height: 5,
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.camera_enhance),
                  title: Text("From Camera"),
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.landscape),
                  title: Text("From Gallery"),
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  void _uploadData(BuildContext context){
    _formKey.currentState.save();
    _localFile.then((File file){
      file.writeAsBytesSync(choosenImage.readAsBytesSync(),flush: true);
      //print("choosen image path-------------->" + choosenImage.path);
      ComplaintModel cm=ComplaintModel(id,description, _currentGrievance,file.path);
      dbProvider.addItem(cm);
      widget._addGrievance(cm);
      Navigator.pop(context);
    });

    
  }

  Future<String> get _localPath async {
    String path= (await getExternalStorageDirectory()).path +
        "/Pictures/Flutter_MargSahayak/";
    if (!allowWrite) return null;
    if (!Directory(path).existsSync()) {
      new Directory((await getExternalStorageDirectory()).path +
              "/Pictures/Flutter_MargSahayak/")
          .create(recursive: true)
          .then((Directory directory) {
        print("directory-------------->" + directory.path.toString());
        path = directory.path;
      });
    }
    return path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path +"IMG_"+DateFormat("yyyyMMdd_hhmmss").format(DateTime.now())+".jpg");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Input Form")),
        body: Center(
          child: Card(
              margin: EdgeInsets.all(20),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 300, margin: EdgeInsets.all(5),
                      child: IconButton(
                          alignment: Alignment.bottomRight,
                          icon: Icon(
                            Icons.photo_camera,
                            size: 60,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _openCaptureImageBottomSheet(context);
                          }),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xff7c94b6),
                          image: DecorationImage(
                              image: choosenImage == null
                                  ? AssetImage('assets/demo.jpg')
                                  : FileImage(choosenImage),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop))),

//
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: DropdownButton(
                          value: _currentGrievance,
                          isExpanded: true,
                          items: List<DropdownMenuItem<String>>.generate(
                              _grievances.length,
                              (int index) => DropdownMenuItem(
                                    child: Text(_grievances[index]),
                                    value: _grievances[index],
                                  )),
                          hint: Text("Select a Grievance"),
                          onChanged: (String selectedGrievance) {
                            setState(() {
                              _currentGrievance = selectedGrievance;
                            });
                          }),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              hintText: "Description(Optional)",
                              labelText: "Add Some Description Here!"),
                          maxLines: 5,
                          onSaved: (String value) {
                            description = value;
                          },
                        )),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: RaisedButton(
                        onPressed: () {
                          _uploadData(context);
                        },
                        child: Text(
                          "Upload",
                          style: TextStyle(fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(20, 20)),
                            side:
                                BorderSide(width: 1, style: BorderStyle.none)),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
