import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MoneyTrackerApp());
}

class MoneyTrackerApp extends StatelessWidget {
  const MoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
        ),
      ),
      home: MoneyTrackerHome(),
    );
  }
}

class MoneyTrackerHome extends StatefulWidget {
  const MoneyTrackerHome({super.key});

  @override
  _MoneyTrackerHomeState createState() => _MoneyTrackerHomeState();
}

class _MoneyTrackerHomeState extends State<MoneyTrackerHome> {
  final List<Map<String, dynamic>> transactions = [];
  double balance = 0.0;
  final TextEditingController amountController = TextEditingController();

  void addTransaction(bool isDeposit) {
    final double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      transactions.insert(0, {
        'amount': isDeposit ? amount : -amount,
        'date': DateTime.now(),
      });
      balance += isDeposit ? amount : -amount;
    });
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Tracker App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Balance: ₹${balance.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => addTransaction(true),
                  child: Text('Deposit'),
                ),
                ElevatedButton(
                  onPressed: () => addTransaction(false),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800]),
                  child: Text('Spend'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final isDeposit = transaction['amount'] > 0;
                  return ListTile(
                    title: Text(
                      "₹${transaction['amount'].abs().toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isDeposit ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transaction['date']),
                      style: TextStyle(color: Colors.grey),
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
