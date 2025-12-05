import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

// Responsive navigation items - shows in Drawer on mobile, AppBar on desktop
List<Widget> buildNavigationItems(BuildContext context) {
  return [
    ListTile(
      leading: const Icon(Icons.restaurant),
      title: const Text('Order'),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != '/') {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
    ),
    ListTile(
      leading: const Icon(Icons.shopping_cart),
      title: const Text('Cart'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/cart');
      },
    ),
    ListTile(
      leading: const Icon(Icons.person),
      title: const Text('Profile'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/profile');
      },
    ),
    ListTile(
      leading: const Icon(Icons.settings),
      title: const Text('Settings'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/settings');
      },
    ),
  ];
}

// Main AppBar with Drawer and Cart
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;

  const MainAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return AppBar(
      leading: automaticallyImplyLeading
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      title: Text(title, style: heading1),
      actions: [
        // On large screens, show navigation items in AppBar
        if (isLargeScreen) ...[
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: const Text('Order', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            child: const Text('Cart', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            child: const Text('Profile', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            child:
                const Text('Settings', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
        // Cart counter (always shown)
        Consumer<Cart>(
          builder: (context, cart, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 4),
                  Text('${cart.countOfItems}'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// Common Drawer widget
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sandwich Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: buildNavigationItems(context),
          ),
        ),
      ],
    ),
  );
}

// Common StyledButton
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
