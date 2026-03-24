import 'package:flutter/material.dart';
import 'package:por2/api_server.dart';
import 'package:por2/card_beach.dart';
import 'package:provider/provider.dart';

class AllBeachesScreen extends StatelessWidget {
  AllBeachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("كل الشواطئ المتاحة"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<BeachProvider>(
          builder: (context, provider, child) {
            // لو لسه بيحمل بيانات، نعرض Loader
            if (provider.isLoading && provider.beaches.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
      
            // RefreshIndicator للسحب لتحديث البيانات
            return RefreshIndicator(
              onRefresh: provider.refreshBeaches,
              child: ListView.builder(
                itemCount: provider.beaches.length,
                itemBuilder: (context, index) {
                  final beachs = provider.beaches[index];
                  double al = beachs.getPercentage();
      
                  return BeachCard(beachs: provider.beaches[index],pre: al,);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
