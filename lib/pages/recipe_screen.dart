import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeScreen({required this.recipe});


  @override
  _RecipeScreenState createState() => _RecipeScreenState();

}

class _RecipeScreenState extends State<RecipeScreen> with SingleTickerProviderStateMixin {
  int currentStep = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeStep(int newStep) {
    setState(() {
      _animationController.reset();
      currentStep = newStep;
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    var steps = widget.recipe['steps'] as List<dynamic>;
    bool atFirst = currentStep == 0;
    bool atLast = currentStep == steps.length - 1;
    var step = steps[currentStep] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['name'],style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                steps.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep == index ? Theme.of(context).colorScheme.primary : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Lottie.asset(
                    step['animationUrl'],
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.2),
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
                  Text(
                    step['description'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: atFirst
                      ? null
                      : () => _changeStep(currentStep - 1),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Back', style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.onPrimary)),
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
                  child: Text(atLast ? 'Finish' : 'Next', style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}