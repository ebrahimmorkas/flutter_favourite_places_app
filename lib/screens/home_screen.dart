import 'package:chat_app/widgets/place_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/screens/new_place_screen.dart';
import 'package:chat_app/providers/place_provider.dart';
import 'package:chat_app/models/place.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(placeProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> placesList = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPlaceScreen(),
                    ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: placesList.isEmpty
          ? Center(child: Text("No places added"))
          : ListView.builder(
              itemBuilder: (context, index) {
                return PlaceListTile(place: placesList[index]);
              },
              itemCount: placesList.length,
            ),
    );
  }
}
