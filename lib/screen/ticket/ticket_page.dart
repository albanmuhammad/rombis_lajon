import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/model/ticket/ticket.dart';
import 'package:redbus_project/screen/ticket/booking_page.dart';
import 'package:redbus_project/services/bus_service.dart';
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
  ListBus? listBus;
  List<String> selectedBusIds = [];
  List<Ticket> _originalListTickets = [];
  String? _activeSortType; // Track the active sort type
  bool _isAscending = true; // Track the ascending or descending order

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
    selectedBusIds.add(widget.busId!);
    selectedPriceRange = RangeValues(0, 1000000);
  }

  // Get data and filter based on 'from', 'to', 'date' and price range
  getData() async {
    setState(() {
      isLoading = true;
    });
    var x = await ticketService().getAllTicket(context);
    var dataListBus = await BusService().getAllBus(context);

    setState(() {
      listTicket = x;
      listBus = dataListBus;
      _originalListTickets = List.from(listTicket!.data);
      listTicket!.data = listTicket!.data.where((ticket) {
        // Check 'from' location
        final fromIndex = selectedFrom != null && selectedFrom!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedFrom!.toLowerCase()))
            : -1;

        if (fromIndex != -1 && fromIndex == ticket.bus.route.length - 1) {
          return false; // Exclude if 'from' is the last stop
        }

        // Check 'to' location
        final toIndex = selectedTo != null && selectedTo!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedTo!.toLowerCase()))
            : -1;

        if (toIndex != -1 && toIndex == 0) {
          return false; // Exclude if 'to' is the first stop
        }

        if (selectedFrom != null &&
            selectedFrom!.isNotEmpty &&
            fromIndex == -1) {
          return false;
        }

        if (selectedTo != null && selectedTo!.isNotEmpty && toIndex == -1) {
          return false;
        }

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

        // Filter by selected buses
        if (selectedBusIds.isNotEmpty &&
            selectedBusIds[0] != "" &&
            !selectedBusIds.contains(ticket.busId)) {
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
            onPressed: _showSortModal,
            icon: Icon(Icons.sort),
            label: Text('Urutkan'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _showBusFilterModal();
            },
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
    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
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
            ticket.tipeIsi == "penumpang"
                ? Text(
                    '${ticket.bus.seat - ticket.filledSeat.length} dari ${ticket.bus.seat} kursi tersedia',
                    style: TextStyle(color: Colors.grey),
                  )
                : Text(
                    '${ticket.bus.storage - ticket.filledPacket} dari ${ticket.bus.storage} Kuota Paket Barang Tersedia',
                    style: TextStyle(color: Colors.grey),
                  ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' ${formatCurrency.format(ticket.price[0])} - ${formatCurrency.format(ticket.price.last)}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: ticket.tipeIsi == "penumpang",
                  child: Column(
                    children: [
                      Chip(
                        label: Text(ticket.bus.type),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
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
                  _filterTicketsByCriteria();
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
                  _filterTicketsByCriteria();
                });
              },
            ),
          // Active Sort Indicator
          if (_activeSortType != null)
            Chip(
              label: Text(
                  'Sort: ${_activeSortType!.contains('price') ? (_isAscending ? 'Harga Termurah' : 'Harga Termahal') : (_activeSortType!.contains('earliest') ? 'Keberangkatan Paling Pagi' : 'Keberangkatan Paling Malam')}'),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () {
                setState(() {
                  _activeSortType = null; // Clear active sort
                  _isAscending = true; // Reset sorting order if necessary
                  // Optionally, you may want to call a method to re-sort your data based on other filters.
                  _filterTicketsByCriteria(); // Refresh the data after clearing the sort
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
                  _filterTicketsByCriteria();
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
                  _filterTicketsByCriteria();
                });
              },
            ),
          // Add a chip for each selected bus
          ...selectedBusIds.where((busId) => busId.isNotEmpty).map((busId) {
            // Ensure listBus is not null and find the bus name safely
            final bus = listBus!.data.firstWhere(
              (bus) => bus.id == busId,
              orElse: () => Bus(
                  id: '',
                  name: '',
                  description: '',
                  storage: 0,
                  route: [],
                  seat: 0,
                  type: ''),
            );

            // If the bus was found, create the Chip, otherwise skip it
            if (bus != null) {
              return Chip(
                label: Text('Bus: ${bus.name}'),
                deleteIcon: Icon(Icons.clear),
                onDeleted: () {
                  setState(() {
                    selectedBusIds.remove(busId);
                    _filterTicketsByCriteria(); // Refresh the data
                  });
                },
              );
            } else {
              return SizedBox
                  .shrink(); // Return an empty widget if no bus is found
            }
          }).toList(),
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
                        _filterTicketsByCriteria(); // Update the ticket list with new filters
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

  void _sortTicketsByPrice({required bool ascending}) {
    setState(() {
      listTicket!.data.sort((a, b) {
        // Get the minimum price from the price list
        final aMinPrice = a.price.first;
        final bMinPrice = b.price.first;

        return ascending
            ? aMinPrice.compareTo(bMinPrice)
            : bMinPrice.compareTo(aMinPrice);
      });
    });
  }

  void _sortTicketsByDepartureTime({required bool earliest}) {
    setState(() {
      listTicket!.data.sort((a, b) {
        // Parse the departure time from the first element in the time list
        final aDepartureTime = DateTime.parse(a.time.first);
        final bDepartureTime = DateTime.parse(b.time.first);

        return earliest
            ? aDepartureTime.compareTo(bDepartureTime)
            : bDepartureTime.compareTo(aDepartureTime);
      });
    });
  }

  void _filterTicketsByCriteria() {
    setState(() {
      // Filter the listTicket based on the current filters
      listTicket!.data = _originalListTickets.where((ticket) {
        // Check 'from' location
        final fromIndex = selectedFrom != null && selectedFrom!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedFrom!.toLowerCase()))
            : -1;

        if (fromIndex != -1 && fromIndex == ticket.bus.route.length - 1) {
          return false; // Exclude if 'from' is the last stop
        }

        // Check 'to' location
        final toIndex = selectedTo != null && selectedTo!.isNotEmpty
            ? ticket.bus.route.indexWhere((route) =>
                route.toLowerCase().contains(selectedTo!.toLowerCase()))
            : -1;

        if (toIndex != -1 && toIndex == 0) {
          return false; // Exclude if 'to' is the first stop
        }

        if (selectedFrom != null &&
            selectedFrom!.isNotEmpty &&
            fromIndex == -1) {
          return false;
        }

        if (selectedTo != null && selectedTo!.isNotEmpty && toIndex == -1) {
          return false;
        }

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

        // Filter by selected buses
        if (selectedBusIds.isNotEmpty &&
            selectedBusIds[0] != "" &&
            !selectedBusIds.contains(ticket.busId)) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sort By',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Price Sorting Options
              ListTile(
                title: Text('Harga Termurah'),
                onTap: () {
                  _sortTicketsByPrice(ascending: true);
                  setState(() {
                    _activeSortType = 'price_asc'; // Set active sort type
                    _isAscending = true; // Set sorting order
                  });

                  Navigator.pop(context); // Close the modal
                },
                // enabled: _activeSortType !=
                //     'price_desc', // Disable if conflicting sort is active
              ),
              ListTile(
                title: Text('Harga Termahal'),
                onTap: () {
                  _sortTicketsByPrice(ascending: false);
                  setState(() {
                    _activeSortType = 'price_desc'; // Set active sort type
                    _isAscending = false; // Set sorting order
                  });

                  Navigator.pop(context); // Close the modal
                },
                // enabled: _activeSortType !=
                //     'price_asc', // Disable if conflicting sort is active
              ),
              // Departure Time Sorting Options
              ListTile(
                title: Text('Keberangkatan Paling Pagi'),
                onTap: () {
                  if (_activeSortType != 'departure_earliest') {
                    _sortTicketsByDepartureTime(earliest: true);
                    setState(() {
                      _activeSortType =
                          'departure_earliest'; // Set active sort type
                    });
                  }
                  Navigator.pop(context); // Close the modal
                },
                enabled: _activeSortType !=
                    'departure_latest', // Disable if conflicting sort is active
              ),
              ListTile(
                title: Text('Keberangkatan Paling Malam'),
                onTap: () {
                  if (_activeSortType != 'departure_latest') {
                    _sortTicketsByDepartureTime(earliest: false);
                    setState(() {
                      _activeSortType =
                          'departure_latest'; // Set active sort type
                    });
                  }
                  Navigator.pop(context); // Close the modal
                },
                enabled: _activeSortType !=
                    'departure_earliest', // Disable if conflicting sort is active
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBusFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pilih Bus',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      children: listBus!.data.map((bus) {
                        return CheckboxListTile(
                          title: Text(bus.name),
                          subtitle: Text(bus.description),
                          value: selectedBusIds.contains(bus.id),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selectedBusIds.isNotEmpty &&
                                  selectedBusIds[0] == "") {
                                selectedBusIds.removeAt(0);
                              }
                              if (selected == true) {
                                selectedBusIds.add(bus.id);
                              } else {
                                selectedBusIds.remove(bus.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _filterTicketsByCriteria();
                      Navigator.pop(context); // Close the modal
                      // _filterTicketsByBus();
                    },
                    child: Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Penumpang and Barang
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Tiket'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Penumpang'),
              Tab(text: 'Barang'),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildTicketList('penumpang'),
                  _buildTicketList('barang'),
                ],
              ),
      ),
    );
  }

  Widget _buildTicketList(String tipeIsi) {
    // Filter the list based on the tipeIsi value
    final filteredTickets =
        listTicket!.data.where((ticket) => ticket.tipeIsi == tipeIsi).toList();

    return RefreshIndicator(
      onRefresh: () async {
        await getData(); // Call your data retrieval method
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          _buildFilters(), // Filters appear at the top of each tab
          _buildActiveFilters(), // Active filters appear below filters
          filteredTickets.isEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('Tidak ada tiket ditemukan')),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Prevent nested scroll issues
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    return _buildBusCard(context, filteredTickets[index]);
                  },
                ),
        ],
      ),
    );
  }
}
