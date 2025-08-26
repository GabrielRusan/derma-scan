import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputNamePage extends StatefulWidget {
  const InputNamePage({super.key});

  @override
  State<InputNamePage> createState() => _InputNamePageState();
}

class _InputNamePageState extends State<InputNamePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    await _saveName();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(left: 8),
          child: Image.asset('assets/logo.png'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 100),
            Text(
              'Selamat Datang!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Silahkan tulis nama kamu dulu biar kita bisa mulai.',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nama Kamu",
                labelStyle: GoogleFonts.poppins(fontSize: 14),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: WidgetStatePropertyAll(primary),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                onPressed: _isButtonEnabled ? _onSubmit : null,
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
