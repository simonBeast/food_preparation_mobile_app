import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeScreen({required this.recipe});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> with TickerProviderStateMixin {
  int currentStep = 0;

  late AnimationController _fadeController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _buttonScale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeController.forward();
    _buttonController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _changeStep(int newStep) async {
    await _fadeController.reverse();
    setState(() => currentStep = newStep);
    _fadeController.forward();
    _buttonController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    var steps = widget.recipe['steps'] as List<dynamic>;
    bool atFirst = currentStep == 0;
    bool atLast = currentStep == steps.length - 1;
    var step = steps[currentStep] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero).animate(_fadeAnimation),
            child: Text(
              widget.recipe['name'],
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (step['verified'] ?? false)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.verified, color: Theme.of(context).colorScheme.onPrimary),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Step indicator with animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                steps.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedScale(
                    scale: currentStep == index ? 1.4 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentStep == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        boxShadow: currentStep == index
                            ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Animation and step content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        step['animationUrl'],
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 16),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_fadeAnimation),
                      child: Column(
                        children: [
                          Text(
                            'Step ${currentStep + 1}: ${step['title']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              step['description'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Navigation buttons
            ScaleTransition(
              scale: _buttonScale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: atFirst ? null : () => _changeStep(currentStep - 1),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Back', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                  Text(
                    '${currentStep + 1}/${steps.length}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: atLast
                        ? () => Navigator.pop(context)
                        : () => _changeStep(currentStep + 1),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      atLast ? 'Finish' : 'Next',
                      style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
