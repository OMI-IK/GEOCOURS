import 'dart:io';
import 'package:excel/excel.dart';
import '../models/matiere.dart';

class ExcelService {
  static Future<List<Matiere>> parseExcelFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return [];
      }

      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      List<Matiere> matieres = [];
      String? currentProfesseur;

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        for (var row in sheet.rows) {
          if (row.isEmpty) continue;

          final cell0 = row[0]?.value?.toString().trim();
          final cell2 = row[2]?.value?.toString().trim();

          if (cell0 != null &&
              cell0.isNotEmpty &&
              !cell0.contains('RESPONSABLE')) {
            currentProfesseur = cell0;
          }

          if (cell2 != null && cell2.isNotEmpty && cell2.startsWith('ECUE')) {
            String nomMatiere = cell2
                .replaceAll(RegExp(r'^ECUE\d+ : '), '')
                .replaceAll(RegExp(r'\s*\(\d+\)$'), '');

            String mappedId = '';
            if (nomMatiere.toLowerCase().contains('géodynamique')) {
              mappedId = 'geodynamique_externe';
            } else if (nomMatiere.toLowerCase().contains('hydrolog') ||
                nomMatiere.toLowerCase().contains('hydrogéolog')) {
              mappedId = 'hydrologie';
            } else if (nomMatiere.toLowerCase().contains('minéralog') ||
                nomMatiere.toLowerCase().contains('cristallograph')) {
              mappedId = 'mineralogie';
            } else if (nomMatiere.toLowerCase().contains('pétr') ||
                nomMatiere.toLowerCase().contains('roche')) {
              mappedId = 'petrologie';
            } else if (nomMatiere.toLowerCase().contains('métamorph')) {
              mappedId = 'roches_metamorphiques';
            } else if (nomMatiere.toLowerCase().contains('stratigraph')) {
              mappedId = 'stratigraphie';
            } else if (nomMatiere.toLowerCase().contains('géolog')) {
              mappedId = 'geologie';
            } else {
              continue;
            }

            bool exists = matieres.any((m) => m.id == mappedId);
            if (!exists) {
              matieres.add(
                Matiere(
                  id: mappedId,
                  nom: _getDisplayName(mappedId),
                  professeur: currentProfesseur ?? 'Inconnu',
                  description: nomMatiere,
                  pdfPath: _getPdfPath(mappedId),
                ),
              );
            }
          }
        }
      }

      return matieres;
    } catch (e) {
      return [];
    }
  }

  static String _getDisplayName(String id) {
    switch (id) {
      case 'geodynamique_externe':
        return 'Géodynamique Externe';
      case 'hydrologie':
        return 'Hydrologie';
      case 'mineralogie':
        return 'Minéralogie';
      case 'petrologie':
        return 'Pétrologie';
      case 'roches_metamorphiques':
        return 'Roches Métamorphiques';
      case 'stratigraphie':
        return 'Stratigraphie';
      case 'geologie':
        return 'Géologie';
      default:
        return id;
    }
  }

  static String _getPdfPath(String id) {
    const basePath = '/storage/emulated/0/Documents/GEODE';
    switch (id) {
      case 'geodynamique_externe':
        return '$basePath/Géoddyn-Externe-L1-Pro-GEODE.pdf';
      case 'hydrologie':
        return '$basePath/Le-Processus-Hydrologique.pdf';
      case 'mineralogie':
        return '$basePath/Minéralogie-L1-Pro-Geode.pdf';
      case 'petrologie':
        return '$basePath/Pétrologie-minéralogie.pdf';
      case 'roches_metamorphiques':
        return '$basePath/ROCHCE-METAMORPHIQUE-RESUME.pdf';
      case 'stratigraphie':
        return '$basePath/Stratigraphie.pdf';
      default:
        return '';
    }
  }
}
