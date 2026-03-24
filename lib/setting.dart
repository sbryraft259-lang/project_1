import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _username = "User Name";
  String? _imagePath;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User Name";
      _imagePath = prefs.getString('imagePath');
      _nameController.text = _username;
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    if (_imagePath != null) await prefs.setString('imagePath', _imagePath!);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');
      setState(() {
        _imagePath = savedImage.path;
      });
      await _saveUserData();
    }
  }

  Future<void> _changeName() async {
    setState(() {
      _username = _nameController.text;
    });
    await _saveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الاعدادات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imagePath != null
                    ? FileImage(File(_imagePath!))
                    : const AssetImage('lib/AGSS0356.JPG'),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _changeName();
                Navigator.pop(context, true);
              },
              child: const Text('حفظ التغير'),
            ),
          ],
        ),
      ),
    );
  }
}
