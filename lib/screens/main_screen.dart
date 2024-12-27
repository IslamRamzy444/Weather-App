import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_25/screens/weather_screen.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';
// ignore: depend_on_referenced_packages
import 'package:swipe_refresh/swipe_refresh.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController pageController=TextEditingController();
  TextEditingController searchController=TextEditingController();
  final controller=StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream=>controller.stream;
  List cities=[];
  int currentPage=1;
  String searchText="";
  Future<void>getCities()async{
    Uri url=Uri.https(
      "api.thecompaniesapi.com","v2/locations/cities",
      {
        "search":searchText,
        "page":currentPage.toString()
      }
    );
    var response=await http.get(url);
    cities=jsonDecode(response.body)["cities"];
    setState(() {
      
    });
  }
  Future<void>showHints()async{
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Tips about the app") ,
          backgroundColor: Colors.amber,
          buttonPadding: EdgeInsets.all(5),
          elevation: 5,
          alignment: Alignment.topRight,
          content: Container(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text("- If the city you are searching for did not appear at first in the search list you may move a few times back to find it.",style: TextStyle(color: Colors.blue[900]),),
                  Text("- If no search list appeared on typing your city, you might press the first button or refresh the app by dragging the screen downwards and searching for your city again.",style: TextStyle(color: Colors.blue[900]),),
                  Text("- The above issues will occur if you navigate too  many pages in the app, so the optimal practice is to search for your city while you are standing on the first page.",style: TextStyle(color: Colors.blue[900]),),
                  Text("- Otherwise you might check the spelling of the city or the strength of your wifi network",style: TextStyle(color: Colors.blue[900]),),
                  Text("- You can move to any page by pressing on the number and typing the number of your page.",style: TextStyle(color: Colors.blue[900]))
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue[900]),
                foregroundColor: const WidgetStatePropertyAll(Colors.amber)
              ),
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text("Ok")
            )
          ],
        );
      },
      );
  }
  Future<void> pageNavigator()async{
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Page Navigator"),
          backgroundColor: Colors.amber,
          elevation: 5,
          buttonPadding: EdgeInsets.all(5),
          content: Container(
            height: 150,
            child: TextField(
              controller: pageController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Type the page number(in English)"
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue[900]),
                foregroundColor: const WidgetStatePropertyAll(Colors.amber)
              ),
              onPressed: () {
                if(int.parse(pageController.text)>=0 && int.parse(pageController.text)<=1000){
                  setState(() {
                    currentPage=int.parse(pageController.text);
                  });
                  getCities();
                  Navigator.pop(context);
                  pageController.text="";
                }else if (int.parse(pageController.text)<0 || int.parse(pageController.text)>1000 || pageController.text.isInt==false) {
                  Navigator.pop(context);
                  pageController.text="";
                }
              }, 
              child: const Text("Go")
            )
          ],
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        foregroundColor: Colors.amber,
        centerTitle: true,
        title: const Text("Weather Application",style: TextStyle(color: Colors.amber,fontSize: 30),),
        actions: [
          IconButton(
            onPressed: () {
              showHints();
            }, 
            icon: const Icon(Icons.question_mark_outlined)
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration:  const InputDecoration(
              filled: true,
              hintText: "Search for your city by typing its name"
            ),
            cursorColor: Colors.amber,
            onChanged: (value) {
              setState(() {
                searchText=value;
              });
              getCities();
            },
          ),
          Expanded(
            child: SwipeRefresh.builder(
              stateStream:_stream ,
              onRefresh: () {
                setState(() {
                  currentPage=1;
                  searchText="";
                  searchController.text="";
                });
                getCities();
                controller.sink.add(SwipeRefreshState.hidden);
              },
              padding: const EdgeInsets.all(8),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color.fromARGB(255, 36, 11, 105)),
                      borderRadius: BorderRadius.circular(150)
                    ),
                    color: Colors.amber,
                    child: ListTile(
                      textColor: Colors.blue[900],
                      title: Text(cities[index]["name"],style: const TextStyle(fontSize: 16),),
                      subtitle: Text(cities[index]["country"]["name"]),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherScreen(cityName: cities[index]["name"]+" "+cities[index]["country"]["name"]),));
                      },
                    ),
                  ),
                );
              },
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    currentPage=1;
                  });
                  getCities();
                }, 
                icon: const Icon(Icons.keyboard_double_arrow_left_outlined)
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentPage>1?currentPage--:currentPage=1;
                  });
                  getCities();
                }, 
                icon:  Icon(Icons.arrow_back,color: currentPage==1?Colors.blue:Colors.black)
              ),
              InkWell(
                onTap: () {
                  pageNavigator();
                },
                child: Text("Page $currentPage")
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentPage<1000?currentPage++:currentPage=1000;
                  });
                  getCities();
                }, 
                icon:  Icon(Icons.arrow_forward,color: currentPage==1000?Colors.blue:Colors.black)
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentPage=1000;
                  });
                  getCities();
                },
                 icon: const Icon(Icons.double_arrow)
              )
            ],
          )
        ],
      ),
    );
  }
}
