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
  int _quantity = 0;
  final TextEditingController _noteController = TextEditingController();
  String _note = '';

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canIncrease = _quantity < widget.maxQuantity;
    final bool canDecrease = _quantity > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              'Footlong',
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: StyledButton(
                      text: 'Add',
                      icon: Icons.add,
                      backgroundColor: Colors.green,
                      onPressed: canIncrease ? _increaseQuantity : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StyledButton(
                      text: 'Remove',
                      icon: Icons.remove,
                      backgroundColor: Colors.red,
                      onPressed: canDecrease ? _decreaseQuantity : null,
                    ),
                  ),
                ],
              ),
            ),

            // Note input
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

            // Display note
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
    final ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade400;
          }
          return backgroundColor;
        },
      ),
    );

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: style,
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
