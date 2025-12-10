import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import '../theme/modern_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/modern_buttons.dart';
import 'add_document_screen.dart';
import 'document_detail_screen.dart';
import 'search_screen.dart';
import 'statistics_screen.dart';
import 'ai_settings_screen.dart';
import 'settings_screen.dart';

class StunningHomeScreen extends StatefulWidget {
  const StunningHomeScreen({super.key});

  @override
  State<StunningHomeScreen> createState() => _StunningHomeScreenState();
}

class _StunningHomeScreenState extends State<StunningHomeScreen> 
    with TickerProviderStateMixin {
  String _selectedFilter = 'all';
  String _selectedType = 'all';
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Floating animation for FAB
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    // Pulse animation for icons
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = context.read<DatabaseService>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildStunningAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: ModernTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 60),
            
            // Filter chips with shimmer effect
            _buildFilterSection(),
            
            // Type filter with glassmorphism
            _buildTypeSection(),
            
            const SizedBox(height: 16),
            
            // Documents grid with advanced animations
            Expanded(
              child: _buildDocumentsGrid(databaseService),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(),
    );
  }

  PreferredSizeWidget _buildStunningAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: ModernTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: ModernTheme.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'أرشيف الوثائق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        _buildGlassButton(
          icon: Icons.search_rounded,
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SearchScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildGlassButton(
          icon: Icons.analytics_rounded,
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const StatisticsScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildMenuButton(),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
      ),
      onSelected: (value) {
        if (value == 'settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        } else if (value == 'ai_settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AISettingsScreen()),
          );
        } else if (value == 'about') {
          _showAboutDialog();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 10,
      itemBuilder: (context) => [
        _buildMenuItem(Icons.settings_rounded, 'الإعدادات', 'settings'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.psychology_rounded, 'إعدادات AI', 'ai_settings'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.info_outline_rounded, 'حول التطبيق', 'about'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String text, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: ModernTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildModernChip('الكل', 'all', Icons.dashboard_rounded, _selectedFilter == 'all'),
          _buildModernChip('جديد', 'new', Icons.fiber_new_rounded, _selectedFilter == 'new'),
          _buildModernChip('تحت المراجعة', 'review', Icons.rate_review_rounded, _selectedFilter == 'review'),
          _buildModernChip('مكتمل', 'completed', Icons.check_circle_rounded, _selectedFilter == 'completed'),
          _buildModernChip('مؤرشف', 'archived', Icons.archive_rounded, _selectedFilter == 'archived'),
          _buildModernChip('المفضلة', 'favorites', Icons.star_rounded, _selectedFilter == 'favorites'),
        ],
      ),
    );
  }

  Widget _buildTypeSection() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildGlassChip('الكل', 'all', _selectedType == 'all', true),
          _buildGlassChip('كتب الأراضي', 'land_registry', _selectedType == 'land_registry', true),
          _buildGlassChip('وزارة الزراعة', 'agriculture_ministry', _selectedType == 'agriculture_ministry', true),
          _buildGlassChip('المحافظ', 'governor_saladin', _selectedType == 'governor_saladin', true),
          _buildGlassChip('مديرية زراعة', 'agriculture_directorate', _selectedType == 'agriculture_directorate', true),
          _buildGlassChip('شعبة زراعة', 'agriculture_division', _selectedType == 'agriculture_division', true),
          _buildGlassChip('أوامر مهمة', 'important_orders', _selectedType == 'important_orders', true),
          _buildGlassChip('الشكوي', 'complaints', _selectedType == 'complaints', true),
          _buildGlassChip('أخرى', 'other', _selectedType == 'other', true),
        ],
      ),
    );
  }

  Widget _buildModernChip(String label, String value, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? ModernTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.5) 
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ModernTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassChip(String label, String value, bool isSelected, bool isType) {
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? ModernTheme.secondaryGradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.5) 
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ModernTheme.secondaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsGrid(DatabaseService databaseService) {
    return StreamBuilder(
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
          color: ModernTheme.primaryColor,
          backgroundColor: Colors.white,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return _buildStunningCard(documents[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildStunningCard(Document document, int index) {
    return Hero(
      tag: 'document_${document.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DocumentDetailScreen(document: document),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                      ),
                      child: child,
                    ),
                  );
                },
              ),
            );
            if (result == true) {
              setState(() {});
            }
          },
          borderRadius: BorderRadius.circular(25),
          child: GlassCard(
            blur: 15,
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with gradient background
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: _getDocumentGradient(document.type),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: _getDocumentColor(document.type).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getDocumentIcon(document.type),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      if (document.isFavorite)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Title
                  Text(
                    document.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Type
                  Text(
                    document.typeDisplayName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: _getStatusGradient(document.status),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(document.status).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      document.statusDisplayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(document.createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: ModernTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ModernTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'لا توجد وثائق',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'اضغط على الزر أدناه لإضافة وثيقة جديدة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: ModernFloatingButton(
            icon: Icons.add_rounded,
            label: 'إضافة وثيقة',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AddDocumentScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    );
                  },
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
          ),
        );
      },
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'land_registry':
        return Icons.domain_rounded;
      case 'agriculture_ministry':
        return Icons.agriculture_rounded;
      case 'governor_saladin':
        return Icons.account_balance_rounded;
      case 'agriculture_directorate':
        return Icons.business_rounded;
      case 'agriculture_division':
        return Icons.corporate_fare_rounded;
      case 'important_orders':
        return Icons.priority_high_rounded;
      case 'complaints':
        return Icons.report_problem_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'land_registry':
        return const Color(0xFF6366F1);
      case 'agriculture_ministry':
        return const Color(0xFF10B981);
      case 'governor_saladin':
        return const Color(0xFFF59E0B);
      case 'agriculture_directorate':
        return const Color(0xFF8B5CF6);
      case 'agriculture_division':
        return const Color(0xFFEC4899);
      case 'important_orders':
        return const Color(0xFFEF4444);
      case 'complaints':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF6B7280);
    }
  }

  LinearGradient _getDocumentGradient(String type) {
    Color color = _getDocumentColor(type);
    return LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return const Color(0xFF3B82F6);
      case 'review':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF10B981);
      case 'archived':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  LinearGradient _getStatusGradient(String status) {
    Color color = _getStatusColor(status);
    return LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: ModernTheme.primaryGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text('حول التطبيق'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('نظام أرشفة الوثائق الاحترافي'),
            const SizedBox(height: 8),
            const Text('الإصدار: 6.0.0 - Modern UI'),
            const SizedBox(height: 8),
            Text(
              'تطبيق شامل لأرشفة وإدارة الوثائق مع واجهة عصرية ومذهلة',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: ModernTheme.successGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'مدعوم بـ DeepSeek AI',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ModernGradientButton(
            text: 'حسناً',
            onPressed: () => Navigator.pop(context),
            gradient: ModernTheme.primaryGradient,
          ),
        ],
      ),
    );
  }
}
