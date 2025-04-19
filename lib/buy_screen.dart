import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyCoinsScreen extends StatefulWidget {
  final Function(int) onCoinsPurchased;

  const BuyCoinsScreen({super.key, required this.onCoinsPurchased});

  @override
  State<BuyCoinsScreen> createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreen> {
  int coinsPurchased = 0;

  void purchase(BuildContext context, String label, int amount, String price) {
    setState(() => coinsPurchased += amount);

    // Call the callback to update app state
    widget.onCoinsPurchased(amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Purchase Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You purchased $amount coins for $price.'),
            const SizedBox(height: 10),
            const Text(
              'Thank you for supporting FinEdu!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void finishPurchase() {
    Navigator.pop(context, coinsPurchased);
  }

  @override
  Widget build(BuildContext context) {
    final coinBundles = [
      {
        'label': 'Starter Pack',
        'amount': 50,
        'price': '\$0.99',
        'desc': 'Great for testing the store experience!'
      },
      {
        'label': 'Standard Pack',
        'amount': 120,
        'price': '\$1.99',
        'desc': 'Most popular choice for learners'
      },
      {
        'label': 'Mega Pack',
        'amount': 300,
        'price': '\$3.99',
        'desc': 'Unlock quizzes and vouchers faster!'
      },
      {
        'label': 'Ultimate Bundle',
        'amount': 800,
        'price': '\$8.99',
        'desc': 'Everything you’ll ever need!'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Coins'),
        actions: [
          TextButton(
            onPressed: coinsPurchased > 0 ? finishPurchase : null,
            child: Text(
              'Done (${coinsPurchased.toString()})',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coinBundles.length,
        itemBuilder: (context, index) {
          final bundle = coinBundles[index];
          final label = bundle['label'] as String;
          final amount = bundle['amount'] as int;
          final price = bundle['price'] as String;
          final desc = bundle['desc'] as String;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, size: 32, color: Colors.green),
                      const SizedBox(width: 12),
                      Text('$amount Coins',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => purchase(context, label, amount, price),
                        child: Text('Buy for $price'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(label, style: GoogleFonts.poppins(fontSize: 16)),
                  Text(desc,
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
