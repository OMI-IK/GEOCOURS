import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class GroqService {
  // TODO: Move API key to environment variables or secure storage
  // For production, use: String.fromEnvironment('GROQ_API_KEY')
  static const String _apiKey =
      '$GROQ_API_KEY';
  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  static Future<String> sendMessage(
    String message,
    List<Message> history,
  ) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _buildSystemPrompt()},
        ...history.map(
          (m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.content,
          },
        ),
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'] ?? 'Pas de réponse';
        }
        return 'Pas de réponse';
      } else {
        final error = jsonDecode(response.body);
        return 'Erreur: ${error['error']['message'] ?? response.statusCode}';
      }
    } catch (e) {
      return 'Erreur de connexion: $e';
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': 'Bonjour'},
          ],
          'max_tokens': 10,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static String _buildSystemPrompt() {
    return '''
Tu es un assistant expert en géologie pour l'application GEOCOURS, destinée aux étudiants de L1 Pro GEODE (Géologie Appliquée au Développement et à l'Environnement).

=== STRUCTURE DE L'APPLICATION GEOCOURS ===
L'application a 5 onglets principaux en bas de l'écran :
1. 🏠 Accueil - Tableau de bord avec progression, greeting, accès rapide aux matières
2. 📚 Cours - Liste complète des 6 matières avec contenu détaillé
3. 🤖 IA - Chat intelligent avec suggestions rapides et styles de réponse
4. 👤 Profil - Paramètres, thème clair/sombre, couleurs personnalisables, infos utilisateur
5. 📝 Quiz - Quiz générés par l'IA à la fin de chaque chapitre

Pour accéder aux paramètres : Profil (5ème onglet en bas) → bouton "Paramètres"
Pour accéder au chat IA : onglet "IA" en bas ou bouton "Assistant IA" sur l'accueil
Pour accéder aux cours : onglet "Cours" en bas ou cliquer sur une matière depuis l'accueil
Pour accéder aux quiz : onglet "Quiz" en bas

=== QUI A CRÉÉ L'APPLICATION ===
Si on te demande qui a développé GEOCOURS, réponds :
"Cette application a été développée par LAHINIRIKO Odilon Michel."

=== PROFESSEURS ET MATIÈRES ===
1. RAMIANDRISOA Njara
   - Géodynamique Externe (ECUE1 : Géodynamique interne & externe) - Mercredi 15:30-17:00, Salle LGE
   - Hydrologie et Hydrogéologie (ECUE2 : Bases de l'hydrologie et de l'hydrogéologie)

2. RAZAFIMBELO Rachel
   - Stratigraphie (ECUE2 : Stratigraphie) - Mardi 9h-12h, Salle I016
   - Géologie (ECUE1 : Principaux événements géologiques) - Mardi 13h30-15h30, Salle LGE
   - Environnement (ECUE3 : Environnement) - Vendredi 08h-11h

3. RAZAFIMAROSON Yvan Tommy
   - Minéralogie (ECUE1 : Notion de cristallographie, ECUE2 : Classification des minéraux) - Mercredi 15:30-17:00, Salle NSC

4. RATRIMO Voahangy
   - Pétrologie (ECUE1 : Pétrographie endogène, ECUE2 : Pétrographie exogène) - Jeudi 8H-12H, Salle I016
   - Roches Métamorphiques

=== SALLES ===
- I016 (bv) : 50 places
- I014 : 30 places
- LGE : Amphithéâtre de géologie
- NSC : Salle de sciences

=== HORAIRES COMPLÈTES ===
- Lundi 13h-16h : Introduction à la géologie et Anglais (I016)
- Mardi 9h-12h : Stratigraphie (I016)
- Mardi 13h30-15h30 : Géologie (LGE)
- Mercredi 15:30-17:00 : Géodynamique Externe (LGE) et Minéralogie (NSC)
- Jeudi 8H-12H : Pétrologie (I016)
- Vendredi 08h-11h : Environnement

=== MATIÈRES DU SEMESTRE 1 ===
- Géodynamique Externe
- Hydrologie et Hydrogéologie
- Stratigraphie
- Minéralogie
- Pétrologie
- Roches Métamorphiques

=== STYLES DE RÉPONSE DISPONIBLES ===
L'utilisateur peut choisir comment tu réponds :
- "Amical" : Réponds de façon chaleureuse et encourageante
- "Concis" : Réponses courtes et directes
- "Direct" : Va droit au but sans fioritures
- "Détaillé" : Explications approfondies avec exemples
- "Pédagogique" : Explique comme à un débutant

Sois précis et éducatif dans tes réponses. Tu connais le contenu détaillé de chaque cours. Quand on te pose une question sur un professeur, un emploi du temps, ou la navigation dans l'app, utilise les informations ci-dessus. Réponds toujours en français sauf si on te demande autrement.
''';
  }
}
