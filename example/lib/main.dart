import 'package:flutter/material.dart';
import 'package:onboarding_sdk/onboarding_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TourController _tourController;
  final GlobalKey _keyOne = GlobalKey();
  final GlobalKey _keyTwo = GlobalKey();
  final GlobalKey _keyThree = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initTour();
  }

  Future<void> _initTour() async {
    await TourPersistenceService.init(); // Initialize persistence service
    _tourController = TourController(
      tourId: 'my_first_tour',
      steps: [
        TourStep(
          key: _keyOne,
          title: 'Welcome!',
          description: 'This is the first step of your tour.',
        ),
        TourStep(
          key: _keyTwo,
          title: 'Second Step',
          description: 'This is the second step, highlighting another widget.',
        ),
        TourStep(
          key: _keyThree,
          title: 'Final Step',
          description: 'This is the last step of the tour.',
        ),
      ],
      onTourComplete: () {
        print('Tour completed!');
      },
      onTourSkipped: () {
        print('Tour skipped!');
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tourController.startTourIfNecessary(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Feature Tour Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                key: _keyOne,
                onPressed: () {},
                child: const Text('Button One'),
              ),
              const SizedBox(height: 50),
              Text(
                'Some other content',
                key: _keyTwo,
              ),
              const SizedBox(height: 50),
              FloatingActionButton(
                key: _keyThree,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await TourPersistenceService.clearTourCompletion(
                      'my_first_tour');
                  print('Tour completion data cleared for my_first_tour');
                },
                child: const Text('Clear Tour Completion Data'),
              ),
              ElevatedButton(
                onPressed: () {
                  _tourController.startTourIfNecessary(context);
                },
                child: const Text('Start Tour Manually'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
