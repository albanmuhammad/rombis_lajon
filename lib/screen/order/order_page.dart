import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redbus_project/model/order/order.dart';
import 'package:redbus_project/screen/ticket/payment_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/services/order_service.dart';
import 'package:redbus_project/services/ticket_service.dart';

class OrderPage extends StatefulWidget {
  final int initialTabIndex;
  const OrderPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  ListOrder? listOrder;
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    var userId = await AuthService().getUserId();
    var orders = await OrderService().getUserOrder(context, userId);
    setState(() {
      listOrder = orders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesanan Saya'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Menunggu', textAlign: TextAlign.center),
                      Text('Pembayaran', textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(width: 8), // Space between text and circle
                  Container(
                    width: 10, // Circle width
                    height: 10, // Circle height
                    decoration: BoxDecoration(
                      color: Colors.red, // Change to desired color
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Menunggu', textAlign: TextAlign.center),
                      Text('Persetujuan', textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pembayaran', textAlign: TextAlign.center),
                      Text('Selesai', textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // OnProgressOrderPage will show orders where isPaid = false
                OnProgressOrderPage(
                  listOrder: listOrder,
                  refreshOrders: getData,
                ),
                // CompletedOrderPage will show orders where isPaid = true
                ConfirmationWaitOrderPage(
                  listOrder: listOrder,
                  refreshOrders: getData,
                ),
                CompletedOrderPage(
                  listOrder: listOrder,
                  refreshOrders: getData,
                ),
              ],
            ),
    );
  }
}

class OnProgressOrderPage extends StatelessWidget {
  final ListOrder? listOrder;
  final VoidCallback refreshOrders; // Accept the callback function

  const OnProgressOrderPage({
    super.key,
    required this.listOrder,
    required this.refreshOrders,
  });

  @override
  Widget build(BuildContext context) {
    var onProgressOrders =
        listOrder?.orders.where((order) => order.isPaid == 0).toList() ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        refreshOrders();
      },
      child: onProgressOrders.isEmpty
          ? const Center(child: Text('Tidak Ada Order yang Belum Dibayar'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: onProgressOrders.length,
              itemBuilder: (context, index) {
                final order = onProgressOrders[index];
                return GestureDetector(
                  child: OrderCard(
                    order: order,
                    isPaidDone: false,
                    refreshOrders: refreshOrders,
                  ),
                  onTap: () async {
                    var x = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          price: order.price,
                          date: order.createdAt,
                        ),
                      ),
                    );
                    if (x == true) {
                      refreshOrders(); // Call the parent's getData() method
                    }
                  },
                );
              },
            ),
    );
  }
}

// Page for completed orders (isPaid = true)
class ConfirmationWaitOrderPage extends StatelessWidget {
  final ListOrder? listOrder;
  final VoidCallback refreshOrders;

  const ConfirmationWaitOrderPage(
      {super.key, required this.listOrder, required this.refreshOrders});

  @override
  Widget build(BuildContext context) {
    var completedOrders =
        listOrder?.orders.where((order) => order.isPaid == 1).toList() ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        refreshOrders();
      },
      child: completedOrders.isEmpty
          ? const Center(
              child: Text('Tidak Ada Order yang Sedang Diverifikasi'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                final order = completedOrders[index];
                return OrderCard(
                  order: order,
                  isPaidDone: false,
                  refreshOrders: refreshOrders,
                );
              },
            ),
    );
  }
}

// Page for completed orders (isPaid = true)
class CompletedOrderPage extends StatelessWidget {
  final ListOrder? listOrder;
  final VoidCallback refreshOrders;

  const CompletedOrderPage(
      {super.key, required this.listOrder, required this.refreshOrders});

  @override
  Widget build(BuildContext context) {
    var completedOrders =
        listOrder?.orders.where((order) => order.isPaid == 2).toList() ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        refreshOrders();
      },
      child: completedOrders.isEmpty
          ? const Center(child: Text('Tidak Ada Rrder yang Telah Diverifikasi'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                final order = completedOrders[index];
                return OrderCard(
                  order: order,
                  isPaidDone: true,
                  refreshOrders: refreshOrders,
                );
              },
            ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final bool isPaidDone;
  final VoidCallback refreshOrders;

  const OrderCard(
      {Key? key,
      required this.order,
      required this.isPaidDone,
      required this.refreshOrders})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isSwitched = false;

  String formattedDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy').format(parsedDate);
  }

  String formatRupiah(int value) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(value);
  }

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
              'Bus: ${widget.order.ticket.bus.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nama: ${widget.order.name}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              "${widget.order.seat > 0 ? 'Kursi:' : 'Barang:'} ${widget.order.seat > 0 ? widget.order.seat : widget.order.jumlahBarang}",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              'Tikum: ${widget.order.tikum}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rute: ${widget.order.route.first} Ke ${widget.order.route.last}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Text(
              'Tanggal Keberangkatan: ${formattedDate(widget.order.ticket.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      ' ${widget.order.ticket.currentLocation}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.isPaidDone,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Absen: ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: widget.order.sampai,
                            onChanged: (value) async {
                              var x = await ticketService()
                                  .absenTicket(context, widget.order.id, value);
                              widget.refreshOrders();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
