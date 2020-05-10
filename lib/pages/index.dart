import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sample_api_v1/contants/base_api.dart';
import 'package:sample_api_v1/pages/create.dart';
import 'package:sample_api_v1/pages/edit.dart';
import 'package:sample_api_v1/theme/theme_colors.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }
  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = BASE_API+"users";
    var response = await http.get(url);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listing Users"),
        actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUser()));
          }, child: Icon(Icons.add,color: white,))
        ],
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    if(isLoading || users.length == 0){
      return Center(child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary)
      ));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context,index){
      return cardItem(users[index]);
    });
  }
  Widget cardItem(item){
    var fullname = item['fullname'];
    var email = item['email'];
    return Card(
          child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Colors.white,
            child: ListTile(
              title: Text(fullname),
              subtitle: Text(email),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blueAccent,
              icon: Icons.edit,
              onTap: () => editUser(item),
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => showDeleteAlert(context,item),
            ),
          ],
        ),
    );
  }
  editUser(item){
    var userId = item['id'].toString();
    var fullname = item['fullname'].toString();
    var email = item['email'].toString();
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser(userId: userId,fullName: fullname,email: email,)));
  }
  deleteUser(userId) async {
    var url = BASE_API+"user_delete/$userId";
    var response = await http.post(url,headers: {
      "Content-Type" : "application/json",
      "Accept" : "application/json"
    });
    if(response.statusCode == 200){
      this.fetchUser();
    }
  }
  showDeleteAlert(BuildContext context,item) {

  // set up the buttons
    Widget noButton = FlatButton(
      child: Text("No",style: TextStyle(color: primary),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes",style: TextStyle(color: primary)),
      onPressed:  () {
        Navigator.pop(context);
       
        deleteUser(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}