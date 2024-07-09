import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson73/controller/travels_controller.dart';
import 'package:lesson73/model/travel.dart';
import 'package:lesson73/services/location_service.dart';
import 'package:lesson73/screens/add_new_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _travelsController = TravelsController();
  String? cityName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    await LocationService.init();
    await LocationService.getCurrentLocation();
    if (LocationService.currentLocation != null) {
      double lat = LocationService.currentLocation!.latitude!;
      double lng = LocationService.currentLocation!.longitude!;
      cityName = await LocationService.getCityFromCoordinates(lat, lng);
      setState(() {});
    }
  }

  Future<void> _deleteTravel(String id) async {
    await _travelsController.deleteTravel(id);
  }

  Future<void> _editTravel(Travel travel) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (ctx) => NewLocationScreen(travel: travel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (ctx) => const NewLocationScreen()),
              );
            },
            icon: const Icon(
              Icons.add_location,
              size: 35,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text(
          "Travelling",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _travelsController.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No Travels"),
            );
          }
          final travels = snapshot.data!.docs;
          return GridView.builder(
            itemCount: travels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final travel = Travel.fromQuerySnapshot(
                travels[index],
              );
              return Card(
                elevation: 5,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(travel.imageUrl),
                        ),
                        Text(
                          travel.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          travel.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cityName ?? 'Fetching city...',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () => _editTravel(travel),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red ,
                              ),
                              onPressed: () => _deleteTravel(travel.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
