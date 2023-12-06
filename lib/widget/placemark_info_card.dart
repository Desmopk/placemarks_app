import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class PlacemarkInfoCard extends StatefulWidget {
  const PlacemarkInfoCard({super.key, required this.placemark});

  final Placemark placemark;

  @override
  State<PlacemarkInfoCard> createState() => _PlacemarkInfoCardState();
}

class _PlacemarkInfoCardState extends State<PlacemarkInfoCard> {
  int slice = 2;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: .25, color: Theme.of(context).colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubicEmphasized,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: placemarkTiles.getRange(0, slice).toList(),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.aspect_ratio_outlined),
                  onPressed: () {
                    setState(() => slice = slice == 2 ? 9 : 2);
                    debugPrint(slice.toString());
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  List<ListTile> get placemarkTiles => placemarkData.entries
      .map(
        (entry) => ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          subtitleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      )
      .toList();

  Map<String, String> get placemarkData => <String, String>{
        "Name": widget.placemark.name.toString(),
        "Street": widget.placemark.street.toString(),
        "Locality": widget.placemark.locality.toString(),
        "Sub Locality": widget.placemark.subLocality.toString(),
        "Administrative Area": widget.placemark.subLocality.toString(),
        "Sub Administrative Area":
            widget.placemark.subAdministrativeArea.toString(),
        "Throughfare": widget.placemark.thoroughfare.toString(),
        "Sub Throughfare": widget.placemark.subThoroughfare.toString(),
        "Country": widget.placemark.country.toString(),
      };
}
