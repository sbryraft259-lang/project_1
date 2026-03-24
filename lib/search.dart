import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:por2/Deteils.dart';
import 'package:por2/model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Beach> beaches = [];
  bool loading = false;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // فتح الكيبورد أول ما الصفحة تفتح
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce للبحث
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchBeach(value);
    });
  }

  Future<void> searchBeach(String query) async {
    if (query.trim().isEmpty) {
      setState(() => beaches = []);
      return;
    }

    setState(() => loading = true);

    final uri = Uri.parse(
      "https://beachflow-app-production-7bce.up.railway.app/api/beach/search?q=$query",
    );

    try {
      final response = await http.get(uri);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          beaches = data.map((b) => Beach.fromJson(b)).toList();
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          beaches = [];
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        beaches = [];
      });
      print("Error fetching beaches: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Beach")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "ابحث عن شاطئ",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: onSearchChanged,
              ),
            ),
      
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : beaches.isEmpty
                      ? const Center(
                          child: Text(
                            "لا توجد شواطئ",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: beaches.length,
                          itemBuilder: (context, index) {
                            final beach = beaches[index];
                        
                             double la = beach.getPercentage();
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BeachDetailsPage(beach: beach,ne: la,),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                elevation: 3,child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      beach.imageUrl.isNotEmpty
                                          ? Image.network(
                                              beach.imageUrl,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  height: 200,
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 200,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 200,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      const SizedBox(height: 8),
                                      Text(
                                        beach.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        beach.location,
                                        style:
                                            const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}