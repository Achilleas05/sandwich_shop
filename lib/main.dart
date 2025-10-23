import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _footlongQuantity = 0;
  int _sixInchQuantity = 0;
  String _selectedType = 'Footlong';
  final TextEditingController _noteController = TextEditingController();
  String _note = '';

  void _increaseQuantity() {
    setState(() {
      if (_selectedType == 'Footlong' &&
          _footlongQuantity < widget.maxQuantity) {
        _footlongQuantity++;
      } else if (_selectedType == 'Six-inch' &&
          _sixInchQuantity < widget.maxQuantity) {
        _sixInchQuantity++;
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_selectedType == 'Footlong' && _footlongQuantity > 0) {
        _footlongQuantity--;
      } else if (_selectedType == 'Six-inch' && _sixInchQuantity > 0) {
        _sixInchQuantity--;
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentQuantity =
        _selectedType == 'Footlong' ? _footlongQuantity : _sixInchQuantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Sandwich type selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Footlong'),
                  selected: _selectedType == 'Footlong',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedType = 'Footlong';
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Six-inch'),
                  selected: _selectedType == 'Six-inch',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedType = 'Six-inch';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            OrderItemDisplay(currentQuantity, _selectedType),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: StyledButton(
                      text: 'Remove',
                      icon: Icons.remove,
                      backgroundColor: Colors.orange,
                      onPressed: currentQuantity > 0 ? _decreaseQuantity : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StyledButton(
                      text: 'Add',
                      icon: Icons.add,
                      backgroundColor: Colors.green,
                      onPressed: currentQuantity < widget.maxQuantity
                          ? _increaseQuantity
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a note (e.g., "no onion")',
                ),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _note.isEmpty ? 'No note added' : 'Note: $_note',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const StyledButton({
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${List.filled(quantity, '🥪').join()}',
    );
  }
}
