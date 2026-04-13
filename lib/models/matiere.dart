class Matiere {
  final String id;
  final String nom;
  final String professeur;
  final String description;
  final String pdfPath;
  String contenu;

  Matiere({
    required this.id,
    required this.nom,
    required this.professeur,
    required this.description,
    required this.pdfPath,
    this.contenu = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'professeur': professeur,
    'description': description,
    'pdfPath': pdfPath,
    'contenu': contenu,
  };

  factory Matiere.fromJson(Map<String, dynamic> json) => Matiere(
    id: json['id'] as String,
    nom: json['nom'] as String,
    professeur: json['professeur'] as String,
    description: json['description'] as String,
    pdfPath: json['pdfPath'] as String,
    contenu: json['contenu'] as String? ?? '',
  );
}
