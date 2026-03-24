import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeachDetailsPage extends StatelessWidget {
  final dynamic beach;
  double? ne;
  BeachDetailsPage({super.key, required this.beach, this.ne});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة كبيرة للشاطئ
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                ),
                child: Stack(
                  children: [
                    // الصورة أو اللودر أو أيقونة الخطأ
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        beach.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // زر الرجوع فوق على الشمال
                    Positioned(
                      top: 12,
                      
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // ترجع للخلف
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    beach.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Spacer(flex: 1),
                  Text("${ne?.toStringAsFixed(0) ?? 0}%"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.star_rate_rounded, color: Colors.yellow),
                  Text(
                    "  التقييمات (${275})  ",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.pin_drop_sharp,color: Colors.blue,),
                  Text("  ${beach.location}", style: TextStyle(fontSize: 16)),
                ],
              ),
               // عرض المميزات (كراسي، مظلات)
              Divider(),
              Text("  المرافق ", style: TextStyle(fontSize: 25)),
              Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(height: 10),

                          Center(child: Icon(Icons.chair, size: 30,color: Colors.blue,)),
                          Text("كراسى \nشاطئ",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                    SizedBox(
                    height: 120,
                    width: 100,
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(height: 22),
                          Center(child: FaIcon(FontAwesomeIcons.umbrella,color: Colors.blue,)),
                          SizedBox(height: 10),
                          Text("المظلات",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.adjust_rounded),
                  Text(" الوصف حول هذا الشاطئ",style: TextStyle(fontSize: 25,color: Colors.blue),),
                ],
              ),
              Flexible(
                
                child: SingleChildScrollView(child: Text(beach.description,style: TextStyle(fontSize: 20),))),
               Divider(),
               SizedBox(height: 10,),
                SizedBox(
                    height: 120,
                    width: 390,
                    child: Card(
                      color: Colors.blue[100],
                      child: Column(
                        children: [      
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded,size: 30,),
                              Text("  ابتداءً من 50 جنيهًا مصريًا/الساعة",style: TextStyle(fontSize: 22),),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Text("يختلف السعر النهائي حسب حجم المجموعة ومدة الحجز",style: TextStyle(fontSize: 16),)
                        ],
                      ),
                    ),
                  ),

             
              Spacer(),

              // زر الحجز
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    // أكشن الحجز هنا
                  },
                  child: Text(
                    "احجز الآن",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
