// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async'; // Import the dart:async library

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController endXController = TextEditingController();
  TextEditingController endYController = TextEditingController();

  // Add a timer to fetch orders periodically
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is created
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchOrders();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create New Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildCreateOrderForm(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          createOrder();
                        },
                        child: const Text('Create Order'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20, thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Open/Pending Orders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildOrderList(),
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

  Widget buildCreateOrderForm() {
    return Column(
      children: [
        TextField(
          controller: endXController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'End X (1-99)'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: endYController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'End Y (1-99)'),
        ),
      ],
    );
  }

  Widget buildOrderList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No open/pending orders available.');
        } else {
          // Display the list of orders
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: snapshot.data!.map((order) {
              return ListTile(
                title: Text('Order ID: ${order['_id']}'),
                subtitle: Text(
                    'Start: (${order['start']['x']}, ${order['start']['y']}) | End: (${order['end']['x']}, ${order['end']['y']}), ${order['status']}'),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    const String baseUrl = 'http://35.205.19.65:4000/';
    const List<String> endpoints = [
      'api/orders/get/status/open',
      'api/orders/get/status/pending'
    ];

    final client = http.Client();
    List<Map<String, dynamic>> allOrders = [];

    try {
      for (String endpoint in endpoints) {
        final response = await client.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          allOrders.addAll(data.cast<Map<String, dynamic>>());
        } else {
          print('Failed to fetch orders, ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during order fetch: $e');
    } finally {
      client.close();
    }

    return allOrders;
  }

  void createOrder() async {
    // Implement logic to create a new order
    const String baseUrl = 'http://35.205.19.65:4000/';
    const String endpoint = 'api/orders/create';

    final Map<String, dynamic> data = {
      'userId': '6559d6fcec0a486f407c7913',
      'start': {'x': 49, 'y': 49},
      'end': {
        'x': int.parse(endXController.text),
        'y': int.parse(endYController.text)
      },
    };

    final client = http.Client();

    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Order created successfully');
      } else {
        print('Failed to create order, ${response.statusCode}');
      }
    } catch (e) {
      print('Error during order creation: $e');
    } finally {
      client.close();
    }
  }
}
