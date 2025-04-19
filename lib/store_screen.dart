import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreScreen extends StatefulWidget {
  final String userName;
  final int points;
  final int coins;

  const StoreScreen({
    super.key,
    required this.userName,
    required this.points,
    required this.coins,
  });

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int currentPoints;
  late int currentCoins;
  List<Map<String, dynamic>> purchasedItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    currentPoints = widget.points;
    currentCoins = widget.coins;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void purchaseItem(int cost, String currency, Map<String, dynamic> item) {
    setState(() {
      if (currency == 'points' && currentPoints >= cost) {
        currentPoints -= cost;
        purchasedItems.add(item);
        showSuccess("Item purchased with points!");
      } else if (currency == 'coins' && currentCoins >= cost) {
        currentCoins -= cost;
        purchasedItems.add(item);
        showSuccess("Item purchased with coins!");
      } else {
        _showBuyMoreDialog(currency);
      }
    });
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $message')),
    );
  }

  void _showBuyMoreDialog(String currency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Insufficient $currency'),
        content: Text('You don’t have enough $currency to buy this item. Would you like to top up?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.pushNamed(context, '/buy');
              if (result != null && result is int) {
                setState(() => currentCoins += result);
              }
            },
            child: const Text('Buy More'),
          ),
        ],
      ),
    );
  }

  Widget buildStoreTab(List<Map<String, dynamic>> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'], size: 40, color: Colors.teal),
              const SizedBox(height: 10),
              Text(item['title'], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('${item['price']} ${item['currency']}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => purchaseItem(item['price'], item['currency'], item),
                child: const Text('Buy'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildPurchasedTab() {
    if (purchasedItems.isEmpty) {
      return const Center(child: Text("No purchases yet."));
    }
    return ListView.builder(
      itemCount: purchasedItems.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = purchasedItems[index];
        return ListTile(
          leading: Icon(item['icon'], color: Colors.teal),
          title: Text(item['title']),
          subtitle: Text('Cost: ${item['price']} ${item['currency']}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatars = [
      {'title': 'Cool Avatar', 'icon': Icons.face, 'price': 50, 'currency': 'points'},
      {'title': 'Golden Avatar', 'icon': Icons.star, 'price': 100, 'currency': 'coins'},
    ];
    final lessons = [
      {'title': 'Budget Mastery', 'icon': Icons.school, 'price': 40, 'currency': 'points'},
      {'title': 'Loan Expert', 'icon': Icons.attach_money, 'price': 60, 'currency': 'points'},
    ];
    final vouchers = [
      {'title': '10% Off Bank Fee', 'icon': Icons.local_offer, 'price': 150, 'currency': 'points'},
      {'title': '\$5 Gift Card', 'icon': Icons.card_giftcard, 'price': 100, 'currency': 'coins'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.face), text: 'Avatars'),
            Tab(icon: Icon(Icons.menu_book), text: 'Lessons'),
            Tab(icon: Icon(Icons.card_giftcard), text: 'Vouchers'),
            Tab(icon: Icon(Icons.shopping_bag), text: 'Purchases'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text('Points: $currentPoints'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.green),
                    const SizedBox(width: 6),
                    Text('Coins: $currentCoins'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildStoreTab(avatars),
                buildStoreTab(lessons),
                buildStoreTab(vouchers),
                buildPurchasedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
