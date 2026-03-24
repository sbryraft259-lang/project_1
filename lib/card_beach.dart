import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:por2/Deteils.dart';
import 'package:por2/providerfov.dart';
import 'package:provider/provider.dart';
import 'model.dart';

  class BeachCard extends StatelessWidget {
    final Beach beachs;
    double? pre;

    BeachCard({super.key, required this.beachs, this.pre});

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BeachDetailsPage(beach: beachs, ne: pre),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      beachs.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // التقييم
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "${beachs.rating}",
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
                                                      .isFavorite(beachs);

                                                  return IconButton(
                                                    icon: Icon(
                                                      isFavorite
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
                                                      color: isFavorite
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      favProvider.toggleFavorite(
                                                        beachs,
                                                      );
                                                    },
                                                  );
                                                },
                                          ),
                                        ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الشاطئ
                      Text(
                        beachs.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),// الموقع
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            beachs.location,
                            
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // أيقونة المظلة
                      Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.umbrella,
                            color: Colors.blue,
                            size: 16,
                          ),
                          Text( " مظلة . كراسي الاستلقاء للتشمس")
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Icon(Icons.star_rate_rounded, color: Colors.yellow,size: 20,),
                        Icon(Icons.star_rate_rounded, color: Colors.yellow,size: 20,),
                        Icon(Icons.star_rate_rounded, color: Colors.yellow,size: 20,),
                        Icon(Icons.star_rate_rounded, color: Colors.yellow,size: 20,),
                        Icon(Icons.star_rate_rounded, color: Colors.yellow,size: 20,),
                        Text(
                      "  التقييمات (${275})  ",
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),

                      ],),
                      const SizedBox(height: 12,),


                      // السعر
                      Text(
                        "ج${beachs.price}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }