import 'package:flutter/material.dart';
import 'exercise1_core_widgets.dart';
import 'exercise2_input_controls.dart';
import 'exercise3_layout_demo.dart';
import 'exercise4_app_structure.dart';
import 'exercise5_ui_fixes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter UI Fundamentals',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {'title': 'Exercise 1 – Core Widgets Demo', 'screen': const CoreWidgetsDemo()},
      {'title': 'Exercise 2 – Input Controls Demo', 'screen': const InputControlsDemo()},
      {'title': 'Exercise 3 – Layout Demo', 'screen': const LayoutDemo()},
      {'title': 'Exercise 4 – App Structure & Theme', 'screen': const AppStructureDemo()},
      {'title': 'Exercise 5 – Common UI Fixes', 'screen': const CommonUiFixesDemo()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundamentals'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: Colors.purple.shade50.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                exercises[index]['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => exercises[index]['screen'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}