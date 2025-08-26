import 'package:flutter/material.dart';

import 'main.dart';

class MamlakaApp extends StatefulWidget {
  const MamlakaApp({super.key});

  @override
  State<MamlakaApp> createState() => _MamlakaAppState();
}

class _MamlakaAppState extends State<MamlakaApp> {
  int currentIndex = 0;

  @override
  void didChangeDependencies() async {
    if (currentIndex == 0) {
      // await initNotification();
      currentIndex++;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return appStartScreen;
  }
}
