import 'package:flutter/material.dart';
import 'package:food_ordering_app/database_helper.dart';
import 'package:food_ordering_app/food_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double targetCost = 0.0;
  DateTime selectedDate = DateTime.now();
  List<FoodItem> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input for target cost per day
            TextField(
              decoration: InputDecoration(labelText: 'Target cost per day'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  targetCost = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            // Date selection
            Text('Selected Date: ${selectedDate.toLocal()}'),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            // Food item list
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(foodItems[index].name),
                    trailing: Text('\$${foodItems[index].cost}'),
                    onTap: () {
                      setState(() {
                        if (!selectedItems.contains(foodItems[index])) {
                          selectedItems.add(foodItems[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save selected items to the database
                for (var item in selectedItems) {
                  Map<String, dynamic> order = {
                    'foodItem': item.name,
                    'cost': item.cost,
                    'date': selectedDate.toLocal().toString(),
                    'targetCost': targetCost,
                  };
                  await DatabaseHelper().insertOrder(order);
                }
                print('Order saved for ${selectedDate.toLocal()}');
              },
              child: Text('Save Order'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Retrieve orders for the selected date
                List<Map<String, dynamic>> orders =
                    await DatabaseHelper().getOrders(selectedDate.toLocal().toString());
                setState(() {
                  selectedItems = orders
                      .map((order) => FoodItem(
                          name: order['foodItem'], cost: order['cost'].toDouble()))
                      .toList();
                });
              },
              child: Text('Load Orders for Date'),
            ),
          ],
        ),
      ),
    );
  }
}

// List of food items available to order
List<FoodItem> foodItems = [
  FoodItem(name: "Pizza", cost: 10.0),
  FoodItem(name: "Burger", cost: 5.0),
  FoodItem(name: "Pasta", cost: 8.0),
  FoodItem(name: "Salad", cost: 4.0),
  FoodItem(name: "Sushi", cost: 12.0),
  // Add more items as per your requirement
];
