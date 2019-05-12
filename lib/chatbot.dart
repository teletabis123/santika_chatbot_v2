import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:santika_chatbot_v2/ChatLog.dart';
import 'package:santika_chatbot_v2/aboutapp.dart';
import 'dart:async';
import 'dart:convert';

import 'package:santika_chatbot_v2/database.dart';
import 'package:santika_chatbot_v2/main.dart';

void main() => runApp(new ChatBot());

class ChatBot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //'/' : (context) => SplashScreenPage(),
        '/homepage' : (context) => MyApp(),
        '/chat' : (context) => ChatBot(),
        '/about' : (context) => AboutApp(),
      },
      title: 'My Santika Helper',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  @override
  State createState() => new ChatScreenState();
}

Future<List<ChatLog>> fetchChatLogFromDB() async{
  var dbHelper = DBHelper();
  List<ChatLog> chatLogs = await dbHelper.getMessage();
  return chatLogs;
}

class ChatScreenState extends State<ChatScreen>{
  final TextEditingController _textController = new TextEditingController();

  final List<ChatMessage> _message = <ChatMessage>[];

  bool initialized = false;

  void _botStartChat() async {
    String url = "https://aiml-server-heroku.herokuapp.com/hai";
    var res = await http.get(Uri.encodeFull(url), headers: {"Authentication": "Bearer329e2f262b9e03c89379284ca9735332fb151575"});
    setState(() {
      var resBody = json.decode(res.body);
      int ul = resBody['ul'];
      ChatMessage messageResponse;
      List<int> li, footer;
      List<String> message = new List<String>();
      List<dynamic> messageChild = new List<dynamic>();
      List<String> messageFooter = new List<String>();
      li = new List<int>();
      footer = new List<int>();
      String mResponse = "";

      for(int i=0; i<=ul; i++){
        li.add(resBody['li'][i][i.toString()]);
        footer.add(resBody['footer'][i][i.toString()]);
      }

      for(int i=0; i<=li[ul]; i++){
        message.add(resBody["message"][ul][ul.toString()][i][i.toString()]);
        mResponse += (i>0 && i<=li[ul]? "  - " : "") + message[i] + (i != li[ul] ? "\n" : "");
      }

      messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
      if(messageFooter[0] != ""){
        mResponse += "\n\n" + messageFooter[0];
      }

      messageResponse = new ChatMessage(text: mResponse, who: 1,);
      _saveToDB(1, mResponse);
      _message.insert(0, messageResponse);
    });
  }

  void _getInitData() async{
    _botStartChat();
    List<ChatLog> chatLog = await fetchChatLogFromDB();
    print("Print in State: " + chatLog.length.toString());
    int length = chatLog.length;
    print(chatLog);
    if(length > 0){
      for(int i=0; i<length; i++){
        ChatMessage message = new ChatMessage(text: chatLog[i].message, who: chatLog[i].who,);
        setState(() {
          _message.insert(0, message);
        });
      }
    }
  }

  Future<bool> _backButtonPressed(){
    print(initialized ? "Initialized" : "Not initialized");
    initialized = false;
    //Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    if(!initialized){
      _getInitData();
      initialized = true;
    }

    return WillPopScope(
      //onWillPop: _baqckButtonPressed,
      child: new Scaffold(
        appBar: new AppBar(title: new Text("My Santika Chatroom"),),
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _message[index],
                itemCount: _message.length,
              ),
            ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(){
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              //margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
                // What to do after send icon is pressed
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleSubmitted(String text){
    _textController.clear();

    ChatMessage message = new ChatMessage(text: text, who: 0,);
    _saveToDB(0, text);

    ChatMessage messageResponse;

    String url = "https://aiml-server-heroku.herokuapp.com/";

    String mResponse = "";
    String mResFooter = "";
    Future getAndParse(String param) async {
      List<dynamic> response = new List();
      url += param;
      print("Text        : " + text);
      print("Url         : " + url);
      print("Encoded Url : " + Uri.encodeFull(url));
      var res = await http.get(Uri.encodeFull(url), headers: {"Authentication": "Bearer329e2f262b9e03c89379284ca9735332fb151575"});

      print("Done waiting!");

      setState(() {
        var resBody = json.decode(res.body);
        print(resBody);

        print("Reformatting json result");


        int ul = resBody['ul'];
        print("ul = " + ul.toString());

        List<int> li, footer;
        List<String> message = new List<String>();
        List<dynamic> messageChild = new List<dynamic>();
        List<String> messageFooter = new List<String>();
        li = new List<int>();
        footer = new List<int>();

        print("getting ul value: " + ul.toString());

        for(int i=0; i<=ul; i++){
          li.add(resBody['li'][i][i.toString()]);
          footer.add(resBody['footer'][i][i.toString()]);
        }

        if(ul == 0){
          print(resBody["message"]);
          message.add(resBody["message"][ul][ul.toString()]);
          messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
          print("Message: " + message[ul]);

          mResponse += message[ul];

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);

          if(messageFooter[ul] != ""){
            mResFooter += "\n" + messageFooter[ul];
          }
        }
        else if(ul == 1){
          print("ul = 1");
          print("li[0] = " + li[0].toString());
          for(int i=0; i<=li[ul]; i++){
            message.add(resBody["message"][ul][ul.toString()][i][i.toString()]);
            mResponse += (i>0 && i<=li[ul]? "  - " : "") + message[i] + (i != li[ul] ? "\n" : "");
          }

          messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
          if(messageFooter[0] != ""){
            mResponse += "\n\n" + messageFooter[0];
          }

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);
        }
        else if(ul > 1){
          print(li[0]);
          int idx = 0;
          for(int i=0; i<=ul; i++){
            if(li[i] == 1) mResponse += resBody["message"][i][i.toString()] + "\n\n";
            else{
              //Main
              print(idx);
              messageChild.add(message);
              for(int j=0; j<=li[i]; j++){
                messageChild[idx].add(resBody["message"][i][i.toString()][j][j.toString()]);
                print("resBody[\"message\"][$i][\"$i\"][$j][\"$j\"]: " + resBody["message"][i][i.toString()][j][j.toString()]);
                mResponse += (j>0 && j<=li[i]? "  - " : "") + resBody["message"][i][i.toString()][j][j.toString()] + (i==ul && j==li[i]? "" : "\n") + (i!=ul && j==li[i]? "" : "");
              }

              //Footer
              messageFooter.add(resBody["m_footer"][i][i.toString()]);
              if(messageFooter[idx] != "") mResponse += (i!=ul? "" : "\n") + "\n" + messageFooter[idx] + (i!=ul? "\n\n" : "");
              else{
                mResponse += (i==ul ? "" : "\n");
              }
              idx++;
            }

          }

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);
        }

        //print(mResponse);
      });
    }

    setState(() {
      _message.insert(0, message);
      getAndParse(text);
    });
  }
}

const String _name = "User"; //harusnya nama kita disini
const String _botName = "Chatbot"; //nama bot nya

class ChatMessage extends StatelessWidget{

  ChatMessage({this.text, this.who});
  final String text;
  final int who;

  @override
  Widget build(BuildContext context) {
    final c_width = MediaQuery.of(context).size.width * (who == 0 ? 0.6 : 0.9);

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      //width: MediaQuery.of(context).size.width*0.5,
      child: new Row(
        textDirection: who == 0 ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: c_width,
            padding: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: who == 1 ? Colors.white : Colors.grey,
              borderRadius: new BorderRadius.all(Radius.circular(5.0)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //new Text(who == 1 ? _botName : _name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text, style: TextStyle(fontSize: 15.0),),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

void _saveToDB(int who, String message){
  var dbHelper = new DBHelper();

  dbHelper.saveChatLog(who, message, _makeTimestamp());

}

String _makeTimestamp(){
  String day = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  String hour = DateTime.now().hour.toString();
  String minute = DateTime.now().minute.toString();
  String second = DateTime.now().second.toString();

  print("Timestamp to be inserted to db: " + year.toString() + "-" + month.toString() + "-" + day.toString()
      + " " + hour.toString() + ":" + minute.toString() + ":" + second.toString());

  String timestamp = year + "-" + month + "-" + day + " " +
      hour + ":" + minute + ":" + second;

  return timestamp;
}

//Old Code to reformatting json
//if(text.contains("ketersediaan") || text.contains("pengecekan")){
//var resCek = json.decode(res.body);
//mResponse = resCek["message"];
//}
//else{
//response.add(resBody["ul"]); //index 0
//response.add(resBody["il"]); //index 1
//response.add(resBody["message"]);//index 2
//response.add(resBody["header"]);
//
//int index = 0;
//print(response[0] == null ? "No ul tag in json" : "This type is " + response[0].runtimeType.toString() + " with value of " + response[0].toString());
//print(response[1] == null ? "No il tag in json" : "This type is " + response[1].runtimeType.toString() + ".");
//print(response[1][0][index.toString()] == null ? "There is no \"0\" in tag il" : response[1][0]["0"]); //tag il "0"
//print(response[2][0][index.toString()] != "" ? "There is no \"1\" in tag il" : response[1][1]["1"]); //tag il "1"
//print(response[2].runtimeType.toString());
//print(response[2][0][index.toString()] == "" ? "Index 0 kosong" : response[2][0]["0"]); //message "0"
//
//int indexMessageStart = response[1][0]["0"];
//int indexMessageEnd = response[2][0]["0"] == "" ? response[1][1]["1"] : response[1][0]["0"]; //kalo message[0] berisi, dia jd sm ky il "0"
//
//print(indexMessageStart.toString());
//print(indexMessageEnd.toString());
//
//if(indexMessageStart == indexMessageEnd){
//mResponse = response[2][0]["0"];
//_saveToDB(1, mResponse, DateTime.now());
//}
//else{
//print(indexMessageStart.toString());
//print(indexMessageEnd.toString());
//mResponse += response[3] + "\n";
//int i;
//for(i = indexMessageStart; i<=indexMessageEnd; i++){
//mResponse += " - " + response[2][1]["1"][i][i.toString()] + (i != indexMessageEnd ? "\n" : "");
//}
//_saveToDB(1, mResponse, DateTime.now());
////mResponse = ""; //sementara
//}
//}
//
//messageResponse = new ChatMessage(text: mResponse, who: 1,);
//
//_message.insert(0, messageResponse);