import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = context.read<DatabaseService>();
    final stats = databaseService.getStatistics();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total documents
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.folder,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${stats['total']}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'إجمالي الوثائق',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Status statistics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حسب الحالة',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(
                    context,
                    'جديد',
                    stats['new']!,
                    Colors.blue,
                    Icons.fiber_new,
                  ),
                  _buildStatRow(
                    context,
                    'تحت المراجعة',
                    stats['review']!,
                    Colors.orange,
                    Icons.rate_review,
                  ),
                  _buildStatRow(
                    context,
                    'مكتمل',
                    stats['completed']!,
                    Colors.green,
                    Icons.check_circle,
                  ),
                  _buildStatRow(
                    context,
                    'مؤرشف',
                    stats['archived']!,
                    Colors.grey,
                    Icons.archive,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Favorites
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              title: const Text('المفضلة'),
              trailing: Text(
                '${stats['favorites']}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    int count,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
