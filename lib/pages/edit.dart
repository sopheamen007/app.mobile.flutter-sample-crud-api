import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_api_v1/contants/base_api.dart';
import 'package:sample_api_v1/contants/util.dart';
import 'package:sample_api_v1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;
class EditUser extends StatefulWidget {
  String userId;
  String fullName;
  String email;
  EditUser({this.userId,this.fullName,this.email});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _controllerFullName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  String userId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      userId = widget.userId;
     _controllerFullName.text = widget.fullName;
     _controllerEmail.text = widget.email;
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edition User"),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        SizedBox(height: 30,),
        TextField(
          controller: _controllerFullName,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "FullName",
          ),
        ),
        SizedBox(height: 30,),
        TextField(
          controller: _controllerEmail,
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Email",
          ),
        ),
        SizedBox(height: 40,),
        FlatButton(
        color: primary,
        onPressed: (){
          editUser();
        }, child: Text("Done",style: TextStyle(color: white),))
      ],
    );
  }
  editUser() async {

    var fullName = _controllerFullName.text;
    var email = _controllerEmail.text;
    if(fullName.isNotEmpty && email.isNotEmpty){
      var url = BASE_API+"user_update/$userId";
      var bodyData = json.encode({
        "fullname" : fullName,
        "email" : email
      });
      var response = await http.post(url,headers: {
        "Content-Type" : "application/json",
        "Accept" : "application/json"
      },body: bodyData);
      if(response.statusCode == 200){
        var messageSuccess = json.decode(response.body)['message'];
        showMessage(context,messageSuccess);
      }else {
         var messageError = "Can not update this user!!";
        showMessage(context,messageError);
      }
    }
  }
}