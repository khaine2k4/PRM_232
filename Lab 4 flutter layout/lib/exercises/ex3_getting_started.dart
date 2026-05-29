import 'package:flutter/material.dart';

class ItemModel {
  final String title;
  final int value;
  bool isFavorite;

  ItemModel({
    required this.title,
    required this.value,
    this.isFavorite = false,
  });
}

class Ex3GettingStartedScreen extends StatefulWidget {
  const Ex3GettingStartedScreen({super.key});

  @override
  State<Ex3GettingStartedScreen> createState() => _Ex3GettingStartedScreenState();
}

class _Ex3GettingStartedScreenState extends State<Ex3GettingStartedScreen> {
  final List<ItemModel> _items = [
    ItemModel(title: 'LidTerm', value: 3),
    ItemModel(title: 'CraftRock', value: 4),
    ItemModel(title: 'BootClay', value: 5),
    ItemModel(title: 'CheckSuit', value: 6),
    ItemModel(title: 'TeamSake', value: 7),
    ItemModel(title: 'NewLaugh', value: 8),
    ItemModel(title: 'BlueCop', value: 9),
    ItemModel(title: 'WildTent', value: 10),
  ];

  void _addNewItem() {
    // Add a new mock item at the end
    setState(() {
      final nextVal = _items.isEmpty ? 1 : _items.last.value + 1;
      _items.add(
        ItemModel(title: 'MockItem', value: nextVal),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added new item!'),
        duration: Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Subtle off-white background
      appBar: AppBar(
        title: const Text(
          'Getting Started Testing',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              // Action for list button
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewItem,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
              ),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${item.value}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: item.isFavorite ? Colors.red : Colors.grey,
                    size: 26.0,
                  ),
                  onPressed: () {
                    setState(() {
                      item.isFavorite = !item.isFavorite;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
