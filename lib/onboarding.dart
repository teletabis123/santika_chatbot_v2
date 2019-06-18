import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class OnBoardingPage extends StatefulWidget {
  final String title;
  OnBoardingPage({this.title});
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _slideIndex = 0;

  final List<String> images = [
    "assets/illustration.png",
    "assets/illustration2.png",
    "assets/illustration3.png"
  ];

  final List<String> text0 = [
    "Welcome to MySantika Chatbot",
    "Enjoy easy hotel booking experience..",
    "Through our Newest Artificial Intelligence"
  ];

  final List<String> text1 = [
    "an App for hotel booking, Q&A",
    "Find your best deals here",
    "Berscha Chatbot"
  ];

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {

    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
              return new Material(
                  color: Colors.grey,
                  elevation: 8.0,
                  textStyle: new TextStyle(color: Colors.white),
                  borderRadius: new BorderRadius.circular(12.0),
                  child: new Container(
                      alignment: Alignment.center,
                      color: Colors.white,//ini background colornya
                      child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              new ParallaxContainer(
                                child: new Text(
                                  text0[info.index],
                                  style: new TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 34.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                ),
                                position: info.position,
                                opacityFactor: .8,
                                translationFactor: 400.0,
                              ),
                              SizedBox(
                                height: 45.0,
                              ),
                              new ParallaxContainer(
                                child: new Image.asset(
                                  images[info.index],
                                  fit: BoxFit.contain,
                                  height: 175,
                                ),
                                position: info.position,
                                translationFactor: 400.0,
                              ),
                              SizedBox(
                                height: 45.0,
                              ),
                              new ParallaxContainer(
                                child: new Text(
                                  text1[info.index],
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 28.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                ),
                                position: info.position,
                                translationFactor: 300.0,
                              ),
                              SizedBox(
                                height: 55.0,
                              ),
                              (info.index == images.length - 1) ? FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/homepage');
                                },
                                child: Text('Get Started'),
                                color: Colors.green,
                              ) : Container()
                            ],
                          )
                      )
                  )
              );
            }
        ),
        itemCount: 3);

    return Scaffold(
      backgroundColor: Colors.grey,
      body: transformerPageView,
    );

  }
}