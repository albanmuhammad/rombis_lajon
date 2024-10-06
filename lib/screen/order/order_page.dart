import 'package:flutter/material.dart';
import 'package:redbus_project/model/order/order.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  ListOrder? listOrder;
  bool isLoading = true;
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var userId = await AuthService().getUserId();
    var orders = await OrderService().getUserOrder(context, userId);
    setState(() {
      listOrder = orders;
      isLoading = false;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  // Helper function to build tab items
  Widget _buildTabItem(String title, int index) {
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _currentIndex == index ? Colors.red : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          if (_currentIndex == index)
            Container(
              height: 3,
              width: 60,
              color: Colors.red,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesanan Saya'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listOrder == null || listOrder!.orders.isEmpty
              ? const Center(
                  child: Text('No orders found'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listOrder!.orders.length,
                  itemBuilder: (context, index) {
                    final order = listOrder!.orders[index];
                    return OrderCard(order: order);
                  },
                ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus: ${order.ticket.bus.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: Rp${order.price}, Kursi: ${order.seat}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Dari: ${order.route.first} Ke ${order.route.last}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${order.ticket.date}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
