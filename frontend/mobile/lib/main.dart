import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oil Price Estimator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OilPricePage(),
    );
  }
}

class OilPricePage extends StatefulWidget {
  const OilPricePage({super.key});
  @override
  State<OilPricePage> createState() => _OilPricePageState();
}

class _OilPricePageState extends State<OilPricePage> {
  DateTime? oilDate;
  bool loading = false;
  String? error;
  double? price;
  String? currency;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: oilDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        oilDate = picked;
      });
    }
  }

  Future<void> _calculatePrice() async {
    if (oilDate == null) {
      setState(() {
        error = 'กรุณาเลือกวันเดือนปี';
        price = null;
        currency = null;
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
      final formattedDate = DateFormat('yyyy-MM-dd').format(oilDate!);
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/oil'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'oil_date': formattedDate}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        setState(() {
          price = (data['price'] as num).toDouble();
          currency = data['currency'];
        });
      } else {
        setState(() {
          error = data['detail'] != null
              ? 'ข้อมูลไม่ถูกต้อง: ${jsonEncode(data['detail'])}'
              : 'เกิดข้อผิดพลาด: ${data['error'] ?? response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'ไม่สามารถเชื่อมต่อกับ API หรือเกิดข้อผิดพลาด';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ประเมินราคาน้ำมันดิบ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วันเดือนปี (YYYY-MM-DD)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: loading ? null : _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    child: Text(
                      oilDate != null
                          ? DateFormat('yyyy-MM-dd').format(oilDate!)
                          : 'เลือกวันเดือนปี',
                      style: TextStyle(
                        fontSize: 16,
                        color: oilDate != null
                            ? Colors.black
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _calculatePrice,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'คำนวณราคา',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      error!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                if (price != null)
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        left: BorderSide(
                          color: Colors.green.shade400,
                          width: 5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ราคาประเมินน้ำมันดิบ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${price!.toStringAsFixed(2)} ${currency ?? ""}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
