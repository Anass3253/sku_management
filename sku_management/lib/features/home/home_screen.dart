import 'package:flutter/material.dart';
import 'package:sku_management/features/barcode_integration/barcode_screen.dart';
import 'package:sku_management/features/branch_setup/branch_setup_screen.dart';
import 'package:sku_management/features/sku_management/sku_management_screen.dart';
import 'package:sku_management/features/sku_setup/sku_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Inventory Management',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Manage your inventory with ease',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const BranchSetupScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 100),
                ),
              );
            },
          ),
          Divider(thickness: 2),
          ListTile(
            title: const Text(
              'SKU Creation',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Create SKUs',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const SkuSetupScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 100),
                ),
              );
            },
          ),
          Divider(thickness: 2),
          ListTile(
            title: const Text(
              'SKU Management',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Manage your SKUs',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const SkuManagementScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 100),
                ),
              );
            },
          ),
          Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Barcode/Qr Code Generation',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Generate barcodes and QR codes',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const BarcodeScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 100),
                ),
              );
            },
          ),
          Divider(thickness: 2),
        ],
      ),
    );
  }
}
