import 'package:flutter/material.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key,required this.setIsDarkMode, required this.isDark});
  final  void Function() setIsDarkMode;
  final isDark;

  @override
  State<MyDrawer> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  
  @override
  Widget build(BuildContext context) {
   
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(child: Column(children: [
              Icon(Icons.dining,size: 38, color: Theme.of(context).colorScheme.onPrimary,)
              ,Text(
               "Food Preparation Steps",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
            ],) ,) ,
          ),
          _buildListTile(
            context,
           widget.isDark ? Icons.sunny : Icons.dark_mode,
            "Night Mode",
            widget.setIsDarkMode,
          ),
        ],
      ),
    );
  }
}

_buildListTile(ctx, IconData icon, String text, void Function() onTap) {
  return ListTile(
    leading: Icon(icon, size: 17, color: Theme.of(ctx).colorScheme.onSurface),
    title: Text(
      text,
      style: Theme.of(ctx).textTheme.titleSmall!.copyWith(
        color: Theme.of(ctx).colorScheme.onSurface,
        fontSize: 17,
      ),
    ),
    onTap: (){
      onTap();
    },
  );
}
