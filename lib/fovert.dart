import 'package:flutter/material.dart';
import 'package:por2/providerfov.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  bool loading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<FavoriteProvider>(context, listen: false)
          .loadFavorites();
      if (!mounted) return;
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);

    if (loading) return const Center(child: CircularProgressIndicator());

    if (favProvider.favoriteBeaches.isEmpty) {
      return const Center(
          child: Text("لا توجد شواطئ في المفضلة",
              style: TextStyle(fontSize: 18)));
    }

    return ListView.builder(
      itemCount: favProvider.favoriteBeaches.length,
      itemBuilder: (context, index) {
        final beach = favProvider.favoriteBeaches[index];
        return ListTile(
          leading: Image.network(
            beach.imageUrl,
            width: 60,
            fit: BoxFit.cover,
            loadingBuilder: (ctx, child, progress) =>
                progress == null ? child : const Center(child: CircularProgressIndicator()),
            errorBuilder: (ctx, error, stack) =>
                const Icon(Icons.image_not_supported),
          ),
          title: Text(beach.name),
          subtitle: Text(beach.location),
        );
      },
    );
  }
}