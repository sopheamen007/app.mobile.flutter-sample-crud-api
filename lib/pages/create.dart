import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_api_v1/contants/base_api.dart';
import 'package:sample_api_v1/contants/util.dart';
import 'package:sample_api_v1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;
class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _controllerFullName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creation User"),
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
          createNewUser();
        }, child: Text("Done",style: TextStyle(color: white),))
      ],
    );
  }
  createNewUser() async {
    var fullname = _controllerFullName.text;
    var email = _controllerEmail.text;
    if(fullname.isNotEmpty && email.isNotEmpty){
      var url = BASE_API+"user_store";
      var bodyData = json.encode({
          "fullname" : fullname,
          "email" : email
      });
      var response = await http.post(url,headers: {
        "Content-Type" : "application/json",
        "Accept" : "application/json"
      },body: bodyData);
      if(response.statusCode == 200){
        var message = json.decode(response.body)['message'];
        showMessage(context,message);
        setState(() {
          _controllerFullName.text = "";
          _controllerEmail.text = "";
        });
      }else {
        var messageError = "Can not create new user!!";
        showMessage(context,messageError);
      }

    }
  }
}