import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/ui/task_model/task_model.dart';
import 'package:third_flutter_project/ui/task_type_model/task_type_model.dart';

import 'ui/Task_List/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final MaterialColor primarySwatchColor = const MaterialColor(
    0xFFFF831B,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF831B),
      600: Color(0xFFE65100),
      700: Color(0xFFD84315),
      800: Color(0xFFBF360C),
      900: Color(0xFF3E2723),
    },
  );
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: TasksModel()..isLoading,
      child: ScopedModel<TasksTypeModel>(
        model: TasksTypeModel()..isLoading,
        child: MaterialApp(
          title: "Tasks",
          theme: ThemeData(
            primarySwatch: primarySwatchColor,
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const TaskListPage(),
        ),
      ),
    );
  }
}
