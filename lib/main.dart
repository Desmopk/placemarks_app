import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:placemarks/api/location_api.dart';
import 'package:placemarks/widget/placemark_info_card.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placemarks App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade100, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Found Placemarks'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: const Color.fromARGB(0, 202, 185, 185),
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FutureProvider<List<Placemark>?>(
            initialData: null,
            create: (context) async {
              List<Placemark> placemarks =
                  await LocationApi.determinePlacemarks();
              return placemarks;
            },
            builder: (BuildContext context, Widget? child) {
              List<Placemark>? placemarks = context.watch<List<Placemark>?>();
              return AnimatedCrossFade(
                  firstChild: child!,
                  secondChild: placemarks != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: placemarks.length,
                          itemBuilder: (context, index) {
                            Placemark placemark = placemarks[index];
                            return PlacemarkInfoCard(
                              placemark: placemark,
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                  crossFadeState: placemarks != null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250));
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Loading your location details",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8.0),
                  SizedBox.square(
                    dimension: 36,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
