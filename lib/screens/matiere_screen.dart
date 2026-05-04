import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/matiere.dart';
import '../providers/connectivity_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/illustrations.dart';
import '../widgets/pdf_images.dart';
import 'chat_screen.dart';

class MatiereScreen extends StatefulWidget {
  final Matiere matiere;

  const MatiereScreen({super.key, required this.matiere});

  @override
  State<MatiereScreen> createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<_ChapterData> _chapters = [];

  static const Map<String, Color> subjectColors = {
    'geodynamique_externe': Color(0xFF2196F3),
    'hydrologie': Color(0xFF00BCD4),
    'stratigraphie': Color(0xFF9C27B0),
    'mineralogie': Color(0xFF4CAF50),
    'petrologie': Color(0xFFFF9800),
    'roches_metamorphiques': Color(0xFFE91E63),
  };

  static const Map<String, IconData> subjectIcons = {
    'geodynamique_externe': Icons.landscape,
    'hydrologie': Icons.water,
    'stratigraphie': Icons.layers,
    'mineralogie': Icons.diamond,
    'petrologie': Icons.ac_unit,
    'roches_metamorphiques': Icons.volcano,
  };

  @override
  void initState() {
    super.initState();
    _parseChapters();
    _tabController = TabController(length: _chapters.length + 1, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'read_${widget.matiere.id}';
    await prefs.setBool(key, true);
  }

  void _parseChapters() {
    final lines = widget.matiere.contenu.split('\n');
    int startLine = 0;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('CHAPITRE') && i > 0) {
        // Save previous chapter
        if (startLine < i) {
          _chapters.add(
            _ChapterData(
              title: _chapters.isEmpty
                  ? 'Introduction'
                  : lines[startLine - 1].trim(),
              startLine: startLine,
              endLine: i,
            ),
          );
        }
        startLine = i;
      }
    }
    // Add last chapter
    if (startLine < lines.length) {
      _chapters.add(
        _ChapterData(
          title: _chapters.isEmpty
              ? 'Contenu complet'
              : lines[startLine].trim(),
          startLine: startLine,
          endLine: lines.length,
        ),
      );
    }
    // If no chapters parsed, add full content as one tab
    if (_chapters.isEmpty) {
      _chapters.add(
        _ChapterData(title: 'Contenu', startLine: 0, endLine: lines.length),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectivityProvider = context.watch<ConnectivityProvider>();
    final color = subjectColors[widget.matiere.id] ?? theme.colorScheme.primary;
    final icon = subjectIcons[widget.matiere.id] ?? Icons.book;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, size: 28, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.matiere.nom,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.matiere.professeur,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                const Tab(text: '📋 Aperçu'),
                ..._chapters.map((ch) => Tab(text: ch.shortTitle)),
              ],
            ),
          ),

          // Content - show only selected tab
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_tabController.index == 0)
                  _buildOverviewTab(theme, color)
                else if (_tabController.index - 1 < _chapters.length)
                  _buildChapterTab(
                    theme,
                    color,
                    _chapters[_tabController.index - 1],
                  ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(initialTopic: widget.matiere.nom),
            ),
          );
        },
        icon: const Icon(Icons.chat),
        label: const Text('Poser une question'),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Description',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.matiere.description,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Chapters list
        Text(
          'Chapitres (${_chapters.length})',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ..._chapters.asMap().entries.map((entry) {
          final index = entry.key;
          final chapter = entry.value;
          return InkWell(
            onTap: () => _tabController.animateTo(index + 1),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      chapter.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),

        // Question suggestions
        _buildQuestionSuggestions(theme, color),
      ],
    );
  }

  Widget _buildChapterTab(ThemeData theme, Color color, _ChapterData chapter) {
    final lines = widget.matiere.contenu.split('\n');
    final chapterContent = lines
        .sublist(chapter.startLine, chapter.endLine)
        .join('\n');

    return _buildFormattedContent(theme, color, chapterContent);
  }

  Widget _buildFormattedContent(ThemeData theme, Color color, String content) {
    final lines = content.split('\n');
    final List<Widget> contentWidgets = [];

    final Set<String> insertedIllustrations = {};

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Chapter headers
      if (line.startsWith('CHAPITRE') || line.startsWith('===')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(_getChapterIcon(line), color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    line.replaceAll('===', '').trim(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        contentWidgets.add(
          Divider(color: color.withValues(alpha: 0.15), height: 1),
        );
      }
      // Section headers (A., B., C.)
      else if (RegExp(r'^[A-Z]\.').hasMatch(line) && line.length < 100) {
        contentWidgets.add(
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(6),
              border: Border(left: BorderSide(color: color, width: 3)),
            ),
            child: Text(
              line,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
      // Bullet points
      else if (line.startsWith('-') || line.startsWith('•')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    line.replaceFirst(RegExp(r'^[-•]\s*'), ''),
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Numbered items
      else if (RegExp(r'^\d+\.\s').hasMatch(line) && line.length < 150) {
        final match = RegExp(r'^(\d+)\.\s(.*)').firstMatch(line);
        if (match != null) {
          contentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        match.group(1)!,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      match.group(2)!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      // Formulas/tables
      else if ((line.contains('|') || line.contains('=')) && line.length > 10) {
        contentWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              line,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
        );
      }
      // Regular text
      else {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              line,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        );
      }

      // Insert illustrations based on content (with deduplication)
      final lowerLine = line.toLowerCase();
      if ((lowerLine.contains('cycle de l\'eau') ||
              lowerLine.contains('cycle hydrologique')) &&
          !insertedIllustrations.contains('water_cycle')) {
        insertedIllustrations.add('water_cycle');
        contentWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: WaterCycleDiagram(),
          ),
        );
      } else if ((lowerLine.contains('changement de phase') ||
              (lowerLine.contains('évaporation') &&
                  lowerLine.contains('condensation'))) &&
          !insertedIllustrations.contains('phase_change')) {
        insertedIllustrations.add('phase_change');
        contentWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: PhaseChangeDiagram(),
          ),
        );
      } else if (lowerLine.contains('répartition') &&
          lowerLine.contains('eau') &&
          !insertedIllustrations.contains('water_distribution')) {
        insertedIllustrations.add('water_distribution');
        contentWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: WaterDistributionTable(),
          ),
        );
      } else if (CourseImageInserter.hasMatchingImage(line)) {
        // Only insert PDF image if no illustration was already added for this line
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CourseImageInserter(lineText: line),
          ),
        );
      }
    }

    return Column(children: contentWidgets);
  }

  IconData _getChapterIcon(String line) {
    final lower = line.toLowerCase();
    if (lower.contains('introduction') || lower.contains('général'))
      return Icons.info_outline;
    if (lower.contains('cycle') || lower.contains('eau'))
      return Icons.water_drop;
    if (lower.contains('érosion') || lower.contains('altération'))
      return Icons.landscape;
    if (lower.contains('transport')) return Icons.local_shipping;
    if (lower.contains('sédiment')) return Icons.layers;
    if (lower.contains('roche')) return Icons.ac_unit;
    if (lower.contains('sol')) return Icons.terrain;
    if (lower.contains('précipitation')) return Icons.cloud;
    if (lower.contains('minéral') || lower.contains('classification'))
      return Icons.diamond;
    if (lower.contains('cristal')) return Icons.hexagon;
    if (lower.contains('propriété')) return Icons.tune;
    if (lower.contains('magmatique') || lower.contains('ignée'))
      return Icons.volcano;
    if (lower.contains('métamorph')) return Icons.auto_fix_high;
    if (lower.contains('temps') || lower.contains('chrono'))
      return Icons.schedule;
    if (lower.contains('fossil')) return Icons.pets;
    return Icons.menu_book;
  }

  Widget _buildQuestionSuggestions(ThemeData theme, Color color) {
    final suggestions = [
      {'label': 'Expliquer ${widget.matiere.nom}', 'icon': Icons.help_outline},
      {'label': 'Résumé du cours', 'icon': Icons.summarize},
      {'label': 'Exemples pratiques', 'icon': Icons.lightbulb},
      {'label': 'Questions d\'examen', 'icon': Icons.quiz},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              'Suggestions de questions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: suggestions.map((s) {
            return ActionChip(
              avatar: Icon(s['icon'] as IconData, size: 16, color: color),
              label: Text(
                s['label'] as String,
                style: const TextStyle(fontSize: 11),
              ),
              onPressed: () => _askQuestion(context, s['label'] as String),
              backgroundColor: color.withValues(alpha: 0.06),
              side: BorderSide(color: color.withValues(alpha: 0.2)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _askQuestion(BuildContext context, String question) {
    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(
      question,
      context.read<ConnectivityProvider>().isOnline,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(initialQuestion: question)),
    );
  }
}

class _ChapterData {
  final String title;
  final int startLine;
  final int endLine;

  _ChapterData({
    required this.title,
    required this.startLine,
    required this.endLine,
  });

  String get shortTitle {
    // Extract chapter number and short name
    final match = RegExp(r'CHAPITRE\s+(\d+)\s*[:.]?\s*(.+)?').firstMatch(title);
    if (match != null) {
      return 'Ch. ${match.group(1)}: ${match.group(2)?.substring(0, match.group(2)!.length.clamp(0, 20)) ?? ""}';
    }
    if (title.length > 25) {
      return '${title.substring(0, 22)}...';
    }
    return title;
  }
}
