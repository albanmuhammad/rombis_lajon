import 'package:flutter/material.dart';
import 'package:redbus_project/model/ticket/ticket.dart';
import 'package:redbus_project/screen/ticket/booking_page.dart';
import 'package:redbus_project/services/ticket_service.dart';

class TicketPage extends StatefulWidget {
  final String? from;
  final String? to;
  final String? date;
  final String? busId;

  TicketPage({this.from, this.to, this.date, this.busId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  ListTicket? listTicket;
  String? selectedFrom;
  String? selectedTo;
  String? selectedDate;
  RangeValues selectedPriceRange = RangeValues(0, 1000000);
  bool isLoading = false;

  @override
  void initState() {
    resetFilters(); // Fetch initial data
    getData();
    super.initState();
  }

  // Reset filters
  void resetFilters() {
    selectedFrom = widget.from;
    selectedTo = widget.to;
    selectedDate = widget.date;
    selectedPriceRange = RangeValues(0, 1000000);
  }

  // Get data and filter based on 'from', 'to', 'date' and price range
  getData() async {
    setState(() {
      isLoading = true;
    });
    var x = await ticketService().getAllTicket(context);
    setState(() {
      listTicket = x;

      listTicket!.data = listTicket!.data.where((ticket) {
        // Check 'from' location
        // Check 'from' location
        final fromIndex = selectedFrom != null && selectedFrom!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedFrom!.toLowerCase()))
            : -1;

// Ensure that 'from' is not the last index in the route
        if (fromIndex != -1 && fromIndex == ticket.bus.route.length - 1) {
          return false; // Exclude if 'from' is the last stop
        }

// Check 'to' location
        final toIndex = selectedTo != null && selectedTo!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedTo!.toLowerCase()))
            : -1;

// Ensure that 'to' is not the first index in the route
        if (toIndex != -1 && toIndex == 0) {
          return false; // Exclude if 'to' is the first stop
        }

        // If 'from' is specified but not found in the route, exclude the ticket
        if (selectedFrom != null &&
            selectedFrom!.isNotEmpty &&
            fromIndex == -1) {
          return false;
        }

        // If 'to' is specified but not found in the route, exclude the ticket
        if (selectedTo != null && selectedTo!.isNotEmpty && toIndex == -1) {
          return false;
        }

        // If both 'from' and 'to' are specified, ensure that 'from' comes before 'to'
        if (selectedFrom != null &&
            selectedFrom!.isNotEmpty &&
            selectedTo != null &&
            selectedTo!.isNotEmpty &&
            (fromIndex == -1 || toIndex == -1 || fromIndex >= toIndex)) {
          return false;
        }

        // Filter by date
        if (selectedDate != null &&
            selectedDate!.isNotEmpty &&
            ticket.date != selectedDate) {
          return false;
        }

        // Filter by price range
        final minPrice = ticket.price.first;
        final maxPrice = ticket.price.last;
        if (minPrice < selectedPriceRange.start ||
            maxPrice > selectedPriceRange.end) {
          return false;
        }

        return true;
      }).toList();
      isLoading = false;
    });
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _showFilterModal,
            icon: Icon(Icons.filter_list),
            label: Text('Filters'),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.sort),
            label: Text('Urutkan'),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.directions_bus),
            label: Text('Bus'),
          ),
        ],
      ),
    );
  }

  // Bus card UI
  Widget _buildBusCard(BuildContext context, Ticket ticket) {
    return GestureDetector(
      onTap: () async {
        var x = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingPage(
                      ticketId: ticket.id,
                      busId: ticket.busId,
                    )));
        if (x != null) {
          getData();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusHeader(ticket),
              SizedBox(height: 8),
              _buildBusDetails(ticket),
            ],
          ),
        ),
      ),
    );
  }

  // Header for each bus card (includes time, location, and prices)
  Widget _buildBusHeader(Ticket ticket) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticket.time[0].substring(11, 16),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(ticket.bus.route[0], style: TextStyle(color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              Text(
                '${ticket.bus.route.length - 1} stops', // Number of stops
                style: TextStyle(color: Colors.grey),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ticket.time.last.substring(11, 16), // End time
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(ticket.bus.route.last,
                  style: TextStyle(color: Colors.grey)), // End location
            ],
          ),
        ],
      ),
    );
  }

  // Bus details (name, availability, price)
  Widget _buildBusDetails(Ticket ticket) {
    print('ini ticket bus seat ${ticket.bus.seat}');
    print('ini filled seat ${ticket.filledSeat.length}');
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.bus.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              '${ticket.bus.seat - ticket.filledSeat.length} dari ${ticket.bus.seat} kursi tersedia',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Rp ${ticket.price[0]} - Rp ${ticket.price.last}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text(
                      'Type:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(ticket.bus.type),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildActiveFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // Add some spacing between the filter tags
        children: [
          if (selectedFrom != null && selectedFrom!.isNotEmpty)
            Chip(
              label: Text('Dari: $selectedFrom'),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  selectedFrom = null;
                  getData(); // Refresh the data
                });
              },
            ),
          if (selectedTo != null && selectedTo!.isNotEmpty)
            Chip(
              label: Text('Ke: $selectedTo'),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  selectedTo = null;
                  getData(); // Refresh the data
                });
              },
            ),
          if (selectedDate != null && selectedDate!.isNotEmpty)
            Chip(
              label: Text('Tanggal: $selectedDate'),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  selectedDate = null;
                  getData(); // Refresh the data
                });
              },
            ),
          if (selectedPriceRange.start > 0 || selectedPriceRange.end < 1000000)
            Chip(
              label: Text(
                  'Harga: Rp ${selectedPriceRange.start.round()} - Rp ${selectedPriceRange.end.round()}'),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  selectedPriceRange = RangeValues(0, 1000000);
                  getData(); // Refresh the data
                });
              },
            ),
        ],
      ),
    );
  }

  void _showFilterModal() {
    // Initialize the modal variables with the current selected values
    String? tempFrom = selectedFrom;
    String? tempTo = selectedTo;
    String? tempDate = selectedDate;
    RangeValues tempPriceRange = selectedPriceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(16),
                height: 400, // Adjust height based on your design
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Apply Filters",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),

                    // "From" TextField
                    TextField(
                      decoration: InputDecoration(labelText: 'Dari'),
                      controller: TextEditingController(
                          text: tempFrom), // prefill with the current value
                      onChanged: (value) {
                        tempFrom = value;
                      },
                    ),

                    // "To" TextField
                    TextField(
                      decoration: InputDecoration(labelText: 'Ke'),
                      controller: TextEditingController(
                          text: tempTo), // prefill with the current value
                      onChanged: (value) {
                        tempTo = value;
                      },
                    ),

                    // "Date" picker
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: tempDate), // prefill with current value
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020), // start date
                          lastDate: DateTime(2030), // end date
                        );
                        if (pickedDate != null) {
                          modalSetState(() {
                            tempDate = "${pickedDate.toLocal()}".split(' ')[
                                0]; // Update the temporary value with the selected date
                          });
                        }
                      },
                    ),

                    // Price Range Slider
                    Text(
                      'Harga',
                      style: TextStyle(fontSize: 16),
                    ),
                    RangeSlider(
                      values: tempPriceRange,
                      min: 0,
                      max: 1000000,
                      divisions: 20,
                      labels: RangeLabels(
                        '${tempPriceRange.start.round()}',
                        '${tempPriceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        modalSetState(() {
                          tempPriceRange = values;
                        });
                      },
                    ),

                    // Apply button
                    ElevatedButton(
                      onPressed: () {
                        // Update the state when "Apply Filters" is pressed
                        setState(() {
                          selectedFrom = tempFrom;
                          selectedTo = tempTo;
                          selectedDate = tempDate;
                          selectedPriceRange = tempPriceRange;
                        });
                        getData(); // Update the ticket list with new filters
                        Navigator.pop(context); // Close the modal
                      },
                      child: Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: const Text('Daftar Tiket'),
        automaticallyImplyLeading:
            false, // Optional: if you want to remove the back button
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.91,
        child: Column(
          children: [
            _buildFilters(),
            _buildActiveFilters(),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : listTicket == null || listTicket!.data.isEmpty
                      ? Center(
                          child: Text('No Ticket Found'),
                        )
                      : Container(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            itemCount: listTicket!.data.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _buildBusCard(
                                  context, listTicket!.data[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
