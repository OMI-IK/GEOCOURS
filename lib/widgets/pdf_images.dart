import 'package:flutter/material.dart';

/// Widget that displays PDF-extracted images mapped to course sections
class PdfImageWidget extends StatelessWidget {
  final String sectionKeyword;
  final double? maxWidth;

  const PdfImageWidget({
    super.key,
    required this.sectionKeyword,
    this.maxWidth,
  });

  // Map of keywords to image files extracted from Géodynamique Externe PDF
  static const Map<String, String> geodynamiqueImages = {
    'coupe_terre': 'page1_img1.png',
    'structure_terre': 'page1_img2.png',
    'cycle_eau': 'page26_img1.png',
    'atmosphere': 'page2_img4.png',
    'erosion': 'page3_img3.png',
    'transport': 'page3_img4.png',
    'sedimentation': 'page3_img5.png',
    'bassin_versant': 'page4_img4.png',
    'riviere': 'page4_img5.png',
    'nappe_phreatique': 'page6_img5.png',
    'alteration': 'page7_img5.png',
    'glacier': 'page11_img3.png',
    'vent_erosion': 'page15_img3.png',
    'schema_eau': 'page17_img1.png',
    'paysage': 'page8_img1.jpeg',
    'delta': 'page12_img1.jpeg',
    'recif': 'page27_img1.jpeg',
    'dune': 'page28_img1.jpeg',
    'fallaise': 'page29_img1.jpeg',
    'volcan': 'page30_img1.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    // Find matching image
    String? imageName;
    for (var entry in geodynamiqueImages.entries) {
      if (sectionKeyword.toLowerCase().contains(entry.key)) {
        imageName = entry.value;
        break;
      }
    }

    if (imageName == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/$imageName',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400),
                  ),
                );
              },
            ),
          ),
          // Caption
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Figure - ${_formatLabel(sectionKeyword)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

/// Widget to insert PDF images at relevant positions in course content
class CourseImageInserter extends StatelessWidget {
  final String lineText;

  const CourseImageInserter({super.key, required this.lineText});

  @override
  Widget build(BuildContext context) {
    final lower = lineText.toLowerCase();

    // Determine which images to show based on content keywords
    if (lower.contains('coupe de la terre') ||
        lower.contains('structure interne')) {
      return const PdfImageWidget(sectionKeyword: 'coupe_terre');
    }

    if (lower.contains('cycle de l\'eau') ||
        lower.contains('cycle hydrologique')) {
      return const PdfImageWidget(sectionKeyword: 'cycle_eau');
    }

    if (lower.contains('atmosphère')) {
      return const PdfImageWidget(sectionKeyword: 'atmosphere');
    }

    if (lower.contains('érosion') || lower.contains('altération')) {
      return Column(
        children: const [
          PdfImageWidget(sectionKeyword: 'erosion'),
          PdfImageWidget(sectionKeyword: 'alteration'),
        ],
      );
    }

    if (lower.contains('transport')) {
      return const PdfImageWidget(sectionKeyword: 'transport');
    }

    if (lower.contains('sédiment')) {
      return const PdfImageWidget(sectionKeyword: 'sedimentation');
    }

    if (lower.contains('bassin versant')) {
      return const PdfImageWidget(sectionKeyword: 'bassin_versant');
    }

    if (lower.contains('rivière') || lower.contains('fleuve')) {
      return const PdfImageWidget(sectionKeyword: 'riviere');
    }

    if (lower.contains('nappe') || lower.contains('souterraine')) {
      return const PdfImageWidget(sectionKeyword: 'nappe_phreatique');
    }

    if (lower.contains('glacier')) {
      return const PdfImageWidget(sectionKeyword: 'glacier');
    }

    if (lower.contains('vent')) {
      return const PdfImageWidget(sectionKeyword: 'vent_erosion');
    }

    if (lower.contains('delta')) {
      return const PdfImageWidget(sectionKeyword: 'delta');
    }

    if (lower.contains('récif') || lower.contains('corail')) {
      return const PdfImageWidget(sectionKeyword: 'recif');
    }

    if (lower.contains('dune')) {
      return const PdfImageWidget(sectionKeyword: 'dune');
    }

    if (lower.contains('volcan')) {
      return const PdfImageWidget(sectionKeyword: 'volcan');
    }

    return const SizedBox.shrink();
  }
}
