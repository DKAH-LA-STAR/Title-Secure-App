import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/stats_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            StatsCard(
              title: 'Total Users',
              value: '1,240',
              icon: Icons.people,
              color: Colors.blue,
            ),
            SizedBox(height: 12),
            StatsCard(
              title: 'Active Sessions',
              value: '86',
              icon: Icons.online_prediction,
              color: Colors.green,
            ),
            SizedBox(height: 12),
            StatsCard(
              title: 'Revenue',
              value: '\$12,450.50',
              icon: Icons.attach_money,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
