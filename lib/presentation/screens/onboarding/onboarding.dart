import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  int numOfTabs = 4;

  final List<String> titles = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];
  final List<String> descriptions = [
    'This is the first tab description.',
    'This is the second tab description.',
    'This is the third tab description.',
    'This is the fourth tab description.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    numOfTabs,
                    (index) => buildIndicator(index, context),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: numOfTabs,
                itemBuilder: (context, index) {
                  return OnBoardingPage(
                    title: titles[index],
                    description: descriptions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int index, BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: _currentPage >= index ? Colors.white : Colors.white.withOpacity(0.50),
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final String title;
  final String description;

  const OnBoardingPage(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: Image(
                        image: AssetImage('assets/drawables/image_one.png')))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
