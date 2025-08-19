import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,      
      title: 'ประเมินราคาบ้าน',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ประเมินราคาบ้าน'),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  // Controllers
  final TextEditingController ageController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController minimartController = TextEditingController();
 
  bool loading = false;
  String? error;
  double? price;
  String? currency;
 
  Future<void> calculatePrice() async {
    final String ageText = ageController.text.trim();
    final String distanceText = distanceController.text.trim();
    final String minimartText = minimartController.text.trim();
 
    if (ageText.isEmpty || distanceText.isEmpty || minimartText.isEmpty) {
      setState(() {
        error = "กรุณากรอกข้อมูลให้ครบถ้วน";
      });
      return;
    }
 
    final int? age = int.tryParse(ageText);
    final int? distance = int.tryParse(distanceText);
    final int? minimart = int.tryParse(minimartText);
 
    if (age == null || distance == null || minimart == null) {
      setState(() {
        error = "ข้อมูลต้องเป็นตัวเลขเท่านั้น";
      });
      return;
    }
 
    setState(() {
      loading = true;
      error = null;
      price = null;
      currency = null;
    });
 
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/house"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "age": age,
          "distance": distance,
          "minimart": minimart,
        }),
      );
 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          price = (data["price"] as num).toDouble();
          currency = data["currency"];
        });
      } else {
        setState(() {
          error = "ไม่สามารถเชื่อมต่อกับ API หรือเกิดข้อผิดพลาด";
        });
      }
    } catch (e) {
      setState(() {
        error = "ไม่สามารถเชื่อมต่อกับ API หรือเกิดข้อผิดพลาด";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
 
  @override
  void dispose() {
    ageController.dispose();
    distanceController.dispose();
    minimartController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Age input
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "อายุบ้าน (ปี)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
 
                  // Distance input
                  TextField(
                    controller: distanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "ระยะทางถึง MRT (เมตร)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
 
                  // Minimart input
                  TextField(
                    controller: minimartController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "จำนวนร้านสะดวกซื้อใกล้เคียง",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
 
                  // Calculate Button
                  ElevatedButton(
                    onPressed: loading ? null : calculatePrice,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "คำนวณราคา",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
 
                  // Error message
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        error!,
                        style: TextStyle(color: Colors.red[800]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
 
                  // Result
                  if (price != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(color: Colors.green, width: 4),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "ราคาประเมินบ้าน",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${price!.toStringAsFixed(0)} $currency",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}