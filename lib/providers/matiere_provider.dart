import 'dart:io';
import 'package:flutter/material.dart';
import '../models/matiere.dart';
import '../services/excel_service.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';

class MatiereProvider extends ChangeNotifier {
  List<Matiere> _matieres = [];
  bool _isLoading = true;

  List<Matiere> get matieres => _matieres;
  bool get isLoading => _isLoading;

  static const List<Map<String, String>> defaultMatieres = [
    {
      'id': 'geodynamique_externe',
      'nom': 'Géodynamique Externe',
      'professeur': 'RAMIANDRISOA Njara',
      'description':
          'Fonctionnement du système Terre - Géodynamique interne & externe',
      'pdf': 'Géoddyn-Externe-L1-Pro-GEODE.pdf',
    },
    {
      'id': 'hydrologie',
      'nom': 'Hydrologie et Hydrogéologie',
      'professeur': 'RAMIANDRISOA Njara',
      'description': 'Bases de l\'hydrologie et de l\'hydrogéologie',
      'pdf': 'Le-Processus-Hydrologique.pdf',
    },
    {
      'id': 'stratigraphie',
      'nom': 'Stratigraphie',
      'professeur': 'RAZAFIMBELO Rachel',
      'description': 'Principaux événements géologiques - Stratigraphie',
      'pdf': 'Stratigraphie.pdf',
    },
    {
      'id': 'mineralogie',
      'nom': 'Minéralogie',
      'professeur': 'RAZAFIMAROSON Yvan Tommy',
      'description': 'Notion de cristallographie - Classification des minéraux',
      'pdf': 'Minéralogie-L1-Pro-Geode.pdf',
    },
    {
      'id': 'petrologie',
      'nom': 'Pétrologie',
      'professeur': 'RATRIMO Voahangy',
      'description':
          'Pétrographie des grandes familles des roches - Pétrographie endogène et exogène',
      'pdf': 'Pétrologie-minéralogie.pdf',
    },
    {
      'id': 'roches_metamorphiques',
      'nom': 'Roches Métamorphiques',
      'professeur': 'RATRIMO Voahangy',
      'description': 'Roches métamorphiques et pétrographie exogène',
      'pdf': 'ROCHCE-METAMORPHIQUE-RESUME.pdf',
    },
  ];

  Future<void> init() async {
    try {
      final savedMatieres = await StorageService.getMatieres();

      // Check if saved data has content; if not, reload defaults
      final hasContent =
          savedMatieres.isNotEmpty &&
          savedMatieres.any((m) => m.contenu.isNotEmpty);

      if (hasContent) {
        _matieres = savedMatieres;
        _isLoading = false;
        notifyListeners();
      } else {
        // Reload defaults with embedded content
        await _loadDefaultMatieres();
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      await _loadDefaultMatieres();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromExcel() async {
    try {
      final excelPaths = [
        '/home/lahiniriko/Documents/GEODE /semestre-1.xlsx',
        '/home/lahiniriko/Documents/GEODE/semestre-1.xlsx',
      ];

      List<Matiere>? excelMatieres;

      for (var path in excelPaths) {
        excelMatieres = await ExcelService.parseExcelFile(path);
        if (excelMatieres.isNotEmpty) break;
      }

      if (excelMatieres != null && excelMatieres.isNotEmpty) {
        for (var defaultMatiere in defaultMatieres) {
          final excelMatiere = excelMatieres
              .where((m) => m.id == defaultMatiere['id'])
              .firstOrNull;

          _matieres.add(
            Matiere(
              id: defaultMatiere['id']!,
              nom: defaultMatiere['nom']!,
              professeur:
                  excelMatiere?.professeur ?? defaultMatiere['professeur']!,
              description:
                  excelMatiere?.description ?? defaultMatiere['description']!,
              pdfPath: excelMatiere?.pdfPath ?? defaultMatiere['pdf']!,
            ),
          );
        }
      } else {
        _loadDefaultMatieres();
      }

      await StorageService.saveMatieres(_matieres);
    } catch (e) {
      _loadDefaultMatieres();
    }
  }

  Future<void> _loadDefaultMatieres() async {
    // Load embedded content for each matiere
    final embeddedContents = PdfService.loadAllEmbeddedContent();

    _matieres = defaultMatieres.map((m) {
      final contenu = embeddedContents[m['pdf']!] ?? '';
      return Matiere(
        id: m['id']!,
        nom: m['nom']!,
        professeur: m['professeur']!,
        description: m['description']!,
        pdfPath: m['pdf']!,
        contenu: contenu.length > 50000 ? contenu.substring(0, 50000) : contenu,
      );
    }).toList();
    await StorageService.saveMatieres(_matieres);
  }

  Future<void> _loadPdfContentsInBackground() async {
    // Don't block UI, load PDFs asynchronously
    await Future.delayed(Duration.zero);
    await _loadPdfContents();
  }

  Future<void> _loadPdfContents() async {
    final pdfFileMap = {
      'geodynamique_externe': 'Géoddyn-Externe-L1-Pro-GEODE.pdf',
      'hydrologie': 'Le-Processus-Hydrologique.pdf',
      'mineralogie': 'Minéralogie-L1-Pro-Geode.pdf',
      'petrologie': 'Pétrologie-minéralogie.pdf',
      'roches_metamorphiques': 'ROCHCE-METAMORPHIQUE-RESUME.pdf',
      'stratigraphie': 'Stratigraphie.pdf',
    };

    for (var i = 0; i < _matieres.length; i++) {
      final mati = _matieres[i];
      final pdfFileName = pdfFileMap[mati.id];

      if (pdfFileName != null && mati.contenu.isEmpty) {
        // Load embedded content from PdfService (no file reading)
        final contenu = PdfService.getPdfContent(pdfFileName);
        _matieres[i] = Matiere(
          id: mati.id,
          nom: mati.nom,
          professeur: mati.professeur,
          description: mati.description,
          pdfPath: pdfFileName,
          contenu: contenu.length > 50000
              ? contenu.substring(0, 50000)
              : contenu,
        );
      }
    }

    await StorageService.saveMatieres(_matieres);
  }

  Matiere? getMatiereById(String id) {
    try {
      return _matieres.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Matiere> getMatieresByProfesseur(String professeur) {
    return _matieres.where((m) => m.professeur == professeur).toList();
  }

  List<String> getProfesseurs() {
    return _matieres.map((m) => m.professeur).toSet().toList();
  }
}
