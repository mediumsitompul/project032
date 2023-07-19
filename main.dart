import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Get Address From Google Map API")),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double latitude = -6.252300;
  double longitude = 106.847336;

  String address = "";

  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";
    Response response = await dio.get(apiurl);

    if (response.statusCode == 200) {
      Map data = response.data;
      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          Map firstresult = data["results"][0];
          address = firstresult["formatted_address"];
          print('address');
          print(address);
          setState(() {});
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

  @override
  void initState() {
    convertToAddress(
        latitude, longitude, googleApikey); //call convert to address
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Latitude: $latitude",
              style: const TextStyle(fontSize: 25),
            ),
            Text("Longitude: $longitude\n",
                style: const TextStyle(fontSize: 25)),
            Text(
              "Address LatLng (Report by Google):\n$address",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
