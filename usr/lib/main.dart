import 'package:flutter/material.dart';

void main() {
  runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
  const PresentationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exposé Contrôle de Gestion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 18, height: 1.5),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PresentationHomePage(),
      },
    );
  }
}

class PresentationHomePage extends StatefulWidget {
  const PresentationHomePage({super.key});

  @override
  State<PresentationHomePage> createState() => _PresentationHomePageState();
}

class _PresentationHomePageState extends State<PresentationHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _slides = [
    const TitleSlide(),
    const IntroSlide(),
    const LimitsSlideOne(),
    const LimitsSlideTwo(),
    const CostsIntroSlide(),
    const RealCostSlide(),
    const StandardCostSlide(),
    const StandardPlusForfaitSlide(),
    const ConclusionSlide(),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide ${_currentPage + 1} / ${_slides.length}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _pageController.jumpToPage(0),
            tooltip: 'Recommencer',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: _slides,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentPage > 0)
            FloatingActionButton(
              onPressed: _previousPage,
              heroTag: 'prev',
              child: const Icon(Icons.arrow_back),
            ),
          const SizedBox(width: 16),
          if (_currentPage < _slides.length - 1)
            FloatingActionButton(
              onPressed: _nextPage,
              heroTag: 'next',
              child: const Icon(Icons.arrow_forward),
            ),
        ],
      ),
    );
  }
}

// --- Slide Widgets ---

class SlideLayout extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final IconData? icon;

  const SlideLayout({
    super.key,
    required this.title,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Center(child: Icon(icon, size: 64, color: Theme.of(context).primaryColor)),
                const SizedBox(height: 20),
              ],
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  final String? subText;

  const BulletPoint({super.key, required this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 12, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (subText != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subText!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 1. Title Slide
class TitleSlide extends StatelessWidget {
  const TitleSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideLayout(
      title: 'Limites des Centres de Responsabilités\n&\nLes 3 Types de Coûts',
      icon: Icons.analytics,
      content: [
        const Center(
          child: Text(
            'Présentation Interactive',
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

// 2. Intro Slide
class IntroSlide extends StatelessWidget {
  const IntroSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: 'Introduction',
      content: [
        BulletPoint(
          text: 'Contexte',
          subText: 'Le contrôle de gestion utilise des centres de responsabilités pour décentraliser la décision.',
        ),
        BulletPoint(
          text: 'Problématique',
          subText: 'Ce système a des limites et nécessite des outils de calcul de coûts adaptés (Réel, Standard, Forfait).',
        ),
      ],
    );
  }
}

// 3. Limits Part 1
class LimitsSlideOne extends StatelessWidget {
  const LimitsSlideOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: 'Limites des Centres de Responsabilités (1/2)',
      icon: Icons.warning_amber_rounded,
      content: [
        BulletPoint(
          text: 'Vision Locale vs Globale',
          subText: 'Risque de sous-optimisation : un responsable optimise son centre au détriment de l\'entreprise globale.',
        ),
        BulletPoint(
          text: 'Conflits Inter-centres',
          subText: 'Tensions sur les prix de cession interne ou l\'allocation des ressources partagées.',
        ),
      ],
    );
  }
}

// 4. Limits Part 2
class LimitsSlideTwo extends StatelessWidget {
  const LimitsSlideTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: 'Limites des Centres de Responsabilités (2/2)',
      icon: Icons.error_outline,
      content: [
        BulletPoint(
          text: 'Court-termisme',
          subText: 'Pression sur les résultats immédiats au détriment des investissements futurs (R&D, formation).',
        ),
        BulletPoint(
          text: 'Rigidité',
          subText: 'Difficulté à s\'adapter aux changements rapides de l\'environnement si les objectifs sont figés.',
        ),
      ],
    );
  }
}

// 5. Costs Intro
class CostsIntroSlide extends StatelessWidget {
  const CostsIntroSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: 'Les 3 Types de Coûts',
      icon: Icons.monetization_on,
      content: [
        Center(
          child: Text(
            'Pour piloter ces centres, nous utilisons différentes méthodes de calcul de coûts :',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        BulletPoint(text: '1. Coût Réel'),
        BulletPoint(text: '2. Coût Standard'),
        BulletPoint(text: '3. Standard + Forfait'),
      ],
    );
  }
}

// 6. Real Cost
class RealCostSlide extends StatelessWidget {
  const RealCostSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: '1. Le Coût Réel',
      content: [
        BulletPoint(
          text: 'Définition',
          subText: 'Calculé à partir des charges effectivement constatées dans la comptabilité.',
        ),
        BulletPoint(
          text: 'Avantages',
          subText: 'Précis, vérifiable, reflète la vérité historique.',
        ),
        BulletPoint(
          text: 'Limites',
          subText: 'Connu trop tard (a posteriori). Varie avec le volume d\'activité, rendant les comparaisons difficiles.',
        ),
      ],
    );
  }
}

// 7. Standard Cost
class StandardCostSlide extends StatelessWidget {
  const StandardCostSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: '2. Le Coût Standard',
      content: [
        BulletPoint(
          text: 'Définition',
          subText: 'Coût préétabli calculé à l\'avance selon des normes techniques et économiques (Objectif).',
        ),
        BulletPoint(
          text: 'Utilité',
          subText: 'Sert de référence pour calculer les écarts (Réel - Standard).',
        ),
        BulletPoint(
          text: 'Principe',
          subText: 'Coût Standard = Quantité Standard x Prix Standard.',
        ),
      ],
    );
  }
}

// 8. Standard + Forfait
class StandardPlusForfaitSlide extends StatelessWidget {
  const StandardPlusForfaitSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: '3. Standard + Forfait',
      icon: Icons.calculate,
      content: [
        BulletPoint(
          text: 'Concept (Budget Flexible)',
          subText: 'Distinction entre charges variables (Standard) et charges fixes (Forfait).',
        ),
        BulletPoint(
          text: 'Formule',
          subText: 'Budget = (Coût Variable Unitaire x Activité Réelle) + Forfait de Charges Fixes.',
        ),
        BulletPoint(
          text: 'Avantage',
          subText: 'Permet d\'adapter le budget au niveau d\'activité réel pour une évaluation plus juste du responsable.',
        ),
      ],
    );
  }
}

// 9. Conclusion
class ConclusionSlide extends StatelessWidget {
  const ConclusionSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      title: 'Conclusion',
      icon: Icons.check_circle_outline,
      content: [
        BulletPoint(
          text: 'Synthèse',
          subText: 'Les centres de responsabilités sont essentiels mais imparfaits.',
        ),
        BulletPoint(
          text: 'Solution',
          subText: 'L\'utilisation combinée des coûts standards et des budgets flexibles (Standard + Forfait) permet de corriger ces limites en offrant un pilotage plus dynamique et équitable.',
        ),
      ],
    );
  }
}
