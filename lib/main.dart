import 'package:flutter/material.dart';
import 'models/element_model.dart';
import 'services/api_service.dart';
import 'screens/portfolio_screen.dart';
import 'models/album_model.dart';
import 'models/tag_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirestoreService apiService = FirestoreService();

    return MaterialApp(
      title: 'Life Gallery App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Future.wait([
          apiService.getAlbums(),
          apiService.getTags(),
          apiService.getElements(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading data...');
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            print('Error stack trace: ${snapshot.stackTrace}');
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            print('No data received from API');
            return const Text('No data available');
          } else {
            try {
              print('Raw API Response - Albums: ${snapshot.data![0]}');
              print('Raw API Response - Tags: ${snapshot.data![1]}');

              final albums = snapshot.data![0] as List<dynamic>;
              final tags = snapshot.data![1] as List<dynamic>;
              final elements = snapshot.data![2] as List<dynamic>;

              print('Parsed Albums: $albums');
              print('Parsed Tags: $tags');

              final parsedElements = elements
                  .map((element) =>
                      ElementItem.fromMap(element as Map<String, dynamic>))
                  .toList();

              final parsedAlbums = albums
                  .map((album) => Album.fromMap(album as Map<String, dynamic>))
                  .toList();
              final parsedTags = tags
                  .map((tag) => Tag.fromMap(tag as Map<String, dynamic>))
                  .toList();

              print(
                  'Fetched ${parsedAlbums.length} albums and ${parsedTags.length} tags');
              return PortfolioScreen(
                  elements: parsedElements,
                  albums: parsedAlbums,
                  tags: parsedTags);
            } catch (e, stackTrace) {
              print('Error processing API response: $e');
              print('Stack trace: $stackTrace');
              return const Text('Error processing data');
            }
          }
        },
      ),
    );
  }
}
