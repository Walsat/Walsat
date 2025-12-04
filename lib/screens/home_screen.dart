import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import 'add_document_screen.dart';
import 'document_detail_screen.dart';
import 'search_screen.dart';
import 'statistics_screen.dart';
import 'ai_settings_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'all';
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    final databaseService = context.read<DatabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('أرشيف الوثائق'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              } else if (value == 'about') {
                _showAboutDialog();
              } else if (value == 'ai_settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AISettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('الإعدادات'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'ai_settings',
                child: Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('إعدادات AI'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8),
                    Text('حول التطبيق'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('الكل', 'all', _selectedFilter == 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('جديد', 'new', _selectedFilter == 'new'),
                const SizedBox(width: 8),
                _buildFilterChip('تحت المراجعة', 'review', _selectedFilter == 'review'),
                const SizedBox(width: 8),
                _buildFilterChip('مكتمل', 'completed', _selectedFilter == 'completed'),
                const SizedBox(width: 8),
                _buildFilterChip('مؤرشف', 'archived', _selectedFilter == 'archived'),
                const SizedBox(width: 8),
                _buildFilterChip('المفضلة', 'favorites', _selectedFilter == 'favorites'),
              ],
            ),
          ),

          // Type filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTypeChip('الكل', 'all', _selectedType == 'all'),
                const SizedBox(width: 8),
                _buildTypeChip('كتب الأراضي', 'land_registry', _selectedType == 'land_registry'),
                const SizedBox(width: 8),
                _buildTypeChip('وزارة الزراعة', 'agriculture_ministry', _selectedType == 'agriculture_ministry'),
                const SizedBox(width: 8),
                _buildTypeChip('المحافظ', 'governor_saladin', _selectedType == 'governor_saladin'),
                const SizedBox(width: 8),
                _buildTypeChip('مديرية زراعة', 'agriculture_directorate', _selectedType == 'agriculture_directorate'),
                const SizedBox(width: 8),
                _buildTypeChip('شعبة زراعة', 'agriculture_division', _selectedType == 'agriculture_division'),
                const SizedBox(width: 8),
                _buildTypeChip('أوامر مهمة', 'important_orders', _selectedType == 'important_orders'),
                const SizedBox(width: 8),
                _buildTypeChip('الشكوي', 'complaints', _selectedType == 'complaints'),
                const SizedBox(width: 8),
                _buildTypeChip('أخرى', 'other', _selectedType == 'other'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Documents list
          Expanded(
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(milliseconds: 500)),
              builder: (context, snapshot) {
                List<Document> documents = databaseService.getAllDocuments();

                // Apply filters
                if (_selectedFilter == 'favorites') {
                  documents = databaseService.getFavorites();
                } else if (_selectedFilter != 'all') {
                  documents = databaseService.filterByStatus(_selectedFilter);
                }

                // Apply type filter
                if (_selectedType != 'all') {
                  documents = documents.where((doc) => doc.type == _selectedType).toList();
                }

                // Sort by date (newest first)
                documents.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (documents.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return _buildDocumentCard(documents[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDocumentScreen(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة وثيقة'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildTypeChip(String label, String value, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.secondaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentDetailScreen(document: document),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Document icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDocumentIcon(document.type),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          document.typeDisplayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorite icon
                  if (document.isFavorite)
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              if (document.description.isNotEmpty)
                Text(
                  document.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Tags
              if (document.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: document.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 12),
              
              // Status and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(document.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      document.statusDisplayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(document.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 100,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد وثائق',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على الزر أدناه لإضافة وثيقة جديدة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'land_registry':
        return Icons.domain;
      case 'agriculture_ministry':
        return Icons.agriculture;
      case 'governor_saladin':
        return Icons.account_balance;
      case 'agriculture_directorate':
        return Icons.business;
      case 'agriculture_division':
        return Icons.corporate_fare;
      case 'important_orders':
        return Icons.priority_high;
      case 'complaints':
        return Icons.report_problem;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نظام أرشفة الوثائق الاحترافي'),
            SizedBox(height: 8),
            Text('الإصدار: 4.0.0'),
            SizedBox(height: 8),
            Text('تطبيق شامل لأرشفة وإدارة الوثائق'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
