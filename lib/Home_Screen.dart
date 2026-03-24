import 'package:flutter/material.dart';
import 'package:por2/Booking.dart';
import 'package:por2/fovert.dart';
import 'package:por2/model.dart';
import 'package:por2/myauto.dart';
import 'package:por2/notification.dart';
import 'package:por2/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:por2/profile.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyAutoSlider(),
    const BookingsPage(),
    const FavoritesTab(),
    const ProfileSettings(),
  ];

  void _onItemTapped(int index, BuildContext context) async {
    if (index == 3) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

      if (isLoggedIn) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: _selectedIndex == 0 && name != null
                  ? AppBar(
                      centerTitle: false,
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/300",
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "أحمد",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications_none, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Mynotification(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
              body: _pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => _onItemTapped(index, context),
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_online),
                    label: 'حجوزاتي',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'المفضلات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'الملف الشخصي',
                  ),
                ],
              ),
            ),
        );
  }
}
