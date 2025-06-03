import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_preparation/data/recipes.dart';
import 'package:food_preparation/pages/recipe_card.dart';
import 'package:food_preparation/util/My_Drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.setIsDarkMode,
  });

  final isDarkMode;

  final void Function() setIsDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cooking Fun',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
      ),
      drawer: MyDrawer(setIsDarkMode: setIsDarkMode, isDark: isDarkMode),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Choose a Recipe',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  var recipe = recipes[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: Duration(milliseconds: 400),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(child: RecipeCard(recipe: recipe)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
