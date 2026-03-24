import 'dart:async';
import 'package:flutter/material.dart';
import 'package:por2/Deteils.dart';
import 'package:por2/all_beach.dart';
import 'package:por2/card_beach.dart';
import 'package:por2/model.dart';
import 'package:por2/api_server.dart';
import 'package:por2/providerfov.dart';
import 'package:por2/providertoerated.dart';
import 'package:por2/search.dart';
import 'package:provider/provider.dart';

class MyAutoSlider extends StatefulWidget {
  MyAutoSlider({super.key});

  @override
  State<MyAutoSlider> createState() => _MyAutoSliderState();
}

class _MyAutoSliderState extends State<MyAutoSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool isFavorite = false;
  List<Beach> beache = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BeachProvider>(context, listen: false).fetchBeaches();
      Provider.of<TopRatedBeachProvider>(
        context,
        listen: false,
      ).fetchTopRatedBeaches();
    });
    // مؤقت لتغيير الصفحة تلقائيًا
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (!_pageController.hasClients) return;
      if (_currentPage < sliderData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beachProvider = Provider.of<BeachProvider>(context);
    final topRatedProvider = Provider.of<TopRatedBeachProvider>(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await beachProvider.refreshBeaches();
          await topRatedProvider.fetchTopRatedBeaches();
        },
        child: CustomScrollView(
          slivers: [
            // ---------------- البحث + السلايدر ----------------
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(
                              Icons.search,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "بحث عن الشواطئ...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      itemCount: sliderData.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(sliderData[index]["image"]!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                            Positioned(
                              bottom: 25,
                              right: 20,
                              child: Text(
                                sliderData[index]["text"]!,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      sliderData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 5),
                        height: 8,
                        width: _currentPage == index ? 25 : 12,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.lightBlue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // ---------------- الشواطئ الأعلى تقييمًا ----------------
            if (topRatedProvider.topRatedBeaches.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "الشواطئ الأعلى تقييمًا",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topRatedProvider.topRatedBeaches.length,
                        itemBuilder: (context, index) {
                          final beach = topRatedProvider.topRatedBeaches[index];
                          double rated = beach.getPercentage();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BeachDetailsPage(beach: beach,ne: rated,),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              height: 300,

                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                        child: Image.network(
                                          beach.imageUrl,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          // لإظهار لودر أثناء تحميل الصورة من النت
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Container(
                                                  height: 120,
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, StackTrace) {
                                                return Container(
                                                  height: 120,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFFFFD700,
                                            ), // أصفر ذهبي
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                ("${beach.rating}"),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Consumer<FavoriteProvider>(
                                          builder:
                                              (context, favProvider, child) {
                                                bool isFavorite = favProvider
                                                    .isFavorite(beach);

                                                return IconButton(
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: isFavorite
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    favProvider.toggleFavorite(
                                                      beach,
                                                    );
                                                  },
                                                );
                                              },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          beach.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(beach.location),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.beach_access_outlined,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'مظلة . كراسي',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.refresh,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                ("${beach.price}"),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // ---------------- الشواطئ العادية ----------------
            SliverToBoxAdapter(
  child: SizedBox(
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      // 0: العنوان، 1-3: الشواطئ
      itemCount: (beachProvider.beaches.length >= 3
          ? 4
          : beachProvider.beaches.length + 1),

      itemBuilder: (context, index) {

        // --- الجزء الأول: العنوان ---
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllBeachesScreen(),
                    ),
                  ),
                  child: const Text(
                    "المزيد <",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Text(
                  "استكشاف الشواطئ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // --- الجزء الثاني: عرض أول 3 شواطئ ---
        if (index >= 1 && index <= beachProvider.beaches.length) {

          final beach = beachProvider.beaches[index - 1];
          double la = beach.getPercentage();

          return BeachCard(
            beachs: beach,
            pre: la,
          );
        }

        return const SizedBox(); // للأمان
      },
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
