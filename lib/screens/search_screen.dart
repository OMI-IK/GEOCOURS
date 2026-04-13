import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/matiere_provider.dart';
import 'matiere_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  Map<String, List<_SearchResult>> _results = {};

  void _search(String query) {
    if (query.length < 2) {
      setState(() {
        _query = query;
        _results = {};
      });
      return;
    }

    setState(() {
      _query = query;
      _results = {};
    });

    final matiereProvider = context.read<MatiereProvider>();
    for (var matiere in matiereProvider.matieres) {
      final results = <_SearchResult>[];
      final content = matiere.contenu.toLowerCase();
      final nom = matiere.nom.toLowerCase();
      final q = query.toLowerCase();

      // Check if query matches in content
      if (content.contains(q)) {
        final lines = matiere.contenu.split('\n');
        for (var line in lines) {
          if (line.toLowerCase().contains(q)) {
            results.add(_SearchResult(
              line: line.trim(),
              matiere: matiere,
            ));
            if (results.length >= 5) break;
          }
        }
      }
      // Check if query matches in name
      if (nom.contains(q)) {
        results.insert(
          0,
          _SearchResult(
            line: '${matiere.nom} - ${matiere.professeur}',
            matiere: matiere,
            isTitle: true,
          ),
        );
      }

      if (results.isNotEmpty) {
        _results[matiere.nom] = results;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Rechercher dans les cours...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'Rechercher dans toutes les matières',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun résultat pour "$_query"',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final matiereName = _results.keys.elementAt(index);
                    final results = _results[matiereName]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.folder, size: 18, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                matiereName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${results.length}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...results.map((r) => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MatiereScreen(matiere: r.matiere),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (r.isTitle) ...[
                                        Text(
                                          r.line,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ] else ...[
                                        Text(
                                          r.line,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Voir dans ${r.matiere.nom}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        const Divider(),
                      ],
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SearchResult {
  final String line;
  final dynamic matiere;
  final bool isTitle;

  _SearchResult({required this.line, required this.matiere, this.isTitle = false});
}
