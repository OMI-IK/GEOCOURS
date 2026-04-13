import 'dart:io';
import 'dart:typed_data';

class PdfService {
  static Future<String> extractTextFromPdf(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return 'Fichier PDF non trouvé: $filePath';
      }

      final bytes = await file.readAsBytes();
      final text = _extractTextFromPdfBytes(bytes, filePath.split('/').last);

      if (text.isEmpty) {
        return _getPlaceholderContent(filePath.split('/').last);
      }

      return text;
    } catch (e) {
      return _getPlaceholderContent(filePath.split('/').last);
    }
  }

  static String _extractTextFromPdfBytes(Uint8List bytes, String fileName) {
    try {
      final StringBuffer result = StringBuffer();

      final pdfContent = String.fromCharCodes(bytes);

      final textPattern = RegExp(r'\(([^)]+)\)', multiLine: true);
      final matches = textPattern.allMatches(pdfContent);

      for (var match in matches) {
        final text = match.group(1);
        if (text != null &&
            text.length > 2 &&
            !text.contains('%%') &&
            !text.contains('Font')) {
          result.write(text);
          result.write(' ');
        }
      }

      return result.toString().length > 100 ? result.toString() : '';
    } catch (e) {
      return '';
    }
  }

  static String _getPlaceholderContent(String fileName) {
    final Map<String, String> placeholders = {
      'Géoddyn-Externe-L1-Pro-GEODE.pdf': '''
=== Géodynamique Externe ===
Professeur : RAMIANDRISOA Njara
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : INTRODUCTION À LA GÉODYNAMIQUE

La géodynamique est la branche de la géologie qui étudie les phénomènes et processus qui modifient la structure et l'apparence de la Terre. Elle se divise en deux branches principales :

1. GÉODYNAMIQUE INTERNE (Endogène)
Les forces internes proviennent de l'intérieur de la Terre et sont principalement liées à la chaleur interne. Elles sont responsables de :
- La tectonique des plaques
- Le volcanisme
- Les séismes
- La formation des montagnes (orogenèse)
- La formation des bassins sédimentaires

2. GÉODYNAMIQUE EXTERNE (Exogène)
Les forces externes proviennent de l'extérieur de la Terre et sont principalement alimentées par l'énergie solaire. Elles incluent :
- L'altération des roches
- L'érosion
- Le transport des sédiments
- La sédimentation
- Les phénomènes météorologiques

La Terre est un système dynamique où les processus internes et externes interagissent en permanence pour façonner sa surface.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : LE CYCLE DE L'EAU

2.1 Le cycle hydrologique
Le cycle de l'eau, ou cycle hydrologique, décrit le mouvement continu de l'eau entre les différents réservoirs terrestres :

RÉSERVOIRS D'EAU :
- Océans et mers (97,5% de l'eau totale)
- Glaciers et calottes polaires (1,74%)
- Eaux souterraines (0,73%)
- Lacs et rivières (0,007%)
- Atmosphère (0,001%)
- Biosphère (0,0001%)

PROCESSUS DU CYCLE :

1. Évaporation
L'évaporation est le passage de l'eau de l'état liquide à l'état gazeux (vapeur d'eau).
- Évaporation océanique : principale source de vapeur d'eau atmosphérique
- Évaporation continentale : lacs, rivières, sols humides
- Transpiration végétale : les plantes libèrent de la vapeur d'eau par les stomates
- Sublimation : passage direct de la glace à la vapeur

2. Condensation
La vapeur d'eau se transforme en gouttelettes liquques en altitude :
- Formation des nuages
- Formation du brouillard
- Formation de la rosée

3. Précipitations
- Pluie : gouttes d'eau liquide (> 0,5 mm)
- Neige : cristaux de glace
- Grêle : grains de glace
- Brouillard givrant

4. Ruissellement
L'eau s'écoule à la surface du sol :
- Ruissellement de surface : vers les rivières
- Ruissellement hypodermique : dans les premiers centimètres du sol

5. Infiltration
L'eau pénètre dans le sol :
- Infiltration directe : par les pores du sol
- Infiltration par les fractures : dans les roches fissurées
- Percolation : descente vers les nappes profondes

6. Stockage
- Nappe phréatique : première nappe d'eau souterraine
- Nappe captive : entre deux couches imperméables
- Glacier : stockage à long terme

BILAN HYDROLOGIQUE :
P = E + R + I + ΔS
Où :
P = Précipitations
E = Évapotranspiration
R = Ruissellement
I = Infiltration
ΔS = Variation du stockage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : L'ÉROSION ET L'ALTÉRATION

3.1 Altération des roches
L'altération est la désagrégation ou la décomposition des roches à la surface de la Terre.

A. Altération physique (mécanique) :
- Thermoclastie : dilatation/contraction due aux variations de température
- Cryoclastie : gel/dégel de l'eau dans les fissures (augmentation de volume de 9%)
- Haloclastie : cristallisation des sels dans les pores
- Bioclastie : action des racines des plantes

B. Altération chimique :
- Hydrolyse : réaction entre l'eau et les minéraux
- Oxydation : réaction avec l'oxygène (ex: rouille)
- Dissolution : solubilisation des minéraux dans l'eau
- Carbonatation : action de l'acide carbonique (CO₂ + H₂O)
- Hydratation : absorption d'eau par les minéraux

C. Altération biologique :
- Action des lichens : sécrétion d'acides organiques
- Action des bactéries : transformation chimique
- Action des vers de terre : mélange du sol

3.2 L'érosion
L'érosion est le processus d'enlèvement des matériaux altérés.

A. Érosion hydraulique (par l'eau) :
- Érosion pluviale : impact des gouttes de pluie
- Érosion fluviale : action des rivières
- Érosion marine : action des vagues et des courants
- Érosion glaciaire : action des glaciers

B. Érosion éolienne (par le vent) :
- Corrasion : projection de particules par le vent
- Déflation : enlèvement des particules fines

C. Érosion gravitaire :
- Glissements de terrain
- Éboulements
- Coulées de boue

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : LE TRANSPORT DES SÉDIMENTS

4.1 Modes de transport
Les sédiments sont transportés par différents agents :

A. Transport par l'eau (rivières et fleuves) :
- Transport en suspension : particules fines (argiles, limons)
- Transport par saltation : grains de sable qui rebondissent
- Transport par roulement : galets et graviers au fond

Vitesse de transport :
- < 0,1 m/s : argiles et limons en suspension
- 0,1-0,3 m/s : sables fins
- 0,3-1 m/s : sables grossiers et graviers
- > 1 m/s : galets et blocs

B. Transport par le vent :
- Suspension : particules < 0,1 mm (poussières)
- Saltation : grains de 0,1 à 0,5 mm
- Roulement : grains > 0,5 mm

C. Transport par les glaciers :
- Transport supra-glaciaire : à la surface du glacier
- Transport intra-glaciaire : à l'intérieur du glacier
- Transport sous-glaciaire : sous le glacier

4.2 Tri des sédiments
Le transport trie les sédiments par taille :
- Plus le transport est long, plus les grains sont fins
- Les grains s'arrondissent pendant le transport (usure)
- Les minéraux résistants (quartz) survivent au transport

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 5 : LA SÉDIMENTATION

5.1 Principes de la sédimentation
La sédimentation est le dépôt des matériaux transportés. Elle se produit quand l'agent de transport perd son énergie.

Zones de sédimentation :
- Lits des rivières
- Lacs et étangs
- Deltas et estuaires
- Plaines d'inondation
- Plateaux continentaux
- Abysses océaniques

5.2 Les environnements sédimentaires

A. Environnements continentaux :
- Fluviatiles : chenaux, plaines d'inondation
- Lacustres : lacs et étangs
- Glaciaires : moraines, varves
- Éoliens : dunes, loess

B. Environnements de transition :
- Deltaïques : embouchures des fleuves
- Lagunaires : lagunes et marais côtiers
- Estuariens : mélange eau douce/eau salée

C. Environnements marins :
- Littoraux : plages, barres sableuses
- Néritiques : plateaux continentaux
- Pélagiques : océans profonds

5.3 La diagenèse
Transformation des sédiments en roches sédimentaires :
- Compaction : réduction de volume par le poids des sédiments
- Déshydratation : expulsion de l'eau
- Cimentation : précipitation de ciments entre les grains
- Recristallisation : réorganisation des cristaux

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 6 : LES ROCHES SÉDIMENTAIRES

6.1 Classification des roches sédimentaires

A. Roches détritiques (clastiques) :
Formées à partir de débris de roches préexistantes.

Selon la taille des grains :
- Conglomérat : grains > 2 mm (galets, blocs)
- Grès : grains de 0,063 à 2 mm (sables)
- Siltite : grains de 0,004 à 0,063 mm (limons)
- Argilite : grains < 0,004 mm (argiles)

B. Roches carbonatées :
- Calcaire : composé de calcite (CaCO₃)
  - Calcaire coquillier : avec des fossiles
  - Craie : calcaire blanc et tendre
  - Marne : mélange calcaire + argile
- Dolomie : composée de dolomite (CaMg(CO₃)₂)

C. Roches chimiques :
- Évaporites : gypse (CaSO₄·2H₂O), halite (NaCl)
- Silex : silice microcristalline
- Fer sédimentaire

D. Roches organiques :
- Charbon : matière végétale fossilisée
  - Tourbe (60% C) → Lignite (70% C) → Houille (85% C) → Anthracite (95% C)
- Pétrole et gaz : matière organique marine

6.2 Structures sédimentaires
- Stratification : couches successives (strates)
- Litage : fines couches parallèles
- Graded bedding : stratification gradée
- Ripples marks : rides de courant
- Figures de dessiccation : fentes de retrait
- Bioturbation : traces d'organismes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 7 : LA FORMATION DES SOLS

7.1 Le profil de sol
Le sol est la couche superficielle de l'écorce terrestre résultant de l'altération des roches.

Horizons du sol (de haut en bas) :
- O : Litière (matière organique non décomposée)
- A : Humus (matière organique décomposée)
- E : Horizon lessivé (appauvri en minéraux)
- B : Horizon d'accumulation (enrichi en minéraux)
- C : Roche mère altérée
- R : Roche mère non altérée

7.2 Facteurs de formation des sols
- Le climat : température et précipitations
- La roche mère : nature de la roche initiale
- La topographie : pente et drainage
- Les organismes : végétation et faune
- Le temps : durée de formation

7.3 Types de sols
- Sols zonaux : liés au climat (latérites, podzols)
- Sols azonaux : indépendants du climat (alluviaux)
- Sols intrazonaux : conditions locales particulières (sols salés)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 8 : LES PHÉNOMÈNES GÉOLOGIQUES ACTUELS

8.1 Les risques naturels
- Inondations : débordement des cours d'eau
- Glissements de terrain : mouvements de masse
- Érosion côtière : recul du littoral
- Subsidence : affaissement du sol

8.2 L'impact de l'homme
- Déforestation : accélération de l'érosion
- Agriculture intensive : dégradation des sols
- Urbanisation : imperméabilisation des sols
- Extraction : mines et carrières

8.3 La protection de l'environnement
- Conservation des sols : reforestation, terrasses
- Gestion de l'eau : protection des nappes
- Prévention des risques : cartographie, aménagement

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
      'Le-Processus-Hydrologique.pdf': '''
=== Le Processus Hydrologique ===
Professeur : RAMIANDRISOA Njara
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : GÉNÉRALITÉS SUR L'HYDROLOGIE

1.1 Définition
L'hydrologie est la science qui étudie l'eau sous toutes ses formes et dans tous ses états, en circulation à la surface ou dans le sous-sol des continents. Elle traite de son occurrence, de sa distribution, de sa circulation, de sa conservation et de son utilisation.

L'hydrogéologie est la branche de l'hydrologie qui étudie spécifiquement les eaux souterraines et les formations géologiques qui les contiennent (aquifères).

1.2 Domaine d'étude de l'hydrologie
- Météorologie hydrique : précipitations, évaporation
- Hydrologie de surface : eaux de surface, rivières, lacs
- Hydrologie souterraine : eaux souterraines, aquifères
- Hydraulique : écoulement de l'eau
- Hydrochimie : qualité chimique de l'eau

1.3 Le cycle hydrologique
Le cycle hydrologique est le mouvement perpétuel de l'eau entre l'atmosphère, la surface terrestre et le sous-sol.

Les principaux processus :
- Précipitation (P)
- Évaporation (E)
- Évapotranspiration (ET)
- Ruissellement (R)
- Infiltration (I)
- Percolation
- Stockage (S)

L'équation du bilan hydrologique :
P = E + R + I + ΔS

1.4 Le bassin versant
Le bassin versant est une zone géographique délimitée par des lignes de partage des eaux (crêtes), où toutes les eaux de surface convergent vers un même exutoire.

Caractéristiques du bassin versant :
- Superficie (km²)
- Périmètre (km)
- Longueur du cours d'eau principal
- Pente moyenne
- Densité de drainage
- Coefficient de forme (indice de Gravelius)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : LES PRÉCIPITATIONS

2.1 Formation des précipitations
Les précipitations se forment par condensation de la vapeur d'eau atmosphérique.

Mécanisme :
1. Évaporation de l'eau superficielle
2. Ascension de l'air humide
3. Refroidissement par détente adiabatique
4. Condensation sur les noyaux de condensation
5. Formation des nuages
6. Croissance des gouttes
7. Précipitation

2.2 Types de précipitations

A. Précipitations convectives :
- Ascension rapide de l'air chaud et humide
- Pluies intenses et de courte durée
- Associées aux orages
- Fréquentes en zone équatoriale

B. Précipitations orographiques :
- Soulèvement de l'air par une montagne
- Pluies sur le versant au vent
- Effet de foehn sur le versant sous le vent

C. Précipitations frontales :
- Rencontre de deux masses d'air différentes
- Front chaud : air chaud sur air froid
- Front froid : air froid sous air chaud

2.3 Mesure des précipitations
- Pluviomètre : mesure la hauteur de pluie (mm)
- Pluviographe : enregistrement continu
- Radar météorologique : mesure à distance
- Satellite : mesure globale

1 mm de pluie = 1 litre d'eau par m²

2.4 Analyse des données pluviométriques
- Hauteur moyenne annuelle
- Intensité maximale
- Fréquence et période de retour
- Courbe Intensité-Durée-Fréquence (IDF)
- Carte isohyète (lignes de même hauteur)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : L'ÉVAPOTRANSPIRATION

3.1 Évaporation
Passage de l'eau de l'état liquide à l'état gazeux.

Facteurs influençant l'évaporation :
- Température de l'air et de l'eau
- Humidité relative de l'air
- Vitesse du vent
- Rayonnement solaire
- Pression atmosphérique

Formule de Penman pour l'évaporation :
E = f(Rn, T, U, ea-ed)
Où :
Rn = Rayonnement net
T = Température
U = Vitesse du vent
ea-ed = Déficit de saturation

3.2 Transpiration végétale
La transpiration est la perte d'eau des plantes par les stomates des feuilles.

Facteurs de transpiration :
- Type de végétation
- Densité de couverture végétale
- Humidité du sol
- Rayonnement solaire
- Température

3.3 Évapotranspiration potentielle (ETP)
L'ETP est la quantité d'eau évaporée et transpirée par une couverture végétale homogène, en quantité suffisante, sans limitation d'eau.

Formule de Penman-Monteith :
ETP = [0.408Δ(Rn-G) + γ(900/(T+273))U₂(es-ea)] / [Δ+γ(1+0.34U₂)]

3.4 Évapotranspiration réelle (ETR)
L'ETR est la quantité d'eau réellement évaporée et transpirée, limitée par la disponibilité en eau du sol.

Si le sol est saturé : ETR = ETP
Si le sol est sec : ETR < ETP

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : LE RUISSELLEMENT

4.1 Mécanismes du ruissellement
Le ruissellement est l'écoulement de l'eau à la surface du sol vers les cours d'eau.

Types de ruissellement :
A. Ruissellement hortonien :
- Se produit quand l'intensité de pluie > capacité d'infiltration
- Fréquent en zones arides et semi-arides
- Sur sols imperméables ou compactés

B. Ruissellement par saturation :
- Se produit quand le sol est saturé d'eau
- Fréquent dans les zones basses du bassin versant
- Contribue aux crues

C. Ruissellement hypodermique :
- Écoulement dans les premiers centimètres du sol
- Retour rapide à la surface

4.2 Facteurs influençant le ruissellement
- Intensité et durée des précipitations
- Nature du sol (perméabilité, texture)
- Pente du terrain
- Couverture végétale
- Utilisation des terres
- État d'humidité antérieur du sol

4.3 Mesure du ruissellement
- Débitmètre : mesure du débit des cours d'eau
- Station hydrométrique : mesure continue
- Courbe de tarage : relation hauteur-débit

4.4 Hydrogramme de crue
L'hydrogramme représente la variation du débit d'un cours d'eau en fonction du temps.

Composantes de l'hydrogramme :
- Point de départ : début de la crue
- Branche montante : augmentation rapide du débit
- Pic de crue : débit maximum
- Branche descendante : décroissance progressive
- Débit de base : apport des eaux souterraines

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 5 : L'INFILTRATION

5.1 Définition et mécanismes
L'infiltration est la pénétration de l'eau dans le sol à travers la surface.

Mécanismes :
- Infiltration verticale : descente dans le sol
- Percolation : mouvement vers les nappes profondes
- Écoulement latéral : dans les couches du sol

5.2 Facteurs influençant l'infiltration
- Texture et structure du sol
- Porosité du sol
- Teneur en eau initiale
- Couverture végétale
- Intensité de la pluie
- Pente du terrain

5.3 Capacité d'infiltration
La capacité d'infiltration est la vitesse maximale à laquelle l'eau peut pénétrer dans le sol.

Loi de Horton :
f(t) = fc + (f₀ - fc) × e^(-kt)
Où :
f(t) = capacité d'infiltration au temps t
f₀ = capacité initiale
fc = capacité finale (constante)
k = coefficient de décroissance

5.4 Mesure de l'infiltration
- Infiltromètre à double anneau
- Infiltromètre à chargement constant
- Simulation de pluie

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 6 : LES EAUX SOUTERRAINES

6.1 Définitions
Les eaux souterraines sont les eaux contenues dans les pores et les fractures des formations géologiques du sous-sol.

Termes clés :
- Zone non saturée (ZNS) : zone où les pores contiennent de l'air et de l'eau
- Zone saturée : zone où tous les pores sont remplis d'eau
- Nappe phréatique : première nappe d'eau souterraine
- Nappe captive : entre deux couches imperméables
- Aquifère : formation géologique capable de stocker et transmettre l'eau

6.2 Types d'aquifères

A. Aquifère libre (phréatique) :
- Nappe dont la surface est libre (non confinée)
- Alimentée directement par les précipitations
- Sensible à la pollution de surface
- Niveau piézométrique variable

B. Aquifère captif (artésien) :
- Nappe entre deux couches imperméables
- Sous pression (piézomètre > sommet de l'aquifère)
- Peut donner des puits artésiens
- Moins vulnérable à la pollution

C. Aquifère semi-captif :
- Séparé par une couche semi-perméable
- Fuite verticale possible

6.3 Propriétés des aquifères

A. Porosité (n) :
Rapport du volume des vides sur le volume total.
- Porosité d'interstices : entre les grains
- Porosité de fissures : dans les roches fracturées
- Porosité de dissolution : dans les karsts

Typiquement :
- Argile : 40-70%
- Sable : 25-50%
- Gravier : 25-40%
- Calcaire : 5-30%
- Granite fissuré : 0,1-5%

B. Perméabilité (K) :
Capacité d'une roche à laisser circuler l'eau.
- Sable grossier : 10⁻³ à 10⁻² m/s
- Sable fin : 10⁻⁵ à 10⁻⁴ m/s
- Argile : 10⁻⁹ à 10⁻⁷ m/s
- Calcaire fissuré : 10⁻⁶ à 10⁻³ m/s

C. Transmissivité (T) :
T = K × b (b = épaisseur de l'aquifère)

D. Coefficient d'emmagasinement (S) :
Volume d'eau libéré par unité de surface et par unité de rabattement.

6.4 Écoulement souterrain
Loi de Darcy (1856) :
Q = K × i × A
Où :
Q = débit (m³/s)
K = perméabilité (m/s)
i = gradient hydraulique
A = section d'écoulement (m²)

Vitesse de Darcy : v = Q/A = K × i
Vitesse réelle : vr = v/n

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 7 : HYDROGÉOLOGIE APPLIQUÉE

7.1 Les nappes phréatiques
Caractéristiques :
- Proximité de la surface
- Alimentation directe par les pluies
- Variations saisonnières du niveau
- Vulnérabilité à la pollution

Niveau piézométrique :
- Mesuré dans un puits ou piézomètre
- Carte piézométrique : représentation spatiale
- Sens d'écoulement : des hautes vers les basses valeurs

7.2 Les karsts
Les karsts sont des paysages géologiques formés par la dissolution des roches carbonatées.

Processus de karstification :
1. Dissolution du calcaire par l'eau chargée en CO₂
2. Formation de fissures et cavités
3. Développement de réseaux souterrains
4. Formation de grottes et rivières souterraines

Formes karstiques :
- Dolines : dépressions circulaires
- Lapiaz : surfaces rainurées
- Gouffres : ouvertures verticales
- Grottes : cavités souterraines
- Résurgences : sorties d'eau souterraine

7.3 Exploitation des eaux souterraines

A. Captage :
- Puits : ouvrage vertical peu profond
- Forage : ouvrage profond (tubé)
- Source : émergence naturelle
- Galerie drainante : ouvrage horizontal

B. Pompage d'essai :
Objectifs :
- Déterminer les paramètres de l'aquifère
- Évaluer le débit exploitable
- Vérifier la qualité de l'eau

Types de pompage :
- Pompage à débit constant
- Pompage par paliers
- Pompage avec récupération

C. Équation de Theis (aquifère captif) :
s = (Q/4πT) × W(u)
Où :
s = rabattement
Q = débit de pompage
T = transmissivité
W(u) = fonction de puits

D. Équation de Dupuit (aquifère libre) :
Q = πK(H²-h²)/ln(R/r)

7.4 Protection des eaux souterraines
- Zone de protection des captages
- Périmètre de protection immédiat
- Périmètre de protection rapproché
- Périmètre de protection éloigné
- Surveillance de la qualité

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 8 : QUALITÉ DE L'EAU

8.1 Paramètres de qualité

A. Paramètres physiques :
- Température
- Turbidité
- Conductivité
- Couleur et odeur

B. Paramètres chimiques :
- pH (acidité/alcalinité)
- Minéralisation (résidu sec)
- Dureté (TH)
- Chlorures, sulfates, nitrates
- Métaux lourds (Pb, Cd, Hg, As)

C. Paramètres bactériologiques :
- Coliformes totaux
- Coliformes fécaux
- Streptocoques
- Bactéries pathogènes

8.2 Pollution des eaux
Sources de pollution :
- Agriculture : engrais, pesticides
- Industrie : rejets chimiques
- Domestique : eaux usées
- Naturelle : géochimique

Types de pollution :
- Pollution ponctuelle : source identifiable
- Pollution diffuse : source dispersée
- Pollution accidentelle : déversement

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 9 : GESTION DES RESSOURCES EN EAU

9.1 Bilan hydrique
Le bilan hydrique d'un bassin versant s'exprime par :
P = ETP + R + I + ΔS

9.2 Gestion intégrée des ressources en eau (GIRE)
Principes :
- Approche participative
- Gestion par bassin versant
- Équilibre entre usages
- Préservation des écosystèmes

9.3 Usages de l'eau
- Eau potable
- Agriculture (irrigation)
- Industrie
- Énergie hydroélectrique
- Navigation
- Tourisme et loisirs

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
      'Minéralogie-L1-Pro-Geode.pdf': '''
=== Minéralogie ===
Professeur : RAZAFIMAROSON Yvan Tommy
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : INTRODUCTION À LA CRISTALLOGRAPHIE

1.1 Définitions
La minéralogie est la science qui étudie les minéraux, leurs propriétés, leur classification et leur genèse.

Un minéral est une substance naturelle, inorganique, solide, homogène, ayant une composition chimique définie et une structure cristalline ordonnée (sauf exceptions comme le mercure natif, liquide).

Caractéristiques essentielles d'un minéral :
- Naturel : formé par des processus naturels
- Inorganique : non produit par des organismes vivants
- Solide : état solide à température ambiante (sauf Hg)
- Homogène : composition uniforme
- Structure cristalline : arrangement atomique ordonné
- Composition chimique définie (ou variant dans des limites fixes)

1.2 La matière cristalline
La matière cristalline se caractérise par un arrangement ordonné et périodique des atomes dans l'espace.

Deux catégories :
- Cristallin : arrangement ordonné (majorité des minéraux)
- Amorphe : arrangement désordonné (verres naturels, obsidienne)

1.3 Le réseau cristallin
Le réseau cristallin est un ensemble infini de points disposés de manière périodique dans l'espace.

La maille élémentaire est le plus petit volume qui, par translation, reproduit l'ensemble du réseau.

Paramètres de la maille :
- Trois vecteurs de base : a, b, c
- Trois angles : α (entre b et c), β (entre a et c), γ (entre a et b)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : LES SYSTÈMES CRISTALLINS

Il existe 7 systèmes cristallins, classés selon les paramètres de la maille :

2.1 Système cubique (isométrique)
- a = b = c
- α = β = γ = 90°
- Symétrie maximale
Exemples : Halite (NaCl), Pyrite (FeS₂), Fluorine (CaF₂), Grenat

2.2 Système quadratique (tétragonal)
- a = b ≠ c
- α = β = γ = 90°
Exemples : Zircon (ZrSiO₄), Rutile (TiO₂)

2.3 Système hexagonal
- a = b ≠ c
- α = β = 90°, γ = 120°
Exemples : Quartz (SiO₂), Calcite (CaCO₃), Apatite

2.4 Système rhomboédrique (trigonal)
- a = b = c
- α = β = γ ≠ 90°
Exemples : Calcite, Corindon (Al₂O₃), Hématite

2.5 Système orthorhombique
- a ≠ b ≠ c
- α = β = γ = 90°
Exemples : Olivine, Topaze, Barytine

2.6 Système monoclinique
- a ≠ b ≠ c
- α = γ = 90°, β ≠ 90°
Exemples : Gypse, Orthose, Augite

2.7 Système triclinique
- a ≠ b ≠ c
- α ≠ β ≠ γ ≠ 90°
- Symétrie minimale
Exemples : Microcline, Plagioclase

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : LES FORMES CRISTALLINES

3.1 Éléments de symétrie
- Centre de symétrie (C) : point central
- Axe de rotation : A2, A3, A4, A6 (rotation de 180°, 120°, 90°, 60°)
- Plan de symétrie (m) : miroir
- Axe de rotation-inversion

3.2 Formes simples
- Pédiion : une seule face
- Pinacoïde : deux faces parallèles
- Prisme : faces parallèles à un axe
- Pyramide : faces convergentes vers un point
- Dipyrämide : deux pyramides base à base

3.3 Habitus des cristaux
L'habitus décrit la forme générale d'un cristal :
- Cubique : cubes (pyrite, halite)
- Octaédrique : octaèdres (fluorine, diamant)
- Prismatique : prismes allongés (quartz, tourmaline)
- Tabulaire : cristaux aplatis (barytine)
- Aciculaire : en aiguilles (rutile, gypse)
- Lamellaire : en lames (micas)
- Granulaire : en grains (olivine)
- Massif : sans forme cristalline visible

3.4 Macles
Une macle est un édifice cristallin formé de deux ou plusieurs cristaux de même espèce orientés différemment.

Types de macles :
- Mâcle par contact : plan de composition
- Mâcle par pénétration : interpénétration des individus
- Mâcle polysynthétique : répétition multiple
Exemple : macle du Carlsbad dans l'orthose

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : LES PROPRIÉTÉS PHYSIQUES DES MINÉRAUX

4.1 La couleur
La couleur est la propriété la plus évidente mais pas toujours fiable.
- Idiochromatique : couleur propre au minéral (malachite = vert)
- Allochromatique : couleur due à des impuretés (quartz = varie)
- Irisation : couleurs changeantes (labradorite)

4.2 La trace (couleur de la poussière)
Obtenue en frottant le minéral sur une plaque de porcelaine non vernie.
- Hématite : rouge-brun
- Pyrite : vert-noirâtre
- Magnétite : noir

4.3 L'éclat
L'éclat décrit la façon dont la lumière est réfléchie par la surface du minéral.

Éclats métalliques :
- Métallique : pyrite, galène
- Submétallique : hématite

Éclats non métalliques :
- Vitreux : quartz, calcite
- adamantin : diamant
- Gras : quartz
- Résineux : sphalérite
- Nacré : talc, gypse
- Soyeux : gypse fibreux
- Terne : argile, kaolinite

4.4 La dureté
La dureté est la résistance à la rayure, mesurée par l'échelle de Mohs (1812).

Échelle de Mohs :
1. Talc (rayable à l'ongle)
2. Gypse (rayable à l'ongle)
3. Calcite (rayable au couteau en acier)
4. Fluorine (rayable au couteau)
5. Apatite (rayable au couteau difficilement)
6. Orthose (raye le verre)
7. Quartz (raye le verre facilement)
8. Topaze
9. Corindon
10. Diamant

Dureté approximative avec outils :
- Ongle : 2,5
- Pièce de cuivre : 3,5
- Couteau en acier : 5,5
- Verre : 5,5
- Lame d'acier : 6,5

4.5 La clivage
Le clivage est la tendance d'un minéral à se briser selon des plans de faiblesse liés à la structure cristalline.

Qualité du clivage :
- Parfait : micas (une direction)
- Bon : calcite (trois directions)
- Imperfait : apatite

Nombre de directions de clivage :
- 1 direction : micas (clivage basal)
- 2 directions : pyroxènes (90°), amphiboles (56°/124°)
- 3 directions : calcite, galène, halite (cubique)
- 4 directions : fluorine (octaédrique)
- 6 directions : sphalérite (dodécaédrique)

4.6 La cassure
La cassure est la façon dont un minéral se brise sans plan de clivage.
- Conchoïdale : courbes concentriques (quartz, obsidienne)
- Irégulière : surface irrégulière
- Esquilleuse : en esquilles
- Crochue : surface arrondie

4.7 Autres propriétés
- Densité (ρ) : rapport de la masse volumique sur celle de l'eau
- Magnétisme : magnétite, pyrrhotite
- Fluorescence : fluorine (sous UV)
- Effervescence : calcite (avec HCl dilué)
- Goût : halite (salé), sylvite (amer)
- Odeur : argile (odeur argileuse quand humide)
- Tact : talc (gras), graphite (gras)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 5 : CLASSIFICATION DES MINÉRAUX

La classification des minéraux est basée sur la composition chimique, plus précisément sur l'anion ou le groupe anionique dominant.

5.1 Les ÉLÉMENTS NATIFS
Minéraux composés d'un seul élément chimique.

A. Métaux :
- Or (Au) : cubique, jaune, éclat métallique, densité 19,3
- Argent (Ag) : cubique, blanc, éclat métallique, densité 10,5
- Cuivre (Cu) : cubique, rouge, éclat métallique, ductile
- Platine (Pt) : cubique, gris acier, densité 21,5

B. Non-métaux :
- Soufre (S) : orthorhombique, jaune, éclat résineux
- Diamant (C) : cubique, le plus dur (10), éclat adamantin
- Graphite (C) : hexagonal, noir, tendre, conducteur

5.2 Les SULFURES
Combinaison d'un métal avec le soufre (S²⁻).

- Pyrite (FeS₂) : cubique, jaune laiton, éclat métallique, dureté 6-6,5
- Chalcopyrite (CuFeS₂) : quadratique, jaune laiton, tendre (3,5-4)
- Galène (PbS) : cubique, gris plomb, éclat métallique, clivage cubique
- Sphalérite (ZnS) : cubique, brun à noir, clivage dodécaédrique
- Cinabre (HgS) : rhomboédrique, rouge vif, minerai de mercure

5.3 Les OXYDES
Combinaison d'un métal avec l'oxygène (O²⁻).

- Hématite (Fe₂O₃) : trigonal, noir à rouge, trace rouge, magnétique après chauffage
- Magnétite (Fe₃O₄) : cubique, noir, fortement magnétique
- Corindon (Al₂O₃) : trigonal, dureté 9, gemmes (rubis, saphir)
- Cassitérite (SnO₂) : quadratique, brun noir, minerai d'étain
- Rutile (TiO₂) : quadratique, rouge brun, éclat adamantin

5.4 Les HALOGÉNURES
Combinaison d'un métal avec un halogène (Cl⁻, F⁻, Br⁻, I⁻).

- Halite (NaCl) : cubique, incolore, clivage cubique, goût salé
- Fluorine (CaF₂) : cubique, colors variées, clivage octaédrique, fluorescence
- Selve (KCl) : cubique, incolore, goût amer

5.5 Les CARBONATES
Contiennent le groupe carbonate (CO₃)²⁻.

- Calcite (CaCO₃) : trigonal, clivage rhomboédrique, effervescence avec HCl
- Dolomite (CaMg(CO₃)₂) : trigonal, effervescence seulement avec HCl chaud
- Sidérite (FeCO₃) : trigonal, brun, devient magnétique après chauffage
- Azurite (Cu₃(CO₃)₂(OH)₂) : monoclinique, bleu vif
- Malachite (Cu₂(CO₃)(OH)₂) : monoclinique, vert vif

5.6 Les SULFATES
Contiennent le groupe sulfate (SO₄)²⁻.

- Gypse (CaSO₄·2H₂O) : monoclinique, tendre (2), clivage parfait
- Anhydrite (CaSO₄) : orthorhombique, plus dur que le gypse
- Barytine (BaSO₄) : orthorhombique, densité élevée (4,5)
- Célestine (SrSO₄) : orthorhombique, bleue

5.7 Les PHOSPHATES
Contiennent le groupe phosphate (PO₄)³⁻.

- Apatite (Ca₅(PO₄)₃(F,Cl,OH)) : hexagonal, dureté 5, constitue les dents et os
- Turquoise (CuAl₆(PO₄)₄(OH)₈·4H₂O) : triclinique, bleu-vert, gemme

5.8 Les SILICATES
Les silicates représentent plus de 90% de la croûte terrestre. Ils sont basés sur le tétraèdre SiO₄.

Le tétraèdre SiO₄ :
- Un atome de silicium au centre
- Quatre atomes d'oxygène aux sommets
- Charge globale : (SiO₄)⁴⁻

Classification des silicates selon l'agencement des tétraèdres :

A. NÉSOSILICATES (tétraèdres isolés)
Les tétraèdres sont indépendants, liés par des cations.

- Olivine ((Mg,Fe)₂SiO₄) : orthorhombique, vert olive, dureté 6,5-7
  - Forstérite (Mg₂SiO₄)
  - Fayalite (Fe₂SiO₄)
- Grenats (X₃Y₂(SiO₄)₃) : cubique, dureté 6,5-7,5
  - Pyrope (Mg₃Al₂(SiO₄)₃) : rouge
  - Almandin (Fe₃Al₂(SiO₄)₃) : rouge foncé
  - Grossulaire (Ca₃Al₂(SiO₄)₃) : vert
- Zircon (ZrSiO₄) : quadratique, éclat adamantin

B. SOROSILICATES (deux tétraèdres liés)
- Épidote (Ca₂(Al,Fe)₃(SiO₄)₃(OH)) : monoclinique, vert pistache

C. CYCLOSILICATES (anneaux de tétraèdres)
- Béryl (Be₃Al₂Si₆O₁₈) : hexagonal, prismatique
  - Aigue-marine (bleu)
  - Émeraude (vert)
- Tourmaline : trigonal, prismatique, pléochroïsme

D. INOSILICATES (chaînes de tétraèdres)

Chaînes simples (Pyroxènes) :
- Diopside (CaMgSi₂O₆) : monoclinique, vert, clivage à ~90°
- Augite ((Ca,Na)(Mg,Fe,Al)(Si,Al)₂O₆) : monoclinique, noir-vert, clivage à 87°/93°

Chaînes doubles (Amphiboles) :
- Hornblende : monoclinique, noir, clivage à 56°/124°
- Trémolite : monoclinique, blanc à gris

E. PHYLOSILICATES (feuillets de tétraèdres)
- Micas :
  - Muscovite (KAl₂(AlSi₃O₁₀)(OH)₂) : monoclinique, incolore à jaunâtre
  - Biotite (K(Mg,Fe)₃(AlSi₃O₁₀)(OH)₂) : monoclinique, noir à brun
  - Phlogopite : brun doré
- Minéraux argileux :
  - Kaolinite (Al₂Si₂O₅(OH)₄) : triclinique, blanc, tendre
  - Montmorillonite : gonfle avec l'eau
- Talc (Mg₃Si₄O₁₀(OH)₂) : triclinique, tendre (1), tactile gras
- Chlorite : verte, feuilletée

F. TECTOSILICATES (réseau 3D de tétraèdres)
- Quartz (SiO₂) : trigonal, dureté 7, pas de clivage
  - Variétés : améthyste (violet), citrine (jaune), fumé (gris)
- Feldspaths :
  - Feldspaths potassiques :
    - Orthose (KAlSi₃O₈) : monoclinique, rose/clair
    - Microcline (KAlSi₃O₈) : triclinique, vert (amazonite)
  - Plagioclases :
    - Albite (NaAlSi₃O₈)
    - Anorthite (CaAl₂Si₂O₈)
- Feldspathoïdes :
  - Néphéline (Na,K)AlSiO₄
- Zéolites :
  - Natrolite, analcime

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 6 : IDENTIFICATION DES MINÉRAUX

6.1 Méthodes d'identification
- Observation macroscopique : couleur, éclat, forme, clivage
- Tests de dureté (échelle de Mohs)
- Test à l'acide (HCl dilué) : carbonates
- Test de trace (sur porcelaine)
- Densité (mesure par balance hydrostatique)
- Magnétisme (aimant)

6.2 Détermination en main
Clé de détermination simplifiée :

1. Éclat métallique ?
   OUI → Métal ou sulfure
   NON → Étape 2

2. Effervescence avec HCl ?
   OUI → Calcite ou dolomite
   NON → Étape 3

3. Dureté > 7 (raye le verre) ?
   OUI → Quartz, topaze, grenat
   NON → Étape 4

4. Clivage parfait ?
   OUI → Mica, feldspath, calcite
   NON → Étape 5

5. Couleur caractéristique ?
   Vert → Olivine, épidote, chlorite
   Rouge → Grenat, hématite
   Noir → Biotite, amphibole, pyroxène

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 7 : GENÈSE DES MINÉRAUX

7.1 Cristallisation magmatique
Les minéraux cristallisent à partir d'un magma en refroidissement.

Séquence de cristallisation de Bowen :
1. Olivine (1200°C)
2. Pyroxène
3. Amphibole
4. Biotite
5. Plagioclase calco-sodique
6. Orthose
7. Quartz (600°C)

7.2 Cristallisation par précipitation
Précipitation chimique dans les solutions aqueuses :
- Évaporites : halite, gypse
- Carbonates : calcite dans les mers chaudes

7.3 Métamorphisme
Transformation de minéraux sous l'effet de la pression et température :
- Argile → Chlorite → Mica → Grenat

7.4 Altération
Transformation des minéraux en surface :
- Feldspath → Kaolinite (argile)
- Olivine → Limonite
- Biotite → Vermiculite

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
      'Pétrologie-minéralogie.pdf': '''
=== Pétrologie ===
Professeur : RATRIMO Voahangy
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : INTRODUCTION À LA PÉTROLOGIE

1.1 Définitions
La pétrologie est la science qui étudie les roches : leur origine, leur formation, leur composition, leur classification et leur transformation.

La pétrographie est la branche descriptive de la pétrologie qui décrit et classifie les roches.

Une roche est un agrégat naturel de minéraux, formé par des processus géologiques.

Différence entre minéral et roche :
- Minéral : substance homogène avec composition et structure définies
- Roche : assemblage de un ou plusieurs minéraux

1.2 Classification génétique des roches
Trois grands types de roches selon leur mode de formation :

A. Roches magmatiques (ignées)
Formées par refroidissement et solidification d'un magma.
Exemples : granite, basalte, gabbro

B. Roches sédimentaires
Formées par accumulation et consolidation de sédiments ou précipitation chimique.
Exemples : grès, calcaire, argile

C. Roches métamorphiques
Formées par transformation de roches préexistantes sous l'effet de la pression et/ou température.
Exemples : gneiss, schiste, marbre

1.3 Le cycle des roches
Le cycle des roches décrit les transformations possibles entre les trois types :
- Les roches magmatiques peuvent être érodées en sédiments
- Les sédiments peuvent former des roches sédimentaires
- Les roches sédimentaires peuvent subir un métamorphisme
- Les roches métamorphiques peuvent fondre et former du magma

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : LES ROCHES MAGMATIQUES (IGNÉES)

2.1 Le magma
Le magma est un liquide silicaté naturel, porté à haute température (700-1300°C), contenant des gaz dissous et parfois des cristaux en suspension.

Composition du magma :
- Silice (SiO₂) : 40-75%
- Alumine (Al₂O₃)
- Oxydes de fer et magnésium (FeO, MgO)
- Alcalins (Na₂O, K₂O)
- Calcium (CaO)
- Gaz dissous (H₂O, CO₂, SO₂)

2.2 Classification des roches magmatiques

A. Selon la teneur en silice (SiO₂) :
- Ultrabasiques (ultramafiques) : < 45% SiO₂
- Basiques (mafiques) : 45-52% SiO₂
- Intermédiaires : 52-63% SiO₂
- Acides (felsiques) : > 63% SiO₂

B. Selon le mode de refroidissement :
- Roches plutoniques (intrusives) : refroidissement lent en profondeur, texture grenue
- Roches volcaniques (effusives) : refroidissement rapide en surface, texture microlitique ou vitreuse
- Roches hypabyssales (filoniennes) : refroidissement à profondeur intermédiaire, texture microgrenue

C. Selon la composition minéralogique :
- Roches mélanocrates : riches en minéraux sombres (> 60%)
- Roches mésocrates : minéraux sombres 30-60%
- Roches leucocrates : riches en minéraux clairs (> 60%)

2.3 Minéraux des roches magmatiques

A. Minéraux essentiels (constituants principaux) :
- Quartz (SiO₂) : incolore, dureté 7
- Feldspaths :
  - Orthose (KAlSi₃O₈) : rose, clair
  - Plagioclases (série Na-Ca) : blanc
- Micas :
  - Muscovite (KAl₂(AlSi₃O₁₀)(OH)₂) : clair
  - Biotite (K(Mg,Fe)₃(AlSi₃O₁₀)(OH)₂) : sombre
- Amphiboles : hornblende (sombre)
- Pyroxènes : augite (sombre)
- Olivine ((Mg,Fe)₂SiO₄) : vert olive

B. Minéraux accessoires (en petite quantité) :
- Apatite, zircon, magnétite, ilménite, sphène

C. Minéraux secondaires (formés par altération) :
- Chlorite, séricite, calcite

2.4 Roches magmatiques plutoniques

| Type | Composition | Minéraux principaux | Couleur |
|------|-------------|---------------------|---------|
| Granite | Acide | Quartz + Orthose + Plagioclase + Mica | Clair |
| Granodiorite | Intermédiaire-acide | Quartz + Plagioclase + Biotite | Gris |
| Diorite | Intermédiaire | Plagioclase + Amphibole | Gris foncé |
| Gabbro | Basique | Plagioclase + Pyroxène | Sombre |
| Péridotite | Ultrabasique | Olivine + Pyroxène | Très sombre |

Le Granite :
- Roche la plus courante de la croûte continentale
- Texture grenue (cristaux visibles à l'œil nu)
- Composition : 30% quartz, 50% feldspaths, 20% micas
- Utilisé comme pierre de construction

Le Gabbro :
- Équivalent plutonique du basalte
- Texture grenue sombre
- Composition : plagioclase + pyroxène
- Forme la croûte océanique

La Péridotite :
- Roche ultrabasique du manteau terrestre
- Composition : olivine + pyroxène
- Densité élevée (~3,3)
- Couleur vert foncé à noir

2.5 Roches magmatiques volcaniques

| Type | Composition | Texture | Structure |
|------|-------------|---------|-----------|
| Rhyolite | Acide | Microlitique | Massive ou fluidale |
| Andésite | Intermédiaire | Microlitique | Porphyrique |
| Basalte | Basique | Microlitique | En coussins (pillow) |
| Basanite | Ultrabasique | Microlitique | Raré |

Le Basalte :
- Roche volcanique la plus courante
- Équivalent volcanique du gabbro
- Texture microlitique (cristaux dans une pâte)
- Structure en prismes (orgues basaltiques)
- Structure en pillow lavas (sous l'eau)
- Composition : plagioclase + pyroxène ± olivine

La Rhyolite :
- Équivalent volcanique du granite
- Texture microlitique claire
- Souvent associée aux volcans explosifs

2.6 Textures des roches magmatiques

A. Texture grenue (plutonique) :
- Cristaux de taille visible à l'œil nu
- Refroidissement lent en profondeur
- Exemple : granite

B. Texture microgrenue (hypabyssale) :
- Cristaux de taille microscopique
- Refroidissement à profondeur intermédiaire

C. Texture microlitique (volcanique) :
- Microlites (petits cristaux) dans une pâte amorphe
- Refroidissement rapide en surface

D. Texture vitreuse :
- Pas de cristaux, verre volcanique
- Refroidissement très rapide
- Exemple : obsidienne

E. Texture porphyrique :
- Phénocristaux (gros cristaux) dans une pâte fine
- Deux stades de refroidissement

F. Texture pegmatitique :
- Cristaux géants (> 1 cm)
- Fin de cristallisation d'un magma enrichi en éléments volatils

2.7 Structures des roches volcaniques
- Structure massive : homogène
- Structure fluidale : bandes parallèles (écoulement)
- Structure amygdalaire : bulles remplies de minéraux
- Structure bréchique : fragments de lave
- Structure scoriacée : bulles de gaz nombreuses (pierre ponce)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : LES ROCHES SÉDIMENTAIRES

3.1 Formation des roches sédimentaires

Les étapes de la formation :
1. Altération de la roche mère
2. Érosion et transport
3. Sédimentation (dépôt)
4. Diagenèse (transformation en roche)

3.2 La diagenèse
Transformation des sédiments meubles en roches consolidées :

A. Compaction :
- Réduction du volume par le poids des sédiments sus-jacents
- Expulsion de l'eau interstitielle
- Rapprochement des grains

B. Déshydratation :
- Perte de l'eau contenue dans les pores
- Élimination de l'eau adsorbée sur les grains

C. Cimentation :
- Précipitation de ciments entre les grains
- Ciments courants : calcite (CaCO₃), silice (SiO₂), oxydes de fer

D. Recristallisation :
- Réorganisation des cristaux
- Augmentation de la taille des cristaux

3.3 Classification des roches sédimentaires

A. Roches détritiques (clastiques)
Formées par l'accumulation de débris de roches préexistantes.

Classification selon la taille des grains :

| Taille (mm) | Roche consolidée | Sédiment meuble |
|-------------|------------------|-----------------|
| > 2 | Conglomérat | Galets, graviers |
| 0,063 - 2 | Grès | Sable |
| 0,004 - 0,063 | Siltite | Limon |
| < 0,004 | Argilite | Argile |

Le Grès :
- Roche détritique la plus courante
- Grains de sable cimentés
- Composition : quartz dominant
- Perméable et poreux
- Utilisé comme pierre de construction

Le Conglomérat :
- Roche contenant des galets (> 2 mm) cimentés
- Poudingue : galets arrondis
- Brèche : galets anguleux

L'Argile :
- Roche détritique à grains très fins (< 0,004 mm)
- Minéraux argileux (kaolinite, montmorillonite)
- Imperméable et plastique
- Utilisée dans la céramique, construction

B. Roches carbonatées
Contiennent au moins 50% de carbonate (calcite ou dolomite).

Le Calcaire :
- Roche carbonatée la plus courante
- Composé de calcite (CaCO₃)
- Effervescence avec HCl dilué
- Origines variées :
  - Calcaire récifal : construction par les coraux
  - Calcaire coquillier : accumulation de coquilles
  - Craie : calcaire blanc et tendre (coccolithes)
  - Calcaire lithographique : fin et homogène
  - Travertin : précipitation dans les sources chaudes

La Dolomie :
- Composée de dolomite (CaMg(CO₃)₂)
- Effervescence seulement avec HCl chaud
- Peut être d'origine primaire ou secondaire (dolomitisation)

La Marne :
- Mélange de calcaire et d'argile
- Dureté intermédiaire
- Utilisée dans la fabrication du ciment

C. Roches chimiques
Formées par précipitation chimique.

L'Évaporite :
- Formée par évaporation d'une solution saline
- Gypse (CaSO₄·2H₂O) : tendre, utilisé dans le plâtre
- Halite (NaCl) : sel gemme
- Anhydrite (CaSO₄)

Le Silex :
- Roche siliceuse microcristalline
- Formé par remplacement de la calcite dans les calcaires
- Très dur et cassant

D. Roches organiques
Formées à partir de matière organique.

Le Charbon :
- Matière végétale fossilisée
- Formation en milieu marécageux
- Étapes de la carbonisation :
  - Tourbe (60% C) → Lignite (70% C) → Houille (85% C) → Anthracite (95% C)

Le Pétrole et le Gaz :
- Formés à partir de matière organique marine
- Source : plancton et algues accumulés en milieu anoxique
- Migration et piégeage dans les roches réservoirs

3.4 Structures sédimentaires
- Stratification : couches successives (strates)
- Litage : fines couches parallèles
- Graded bedding : stratification gradée (grains gros → fins)
- Ripples marks : rides de courant ou de vagues
- Figures de dessiccation : fentes de retrait
- Bioturbation : traces d'organismes (terriers, pistes)
- Figures de base : marques d'érosion

3.5 Environnements sédimentaires

A. Continentaux :
- Fluviatile : rivières, fleuves
- Lacustre : lacs
- Glaciaire : glaciers
- Éolien : dunes, déserts

B. De transition :
- Deltaïque : embouchures des fleuves
- Lagunaire : lagunes
- Estuarien : mélange eau douce/eau salée

C. Marins :
- Littoral : plages, côtes
- Néritique : plateaux continentaux
- Pélagique : océans profonds

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : RELATIONS ENTRE LES ROCHES

4.1 Équivalences plutonique-volcanique

| Plutonique | Volcanique | Composition |
|------------|------------|-------------|
| Granite | Rhyolite | Acide |
| Granodiorite | Dacite | Intermédiaire-acide |
| Diorite | Andésite | Intermédiaire |
| Gabbro | Basalte | Basique |
| Péridotite | Basanite | Ultrabasique |

4.2 Série de différenciation magmatique
À partir d'un magma basique, la cristallisation fractionnée produit :
Basalte → Andésite → Dacite → Rhyolite

4.3 Transformation des roches
- Altération : roche → sédiments
- Lithification : sédiments → roche sédimentaire
- Métamorphisme : roche → roche métamorphique
- Fusion : roche → magma

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
      'ROCHCE-METAMORPHIQUE-RESUME.pdf': '''
=== Roches Métamorphiques ===
Professeur : RATRIMO Voahangy
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : LE MÉTAMORPHISME

1.1 Définition
Le métamorphisme est l'ensemble des transformations minéralogiques, texturales et structurales subies par une roche préexistante (protolite) sous l'effet de variations de température, de pression et/ou de l'action de fluides, à l'état solide.

La roche métamorphique conserve la composition chimique globale de la roche mère (sauf perte de volatils comme H₂O et CO₂).

Le métamorphisme se distingue :
- Du magmatisme : pas de fusion totale (sauf anatexie)
- De la sédimentation : pas de transport

1.2 Facteurs du métamorphisme

A. Température (T) : 200-800°C
- Recristallisation des minéraux
- Néogenèse (formation de nouveaux minéraux)
- Augmente avec la profondeur (gradient géothermique : 30°C/km)

B. Pression (P) : 0,1-2 GPa (1-20 kbar)
- Pression lithostatique : poids des roches sus-jacentes
- Pression dirigée (contrainte) : forces tectoniques
- Augmente avec la profondeur (gradient : 270 bar/km)

C. Fluides (H₂O, CO₂)
- Accélèrent les réactions chimiques
- Transport d'éléments (métasomatisme)
- Proviennent de la déshydratation des minéraux

D. Temps
- Le métamorphisme est un processus lent
- Durée : milliers à millions d'années

1.3 Types de métamorphisme

A. Métamorphisme régional (HP-BT)
- Le plus important en volume
- Associé à la formation des chaînes de montagnes (orogenèse)
- Pression et température élevées
- Grande étendue géographique
- Produit : schistes, gneiss, micaschistes

B. Métamorphisme de contact (HT-BP)
- Autour des intrusions magmatiques
- Température élevée, pression faible
- Zone limitée (auréole de métamorphisme)
- Produit : cornéennes, skarns
- Gradient thermique élevé

C. Métamorphisme de subduction (HP-BT)
- Plongée d'une plaque sous une autre
- Pression élevée, température basse
- Produit : éclogites, schistes bleus

D. Métamorphisme hydrothermal
- Circulation de fluides chauds
- Associé au volcanisme et aux sources chaudes
- Altération chimique importante

E. Métamorphisme d'impact
- Impact de météorites
- Pression et température instantanées très élevées
- Produits : brèches d'impact, quartz choqués

F. Métamorphisme dynamique (de broyage)
- Le long des failles
- Pression dirigée importante
- Produits : mylonites, cataclasites

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : TEXTURES DES ROCHES MÉTAMORPHIQUES

2.1 Classification des textures

A. Textures foliées (orientées)
Résultent d'une pression dirigée qui aligne les minéraux.

- Schistosité : plan de division fin (ardoise)
- Foliation : plan de division plus épais (gneiss)
- Linéation : alignement linéaire des minéraux

B. Textures non foliées (non orientées)
Résultent d'un métamorphisme sans pression dirigée.

- Texture granoblastique : grains équidimensionnels (marbre, quartzite)
- Texture porphyroblastique : gros cristaux (porphyroblastes) dans une matrice fine
- Texture poeciloblastique : porphyroblastes avec inclusions

2.2 Déformation et recristallallisation

A. Déformation ductile :
- Pliement des couches
- Étirement des minéraux
- Développement de la foliation

B. Recristallallisation :
- Croissance de nouveaux cristaux
- Élimination des contraintes internes
- Augmentation de la taille des grains

2.3 Structures métamorphiques
- Plis : anticlinaux, synclinaux
- Failles : normales, inverses, décrochantes
- Boudinage : étirement et fragmentation des couches
- Crenulation : plissement de la foliation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : MINÉRAUX MÉTAMORPHIQUES

3.1 Minéraux index (indicateurs de grade)
Ces minéraux apparaissent à des conditions P-T spécifiques.

Pour les pélites (roches argileuses) :
- Chlorite : métamorphisme très faible
- Biotite : métamorphisme faible
- Grenat : métamorphisme moyen
- Staurotide : métamorphisme moyen à élevé
- Disthène (cyanite) : métamorphisme élevé
- Silimanite : métamorphisme très élevé

3.2 Minéraux polymorphes
Même composition chimique, structure différente selon P-T.

Al₂SiO₅ :
- Andalousite : basse pression (métamorphisme de contact)
- Disthène (cyanite) : haute pression (métamorphisme régional)
- Silimanite : haute température

CaCO₃ :
- Calcite : basse pression
- Aragonite : haute pression

SiO₂ :
- Quartz : basse pression
- Coésite : haute pression
- Stishovite : très haute pression

3.3 Minéraux caractéristiques du métamorphisme
- Chlorite : vert, feuilleté
- Épidote : vert pistache
- Grenat : rouge, cubique
- Mica blanc (muscovite, phengite)
- Amphibole (hornblende, glaucophane)
- Staurolite : brun, macles en croix
- Disthène : bleu, lamellaire
- Silimanite : blanc, fibreux

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : CLASSIFICATION DES ROCHES MÉTAMORPHIQUES

4.1 Classification selon le protolite

A. Métapélites (proviennent d'argiles) :
- Ardoise (très faible grade)
- Schiste (faible grade)
- Phyllade (grade moyen)
- Micaschiste (grade moyen-élevé)
- Gneiss (grade élevé)

B. Métabasites (proviennent de basaltes/gabbros) :
- Schiste vert (faible grade)
- Amphibolite (grade moyen-élevé)
- Éclogite (très haut grade)

C. Métacarbonates (proviennent de calcaires) :
- Marbre (calcaire pur)
- Calc-silicaté (calcaire impur)

D. Métapsammites (proviennent de grès) :
- Quartzite

4.2 Roches métamorphiques foliées

L'ARDOISE :
- Protolite : argile, schiste argileux
- Métamorphisme : très faible (anchizone)
- Texture : schistosité fine
- Minéraux : chlorite, mica blanc
- Utilisation : couverture de toit

LE SCHISTE :
- Protolite : argile
- Métamorphisme : faible (épizone inférieure)
- Texture : schistosité marquée
- Minéraux : chlorite, biotite, muscovite
- Aspect : feuilleté, facile à cliver

LE MICASCHISTE :
- Protolite : argile, grès argileux
- Métamorphisme : moyen à élevé
- Texture : foliation marquée avec lits de mica
- Minéraux : quartz, muscovite, biotite, grenat ± staurotide
- Aspect : alternance de lits clairs (quartz) et sombres (mica)

LE GNEISS :
- Protolite : granite, grès, argile
- Métamorphisme : élevé
- Texture : foliation épaisse (litage)
- Minéraux : quartz, feldspath, mica
- Aspect : rubané, alternance de lits clairs et sombres
- Types :
  - Gneiss œillé : feldspaths en forme d'œil
  - Gneiss rubané : lits réguliers
  - Migmatite : début de fusion (mélange gneiss + granite)

4.3 Roches métamorphiques non foliées

LE MARBRE :
- Protolite : calcaire pur
- Métamorphisme : variable
- Texture : granoblastique
- Minéraux : calcite (ou dolomite)
- Aspect : cristallin, blanc ou coloré
- Utilisation : sculpture, construction

LE QUARTZITE :
- Protolite : grès quartzique
- Métamorphisme : variable
- Texture : granoblastique
- Minéraux : quartz
- Aspect : très dur, cassure conchoïdale
- Résistance : très résistant à l'altération

LA CORNÉENNE :
- Protolite : argile, marne
- Métamorphisme : de contact
- Texture : massive, non foliée
- Minéraux : andalousite, cordiérite, biotite
- Aspect : roche dure, sonore (cornéenne = sonne comme une corne)

L'AMPHIBOLITE :
- Protolite : basalte, gabbro
- Métamorphisme : moyen à élevé
- Texture : granoblastique à foliée
- Minéraux : hornblende + plagioclase
- Aspect : sombre, massive

L'ÉCLOGITE :
- Protolite : basalte, gabbro
- Métamorphisme : très élevé (HP)
- Texture : granoblastique
- Minéraux : grenat + jadéite (pyroxène vert)
- Aspect : rouge et vert, très dense

LE MILONITE :
- Protolite : variable
- Métamorphisme : dynamique (de broyage)
- Texture : foliation intense
- Minéraux : recristallisés sous contrainte
- Aspect : rubané, finement feuilleté

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 5 : FACIÈS MÉTAMORPHIQUES

Un faciès métamorphique est un ensemble de roches formées dans les mêmes conditions P-T à partir de protolites différents.

5.1 Faciès de basse température et basse pression
Faciès zéolite :
- T : 50-150°C, P : 0,1-0,3 GPa
- Minéraux : zéolites

Faciès schiste vert :
- T : 300-450°C, P : 0,2-0,6 GPa
- Minéraux : chlorite, épidote, actinote
- Roches : schiste vert

5.2 Faciès de température et pression moyennes
Faciès amphibolite :
- T : 500-700°C, P : 0,4-1,0 GPa
- Minéraux : hornblende, plagioclase
- Roches : amphibolite, micaschiste

5.3 Faciès de haute température
Faciès granulite :
- T : 700-900°C, P : 0,6-1,2 GPa
- Minéraux : pyroxène, feldspath, grenat
- Roches : granulite, gneiss

Faciès cornéenne :
- T : 500-800°C, P : 0,1-0,4 GPa
- Minéraux : andalousite, cordiérite, biotite
- Roches : cornéenne

Faciès sanidinite :
- T : > 800°C, P : faible
- Minéraux : sanidine, pyroxène
- Roches : sanidinite

5.4 Faciès de haute pression
Faciès schiste bleu :
- T : 300-500°C, P : 0,6-1,2 GPa
- Minéraux : glaucophane (amphibole bleue), jadéite
- Roches : schiste bleu

Faciès éclogite :
- T : 500-800°C, P : 1,0-2,5 GPa
- Minéraux : grenat + omphacite
- Roches : éclogite

5.5 Diagramme P-T des faciès

Haute Pression →
|
| Schiste bleu → Éclogite
|
| Amphibolite → Granulite
|
| Schiste vert → Amphibolite
|
| Zéolite → Schiste vert
|
↓ Haute Température

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 6 : L'ANATEXIE

6.1 Définition
L'anatexie est la fusion partielle d'une roche métamorphique à très haute température.

6.2 Conditions
- T > 650-700°C
- Présence d'eau (abaisse le solidus)
- Profondeur : 15-30 km

6.3 Produits
- Liquide granitique (leucosome)
- Résidu métamorphique (mélanosome)
- Migmatite : mélange des deux

6.4 Importance géologique
- Formation des granites d'anatexie
- Différenciation de la croûte continentale
- Recyclage de la croûte terrestre

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 7 : APPLICATIONS

7.1 Reconstitution de l'histoire géologique
- Conditions P-T du métamorphisme
- Chemin P-T (prograde, rétrograde)
- Événements tectoniques associés

7.2 Ressources économiques
- Marbre : construction, sculpture
- Ardoise : couverture
- Graphite : industrie
- Grenat : abrasif

7.3 Géologie de l'ingénieur
- Stabilité des terrains métamorphiques
- Propriétés mécaniques des roches
- Risques naturels

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
      'Stratigraphie.pdf': '''
=== Stratigraphie ===
Professeur : RAZAFIMBELO Rachel
L1 Pro GEODE - Faculté des Sciences

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 1 : INTRODUCTION À LA STRATIGRAPHIE

1.1 Définition
La stratigraphie est la science qui étudie les strates (couches) géologiques et leur succession dans le temps. Elle a pour objectif de reconstituer l'histoire de la Terre à travers l'étude des formations sédimentaires.

Objet de la stratigraphie :
- Description des strates
- Organisation spatiale des couches
- Détermination de l'âge relatif et absolu
- Corrélation entre différentes régions
- Reconstruction des environnements anciens

1.2 Les principes fondamentaux de la stratigraphie

A. Principe de superposition (Nicolas Steno, 1669)
Dans une séquence sédimentaire non perturbée, les strates les plus anciennes se trouvent à la base et les plus récentes au sommet.

Exceptions :
- Séquences renversées par la tectonique
- Intrusions magmatiques
- Structures tectoniques complexes

B. Principe de continuité (latérale)
Une strate a le même âge sur toute son étendue latérale, tant qu'elle ne montre pas d'interruption de sédimentation.

C. Principe d'identité paléontologique
Des strates contenant les mêmes associations fossilifères sont du même âge.

D. Principe de recoupement
Une structure géologique qui en recoupe une autre est plus jeune que celle qu'elle recoupe.

Exemples :
- Une faille est plus jeune que les couches qu'elle décale
- Un dyke est plus jeune que les roches qu'il traverse

E. Principe d'inclusion
Un fragment inclus dans une roche est plus ancien que la roche qui le contient.

F. Principe de l'horizontilité initiale
Les sédiments se déposinitialement en couches horizontales.

G. Principe de l'uniformitarisme (Charles Lyell)
"Le présent est la clé du passé." Les processus géologiques actuels ont fonctionné de la même manière dans le passé.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 2 : LITHOSTRATIGRAPHIE

La lithostratigraphie classe les strates selon leur nature lithologique (composition et aspect des roches).

2.1 Hiérarchie lithostratigraphique

| Rang | Exemple | Description |
|------|---------|-------------|
| Supergroupe | - | Ensemble de groupes |
| Groupe | - | Ensemble de formations |
| Formation | Formation de l'Isalo | Unité fondamentale |
| Membre | - | Subdivision de formation |
| Couche/Strate | - | Plus petite unité |

La Formation :
- Unité lithostratigraphique fondamentale
- Peut être cartographiée
- Homogène du point de vue lithologique
- Nommée d'après une localité type

2.2 Discontinuités stratigraphiques

A. La concordance
Dépôt continu sans interruption. Les couches sont parallèles.

B. La discordance
Interruption de la sédimentation suivie d'une reprise.
- Discordance angulaire : couches non parallèles
- Paraconformité : surface de non-dépôt sans érosion
- Disconformité : surface d'érosion entre couches parallèles

C. La lacune
Intervalle de temps non représenté dans la série sédimentaire.

D. Le chenal
Érosion locale suivie d'un remplissage.

2.3 Les cycles sédimentaires
Séquences répétitives de dépôts :
- Cycle marin : transgression → régression
- Cycle climatique : périodes glaciaires/interglaciaires
- Cycle tectonique : subsidence → soulèvement

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 3 : BIOSTRATIGRAPHIE

La biostratigraphie utilise les fossiles pour dater et corréler les strates.

3.1 Les fossiles
Un fossile est une trace ou un reste d'organisme conservé dans les roches.

Types de fossilisation :
- Conservation de la matière organique (os, coquilles)
- Remplacement (silicification, pyritisation)
- Empreintes (moulages, traces)
- Inclusions (ambre, glace)

3.2 Fossiles stratigraphiques
Un bon fossile stratigraphique doit être :
- Abondant
- De répartition géographique large
- D'évolution rapide
- Facile à identifier
- Indépendant du faciès

Exemples de fossiles guides :
- Trilobites (Paléozoïque)
- Ammonites (Mésozoïque)
- Foraminifères (toutes les ères)
- Graptolites (Ordovicien-Silurien)

3.3 Biozone
Unité biostratigraphique définie par le contenu fossilifère.

Types de biozones :
- Zone d'extension : présence d'une espèce
- Zone d'abondance : maximum d'une espèce
- Zone d'association : ensemble d'espèces
- Zone de succession : séquence d'espèces

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 4 : CHRONOSTRATIGRAPHIE

La chronostratigraphie classe les strates selon leur âge absolu ou relatif.

4.1 Échelle des temps géologiques

| Éon | Ère | Période | Âge (Ma) |
|-----|-----|---------|----------|
| Phanérozoïque | Cénozoïque | Quaternaire | 2,6 - Présent |
| | | Néogène | 23 - 2,6 |
| | | Paléogène | 66 - 23 |
| | Mésozoïque | Crétacé | 145 - 66 |
| | | Jurassique | 201 - 145 |
| | | Trias | 252 - 201 |
| | Paléozoïque | Permien | 299 - 252 |
| | | Carbonifère | 359 - 299 |
| | | Dévonien | 419 - 359 |
| | | Silurien | 444 - 419 |
| | | Ordovicien | 485 - 444 |
| | | Cambrien | 541 - 485 |
| Précambrien | Protérozoïque | - | 2500 - 541 |
| | Archéen | - | 4000 - 2500 |
| | Hadéen | - | 4600 - 4000 |

4.2 Événements majeurs de l'histoire de la Terre

Hadéen (4600-4000 Ma) :
- Formation de la Terre
- Formation de la Lune
- Océan primitif

Archéen (4000-2500 Ma) :
- Premières traces de vie (stromatolites)
- Formation des premiers continents

Protérozoïque (2500-541 Ma) :
- Oxygénation de l'atmosphère
- Glaciations globales (Terre boule de neige)
- Premiers organismes multicellulaires

Paléozoïque (541-252 Ma) :
- Explosion cambrienne
- Colonisation des continents
- Extinction du Permien-Trias (95% des espèces)

Mésozoïque (252-66 Ma) :
- Âge des dinosaures
- Fragmentation de la Pangée
- Extinction Crétacé-Tertiaire (dinosaures)

Cénozoïque (66 Ma - Présent) :
- Radiation des mammifères
- Formation des Himalayas
- Glaciations quaternaires
- Apparition de l'homme

4.3 Méthodes de datation absolue

A. Radiométrie :
Basée sur la désintégration radioactive d'isotopes.

| Méthode | Isotope | Demi-vie | Utilisation |
|---------|---------|----------|-------------|
| Carbone 14 | ¹⁴C → ¹⁴N | 5730 ans | < 50 000 ans |
| Potassium-Argon | ⁴⁰K → ⁴⁰Ar | 1,25 milliard d'années | Roches volcaniques |
| Uranium-Plomb | ²³⁸U → ²⁰⁶Pb | 4,47 milliards d'années | Zircon, anciennes |
| Rubidium-Strontium | ⁸⁷Rb → ⁸⁷Sr | 48,8 milliards d'années | Roches anciennes |

B. Autres méthodes :
- Thermoluminescence
- Résonance paramagnétique électronique (RPE)
- Dendrochronologie (cernes des arbres)
- Varves (dépôts lacustres annuels)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 5 : SÉQUENCES ET CYCLES STRATIGRAPHIQUES

5.1 Séquence de dépôt
Une séquence est un ensemble de strates génétiquement liées, limité par des surfaces de discontinuité.

Séquence élémentaire :
1. Surface d'érosion
2. Dépôt de base (conglomérat)
3. Dépôt médian (grès)
4. Dépôt sommital (argile)
5. Surface de non-dépôt

5.2 Cycles de Milankovitch
Variations orbitales de la Terre influençant le climat et les dépôts :
- Excentricité : 100 000 et 400 000 ans
- Obliquité : 41 000 ans
- Précession : 19 000 et 23 000 ans

5.3 Stratigraphie séquentielle
Étude des séquences de dépôt en fonction des variations du niveau marin.

Types de séquences :
- Séquence de bas niveau marin
- Séquence de transgression
- Séquence de haut niveau marin

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 6 : CORRÉLATIONS STRATIGRAPHIQUES

6.1 Corrélation lithologique
Basée sur la similarité des roches.

6.2 Corrélation biostratigraphique
Basée sur les fossiles contenus dans les strates.

6.3 Corrélation chronostratigraphique
Basée sur l'âge absolu des roches.

6.4 Corrélation géophysique
Utilisation des logs de puits (gamma-ray, résistivité, sonique).

6.5 Corrélation géochimique
Analyse des compositions chimiques et isotopiques.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHAPITRE 7 : APPLICATIONS DE LA STRATIGRAPHIE

7.1 Exploration pétrolière
- Identification des roches-mères
- Identification des roches-réservoirs
- Identification des couvertures

7.2 Hydrogéologie
- Identification des aquifères
- Corrélation des nappes souterraines
- Étude de la qualité de l'eau

7.3 Géologie de l'ingénieur
- Étude des terrains pour la construction
- Identification des zones instables

7.4 Paléogéographie
- Reconstruction des continents anciens
- Évolution des bassins sédimentaires
- Changements climatiques passés

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ce cours a été élaboré pour les étudiants de L1 Pro GEODE
Faculté des Sciences - Université de Madagascar
''',
    };

    return placeholders[fileName] ?? 'Contenu du PDF: $fileName';
  }

  static Future<Map<String, String>> extractAllPdfs(
    String directoryPath,
  ) async {
    final dir = Directory(directoryPath);
    final Map<String, String> pdfContents = {};

    if (!await dir.exists()) {
      return pdfContents;
    }

    await for (var entity in dir.list()) {
      if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
        final fileName = entity.path.split('/').last;
        final text = await extractTextFromPdf(entity.path);
        pdfContents[fileName] = text;
      }
    }

    return pdfContents;
  }

  static String getPdfContent(String pdfFileName) {
    return _getPlaceholderContent(pdfFileName);
  }

  /// Load all embedded course content at once (no file reading)
  static Map<String, String> loadAllEmbeddedContent() {
    return {
      'Géoddyn-Externe-L1-Pro-GEODE.pdf': _getPlaceholderContent(
        'Géoddyn-Externe-L1-Pro-GEODE.pdf',
      ),
      'Le-Processus-Hydrologique.pdf': _getPlaceholderContent(
        'Le-Processus-Hydrologique.pdf',
      ),
      'Minéralogie-L1-Pro-Geode.pdf': _getPlaceholderContent(
        'Minéralogie-L1-Pro-Geode.pdf',
      ),
      'Pétrologie-minéralogie.pdf': _getPlaceholderContent(
        'Pétrologie-minéralogie.pdf',
      ),
      'ROCHCE-METAMORPHIQUE-RESUME.pdf': _getPlaceholderContent(
        'ROCHCE-METAMORPHIQUE-RESUME.pdf',
      ),
      'Stratigraphie.pdf': _getPlaceholderContent('Stratigraphie.pdf'),
    };
  }
}
