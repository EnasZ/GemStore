// lib/feature/home/presentation/widgets/home_drawer.dart
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@email.com"),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white),
            decoration: BoxDecoration(color: Colors.black),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          // Add more list tiles as per your requirements
        ],
      ),
    );
  }
}
