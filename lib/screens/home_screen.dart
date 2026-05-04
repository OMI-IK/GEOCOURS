import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/matiere_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/chat_provider.dart';
import 'matiere_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _userName;
  int _quizCompleted = 0;
  int _totalQuizScore = 0;
  int _totalQuizMax = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');

    int readCount = 0;
    int quizScore = 0;
    int quizMax = 0;

    for (var matiere in context.read<MatiereProvider>().matieres) {
      if (prefs.getBool('read_${matiere.id}') ?? false) readCount++;
      quizScore += prefs.getInt('quiz_score_${matiere.id}') ?? 0;
      quizMax += prefs.getInt('quiz_max_${matiere.id}') ?? 0;
    }

    setState(() {
      _userName = name;
      _quizCompleted = readCount;
      _totalQuizScore = quizScore;
      _totalQuizMax = quizMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        _AccueilPage(
          userName: _userName,
          quizScore: _totalQuizScore,
          quizMax: _totalQuizMax,
          matieresRead: _quizCompleted,
          onNavigateToIA: () => setState(() => _currentIndex = 2),
        ),
        const _CoursPage(),
        const ChatScreen(),
        const _ProfilPage(),
        const QuizScreen(),
      ][_currentIndex],
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final labels = ['Accueil', 'Cours', 'IA', 'Profil', 'Quiz'];
    final icons = [
      Icons.home_rounded,
      Icons.menu_book,
      Icons.smart_toy,
      Icons.person,
      Icons.quiz,
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              final isSelected = _currentIndex == i;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _currentIndex = i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    )
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              icons[i] as IconData,
                              size: 20,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// PAGE ACCUEIL - DASHBOARD
// ═══════════════════════════════════════════
class _AccueilPage extends StatelessWidget {
  final String? userName;
  final int quizScore;
  final int quizMax;
  final int matieresRead;
  final VoidCallback? onNavigateToIA;

  const _AccueilPage({
    this.userName,
    this.quizScore = 0,
    this.quizMax = 0,
    this.matieresRead = 0,
    this.onNavigateToIA,
  });

  @override
  Widget build(BuildContext context) {
    final matiereProvider = context.watch<MatiereProvider>();
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Bonjour' : 'Bonsoir';
    final displayName = userName ?? 'Étudiant';
    final totalMatieres = matiereProvider.matieres.length;
    final progressPercent = totalMatieres > 0
        ? (matieresRead / totalMatieres * 100).round()
        : 0;
    final quizPercent = quizMax > 0 ? (quizScore / quizMax * 100).round() : 0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$greeting, $displayName 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Prêt à explorer la géologie ?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Consumer<ConnectivityProvider>(
                        builder: (context, conn, _) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: conn.isOnline
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              conn.isOnline ? Icons.wifi : Icons.wifi_off,
                              size: 20,
                              color: conn.isOnline ? Colors.green : Colors.red,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Dashboard Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.dashboard, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Tableau de bord',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DashStat(
                          icon: Icons.menu_book,
                          label: 'Matières lues',
                          value: '$matieresRead/$totalMatieres',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DashStat(
                          icon: Icons.quiz,
                          label: 'Score Quiz',
                          value: quizMax > 0 ? '$quizScore/$quizMax' : '0',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DashStat(
                          icon: Icons.trending_up,
                          label: 'Progression',
                          value: '$progressPercent%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressPercent / 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressPercent >= 75
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Quick buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _QuickButton(
                    icon: Icons.smart_toy,
                    label: 'Assistant IA',
                    color: theme.colorScheme.tertiary,
                    onTap: () => onNavigateToIA?.call(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickButton(
                    icon: Icons.search,
                    label: 'Rechercher',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Matieres section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Vos matières',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Loading or cards
        matiereProvider.isLoading
            ? const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final matiere = matiereProvider.matieres[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MatiereCard(matiere: matiere),
                    );
                  }, childCount: matiereProvider.matieres.length),
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// PAGE COURS
// ═══════════════════════════════════════════
class _CoursPage extends StatelessWidget {
  const _CoursPage();

  @override
  Widget build(BuildContext context) {
    final matiereProvider = context.watch<MatiereProvider>();
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Toutes les matières',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        matiereProvider.isLoading
            ? const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final matiere = matiereProvider.matieres[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MatiereCard(matiere: matiere),
                    );
                  }, childCount: matiereProvider.matieres.length),
                ),
              ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// PAGE PROFIL
// ═══════════════════════════════════════════
class _ProfilPage extends StatelessWidget {
  const _ProfilPage();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Profil',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LAHINIRIKO Odilon Michel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'L1 Pro GEODE',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _ProfileOption(
                icon: themeProvider.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: themeProvider.themeMode == ThemeMode.dark
                    ? 'Mode sombre'
                    : 'Mode clair',
                onTap: () => themeProvider.toggleTheme(),
              ),
              _ProfileOption(
                icon: Icons.settings,
                title: 'Paramètres',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'À propos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'GEOCOURS - App éducative L1 Pro GEODE\nFaculté des Sciences - Université de Madagascar\nDéveloppé par LAHINIRIKO Odilon Michel',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// WIDGETS
// ═══════════════════════════════════════════

class _DashStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DashStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatiereCard extends StatelessWidget {
  final dynamic matiere;
  const _MatiereCard({required this.matiere});

  static const Map<String, Color> colors = {
    'geodynamique_externe': Color(0xFF2E7D32),
    'hydrologie': Color(0xFF1E3A5F),
    'stratigraphie': Color(0xFF6B7280),
    'mineralogie': Color(0xFFD97706),
    'petrologie': Color(0xFF9C27B0),
    'roches_metamorphiques': Color(0xFFE91E63),
  };

  static const Map<String, IconData> icons = {
    'geodynamique_externe': Icons.landscape,
    'hydrologie': Icons.water,
    'stratigraphie': Icons.layers,
    'mineralogie': Icons.diamond,
    'petrologie': Icons.ac_unit,
    'roches_metamorphiques': Icons.volcano,
  };

  @override
  Widget build(BuildContext context) {
    final color = colors[matiere.id] ?? AppColors.bleuProfond;
    final icon = icons[matiere.id] ?? Icons.book;
    final theme = Theme.of(context);

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MatiereScreen(matiere: matiere)),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matiere.nom,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        matiere.professeur,
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
