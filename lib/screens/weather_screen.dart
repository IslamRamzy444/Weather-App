import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({super.key, required this.cityName});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = "459ae18482054accae7185247241511";
  Future<Map> getWeather() async {
    Uri url = Uri.https("api.weatherapi.com", "v1/current.json",
        {"key": apiKey, "q": widget.cityName, "aqi": "yes"});
    var response = await http.get(url);
    Map weather = jsonDecode(response.body);
    return weather;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[900],
          foregroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            widget.cityName,
            style: const TextStyle(color: Colors.amber, fontSize: 30),
          ),
        ),
        body: FutureBuilder(
          future: getWeather(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: snapshot.data!["current"]["is_day"] == 1
                    ? Colors.cyan[300]
                    : Colors.black87,
                child: Center(
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!["location"]["name"],
                            style: snapshot.data!["current"]["is_day"] == 1
                                ? TextStyle(
                                    color: Colors.brown[800], fontSize: 18)
                                : const TextStyle(
                                    color: Colors.amber, fontSize: 18),
                          ),
                          Text(snapshot.data!["location"]["country"],
                              style: snapshot.data!["current"]["is_day"] == 1
                                  ? TextStyle(
                                      color: Colors.brown[800], fontSize: 16)
                                  : const TextStyle(
                                      color: Colors.amber, fontSize: 16)),
                          SizedBox(
                            height: 300,
                            child: Image.network(
                              "https:" +
                                  snapshot.data!["current"]["condition"]
                                      ["icon"],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                              "Temperature: ${snapshot.data!["current"]["temp_c"]} C",
                              style: snapshot.data!["current"]["is_day"] == 1
                                  ? TextStyle(
                                      color: Colors.brown[800], fontSize: 16)
                                  : const TextStyle(
                                      color: Colors.amber, fontSize: 16)),
                          Text(snapshot.data!["current"]["condition"]["text"],
                              style: snapshot.data!["current"]["is_day"] == 1
                                  ? TextStyle(
                                      color: Colors.brown[800], fontSize: 16)
                                  : const TextStyle(
                                      color: Colors.amber, fontSize: 16)),
                          Text(
                              "Current time: ${snapshot.data!["location"]["localtime"]}",
                              style: snapshot.data!["current"]["is_day"] == 1
                                  ? TextStyle(
                                      color: Colors.brown[800], fontSize: 16)
                                  : const TextStyle(
                                      color: Colors.amber, fontSize: 16))
                        ],
                      ),
                      Container(
                        color: Colors.grey[600],
                        height: 200,
                        margin: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "UV: ${snapshot.data!["current"]["uv"]}",
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp
                                  ),
                                ),
                                Text(
                                  "Feels like: ${snapshot.data!["current"]["feelslike_c"]} C",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                ),
                                Text(
                                  "Humidity: ${snapshot.data!["current"]["humidity"]} %",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Visibility: ${snapshot.data!["current"]["vis_km"]} Km",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                ),
                                Text(
                                  "Wind direction: ${snapshot.data!["current"]["wind_dir"]}",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                ),
                                Text(
                                  "Wind speed: ${snapshot.data!["current"]["wind_kph"]} Km/hr",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Air pressure: ${snapshot.data!["current"]["pressure_mb"]} Mpa",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                ),
                                Text(
                                  "Air Quality: ${snapshot.data!["current"]["air_quality"]["pm2_5"] >= 0 && snapshot.data!["current"]["air_quality"]["pm2_5"] <= 9 ? ((50 - 0) / (9 - 0) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 0) + 0).toStringAsFixed(0) : snapshot.data!["current"]["air_quality"]["pm2_5"] >= 9.1 && snapshot.data!["current"]["air_quality"]["pm2_5"] <= 35.4 ? ((100 - 51) / (35.4 - 9.1) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 9.1) + 51).toStringAsFixed(0) : snapshot.data!["current"]["air_quality"]["pm2_5"] >= 35.5 && snapshot.data!["current"]["air_quality"]["pm2_5"] <= 55.4 ? ((150 - 101) / (55.4 - 35.5) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 35.5) + 101).toStringAsFixed(0) : snapshot.data!["current"]["air_quality"]["pm2_5"] >= 55.5 && snapshot.data!["current"]["air_quality"]["pm2_5"] <= 125.4 ? ((200 - 151) / (125.4 - 55.5) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 55.5) + 151).toStringAsFixed(0) : snapshot.data!["current"]["air_quality"]["pm2_5"] >= 125.5 && snapshot.data!["current"]["air_quality"]["pm2_5"] <= 225.4 ? ((300 - 201) / (225.4 - 125.5) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 125.5) + 201).toStringAsFixed(0) : ((500 - 301) / (325.4 - 225.5) * (snapshot.data!["current"]["air_quality"]["pm2_5"] - 225.5) + 301).toStringAsFixed(0)}",
                                  style:  TextStyle(color: Colors.white,fontSize: 13.sp),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error!",
                  style: TextStyle(color: Colors.brown[800]),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
      },
    );
  }
}
