import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

/// Example page demonstrating various JetCarousel configurations.
@RoutePage()
class CarouselExamplePage extends HookConsumerWidget {
  const CarouselExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carouselController = useState(JetCarouselController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('JetCarousel Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Basic Carousel
            _buildSectionTitle('1. Basic Carousel'),
            _buildBasicCarousel(),
            const SizedBox(height: 32),

            // Example 2: Auto-Play Carousel
            _buildSectionTitle('2. Auto-Play Carousel'),
            _buildAutoPlayCarousel(),
            const SizedBox(height: 32),

            // Example 3: Carousel with Custom Indicator
            _buildSectionTitle('3. Custom Indicator Styles'),
            _buildCustomIndicatorCarousel(),
            const SizedBox(height: 32),

            // Example 4: Carousel with Controller
            _buildSectionTitle('4. Carousel with Controller'),
            _buildControlledCarousel(carouselController.value),
            const SizedBox(height: 16),
            _buildCarouselControls(carouselController.value),
            const SizedBox(height: 32),

            // Example 5: Infinite Scroll Disabled
            _buildSectionTitle('5. Without Infinite Scroll'),
            _buildNoInfiniteScrollCarousel(),
            const SizedBox(height: 32),

            // Example 6: Vertical Carousel
            _buildSectionTitle('6. Vertical Carousel'),
            _buildVerticalCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Example 1: Basic Carousel
  Widget _buildBasicCarousel() {
    final items = [
      CarouselItem(
        color: Colors.blue.shade300,
        title: 'Item 1',
        description: 'This is the first item',
      ),
      CarouselItem(
        color: Colors.green.shade300,
        title: 'Item 2',
        description: 'This is the second item',
      ),
      CarouselItem(
        color: Colors.orange.shade300,
        title: 'Item 3',
        description: 'This is the third item',
      ),
      CarouselItem(
        color: Colors.purple.shade300,
        title: 'Item 4',
        description: 'This is the fourth item',
      ),
    ];

    return JetCarousel<CarouselItem>(
      items: items,
      height: 200,
      indicatorOptions: const JetCarouselIndicatorOptions(
        position: IndicatorPosition.overlay,
        effect: JetIndicatorEffect.slide,
         
      ),
      builder: (context, index, item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onChange: (index) {
        debugPrint('Current page: $index');
      },
      onTap: (index, item) {
        debugPrint('Tapped on ${item.title}');
      },
    );
  }

  // Example 2: Auto-Play Carousel
  Widget _buildAutoPlayCarousel() {
    final items = List.generate(
      5,
      (index) => CarouselItem(
        color: Colors.primaries[index % Colors.primaries.length],
        title: 'Slide ${index + 1}',
        description: 'Auto-plays every 3 seconds',
      ),
    );

    return JetCarousel<CarouselItem>(
      items: items,
      height: 200,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      indicatorOptions: const JetCarouselIndicatorOptions(),
      builder: (context, index, item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Example 3: Custom Indicator Carousel
  Widget _buildCustomIndicatorCarousel() {
    final items = List.generate(
      4,
      (index) => CarouselItem(
        color: Colors.teal.shade300,
        title: 'Card ${index + 1}',
        description: 'Expanding dots indicator',
      ),
    );

    return JetCarousel<CarouselItem>(
      items: items,
      height: 200,
      builder: (context, index, item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      indicatorOptions: const JetCarouselIndicatorOptions(
        position: IndicatorPosition.bottom,
        dotSize: 10,
        spacing: 12,
        effect: JetIndicatorEffect.expanding,
      ),
    );
  }

  // Example 4: Controlled Carousel
  Widget _buildControlledCarousel(JetCarouselController controller) {
    final items = List.generate(
      6,
      (index) => CarouselItem(
        color: Colors.indigo.shade300,
        title: 'Page ${index + 1}',
        description: 'Use buttons to control',
      ),
    );

    return JetCarousel<CarouselItem>(
      items: items,
      height: 200,
      controller: controller,
      builder: (context, index, item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      indicatorOptions: const JetCarouselIndicatorOptions(
        effect: JetIndicatorEffect.jumping,
      ),
    );
  }

  Widget _buildCarouselControls(JetCarouselController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => controller.previousPage(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Previous'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => controller.jumpToPage(0),
          icon: const Icon(Icons.first_page),
          label: const Text('First'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => controller.nextPage(),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Next'),
        ),
      ],
    );
  }

  // Example 5: No Infinite Scroll
  Widget _buildNoInfiniteScrollCarousel() {
    final items = List.generate(
      3,
      (index) => CarouselItem(
        color: Colors.red.shade300,
        title: 'Slide ${index + 1}',
        description: 'No infinite scroll',
      ),
    );

    return JetCarousel<CarouselItem>(
      items: items,
      height: 200,
      enableInfiniteScroll: false,
      builder: (context, index, item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try swiping to the edges',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Example 6: Vertical Carousel
  Widget _buildVerticalCarousel() {
    final items = List.generate(
      4,
      (index) => CarouselItem(
        color: Colors.cyan.shade300,
        title: 'Vertical ${index + 1}',
        description: 'Swipe up/down',
      ),
    );

    return SizedBox(
      height: 400,
      child: JetCarousel<CarouselItem>(
        items: items,
        scrollDirection: Axis.vertical,
        builder: (context, index, item) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.swap_vert,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        indicatorOptions: const JetCarouselIndicatorOptions(
          position: IndicatorPosition.overlay,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16),
          effect: JetIndicatorEffect.scrolling,
        ),
      ),
    );
  }
}

/// Model class for carousel items.
class CarouselItem {
  final Color color;
  final String title;
  final String description;

  CarouselItem({
    required this.color,
    required this.title,
    required this.description,
  });
}
