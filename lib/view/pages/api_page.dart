import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/cubit/text_controller.dart';
import 'package:recipe_hub/view/components/clear_button.dart';
import 'package:recipe_hub/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = 'https://api.edamam.com/api/recipes/v2';

class ApiPage extends StatelessWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final prefs = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Recipe Hub',
                      style: TextStyle(fontSize: 20),
                    ),
                    BlocProvider<TextConCubit>(
                      create: (context) =>
                          TextConCubit(textController: controller1),
                      child: Builder(
                        builder: (context) {
                          final controller =
                              context.read<TextConCubit>().controller;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                suffixIcon: ClearButton(controller: controller),
                                border: const OutlineInputBorder(),
                                labelText: 'Edamam Recipe API key',
                                filled: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    BlocProvider<TextConCubit>(
                      create: (context) =>
                          TextConCubit(textController: controller2),
                      child: Builder(
                        builder: (context) {
                          final controller =
                              context.read<TextConCubit>().controller;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                suffixIcon: ClearButton(controller: controller),
                                border: const OutlineInputBorder(),
                                labelText: 'Edamam Recipe App ID',
                                filled: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(
                          'https://api.edamam.com/api/recipes/v2?type=public&app_id=${controller2.text}&app_key=${controller1.text}',
                        );
                        final response = await http.get(uri);
                        if (response.statusCode == 200) {
                          await prefs!.setString('API_KEY', controller1.text);
                          await prefs.setString('APP_ID', controller2.text);
                          await prefs.setBool('init', true);
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }
                        } else {
                          await prefs!.setBool('init', false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid API key / App ID'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Done'),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
