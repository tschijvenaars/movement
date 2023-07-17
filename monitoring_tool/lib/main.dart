import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/presentation/main_layout.dart';

import 'presentation/widgets/elements/custom_fab.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); //Initialize Providerscope for shared providers
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODiN Monitoring Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(), //Constructed custom floatin action button
      body: SafeArea(
        child: MainLayout(),
      ),
    );
  }
}
