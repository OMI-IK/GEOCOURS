import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/matiere_provider.dart';
import '../services/groq_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  dynamic _selectedMatiere;
  List<Map<String, dynamic>> _quiz = [];
  int _currentQuestion = 0;
  int _score = 0;
  bool _loading = false;
  bool _showResults = false;
  int? _selectedAnswer;

  Future<void> _generateQuiz() async {
    if (_selectedMatiere == null) return;

    setState(() {
      _loading = true;
      _quiz = [];
      _currentQuestion = 0;
      _score = 0;
      _showResults = false;
    });

    try {
      final response = await GroqService.sendMessage(
        'Génère un quiz de 5 questions QCM sur ${_selectedMatiere.nom}. Format: JSON array avec chaque question ayant "question", "options" (array de 4 choix), "answer" (index 0-3), "explanation". Réponds uniquement en JSON valide.',
        [],
      );

      // Simple JSON extraction
      final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response);
      if (jsonMatch != null) {
        // Parse quiz data - simplified for now
        setState(() {
          _quiz = [
            {
              'question': 'Quel est le principal minéral du granite?',
              'options': ['Quartz', 'Calcite', 'Gypse', 'Halite'],
              'answer': 0,
              'explanation': 'Le quartz est un constituant majeur du granite.',
            },
            {
              'question': 'Quelle roche est volcanique?',
              'options': ['Granite', 'Gneiss', 'Basalte', 'Marbre'],
              'answer': 2,
              'explanation': 'Le basalte est une roche volcanique.',
            },
            {
              'question': 'Quel processus forme les roches sédimentaires?',
              'options': ['Fusion', 'Sédimentation', 'Métamorphisme', 'Cristallisation'],
              'answer': 1,
              'explanation': 'La sédimentation et la diagenèse forment les roches sédimentaires.',
            },
          ];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _selectAnswer(int index) {
    if (_showResults) return;
    setState(() {
      _selectedAnswer = index;
      _showResults = true;
      if (index == _quiz[_currentQuestion]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _quiz.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _showResults = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final matiereProvider = context.watch<MatiereProvider>();
    final theme = Theme.of(context);

    if (matiereProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    _selectedMatiere ??= matiereProvider.matieres.first;

    if (_quiz.isEmpty && !_loading) {
      return _buildQuizSelector(context, matiereProvider, theme);
    }

    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Génération du quiz...',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return _buildQuiz(context, theme);
  }

  Widget _buildQuizSelector(BuildContext context, dynamic matiereProvider, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Teste tes connaissances sur chaque matière',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final matiere = matiereProvider.matieres[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedMatiere = matiere);
                        _generateQuiz();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.quiz, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    matiere.nom,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Commencer le quiz',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_arrow),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: matiereProvider.matieres.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz(BuildContext context, ThemeData theme) {
    final question = _quiz[_currentQuestion];

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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => setState(() => _quiz = []),
                      ),
                      Text(
                        'Question ${_currentQuestion + 1}/${_quiz.length}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Score: $_score',
                          style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestion + 1) / _quiz.length,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                question['question'] as String,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...(question['options'] as List).asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value as String;
                final isSelected = _selectedAnswer == index;
                final isCorrect = index == question['answer'];
                final showResult = _showResults;

                Color borderColor = Colors.grey.withValues(alpha: 0.3);
                Color bgColor = theme.cardColor;

                if (showResult) {
                  if (isCorrect) {
                    borderColor = Colors.green;
                    bgColor = Colors.green.withValues(alpha: 0.1);
                  } else if (isSelected && !isCorrect) {
                    borderColor = Colors.red;
                    bgColor = Colors.red.withValues(alpha: 0.1);
                  }
                } else if (isSelected) {
                  borderColor = theme.colorScheme.primary;
                  bgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
                }

                return InkWell(
                  onTap: () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: borderColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(option)),
                        if (showResult && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (showResult && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                );
              }).toList(),
              if (_showResults) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(question['explanation'] as String),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _nextQuestion,
                    child: Text(_currentQuestion < _quiz.length - 1 ? 'Suivant' : 'Voir les résultats'),
                  ),
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}
