import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CarFilterScreen extends StatefulWidget {
  @override
  _CarFilterScreenState createState() => _CarFilterScreenState();
}

class _CarFilterScreenState extends State<CarFilterScreen> {
  // Controllers cho các trường input
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _gearController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  bool _hasDriver = false;

  // Danh sách kết quả
  List<dynamic> _filteredCars = [];
  bool _isLoading = false;

  // Hàm gọi API để lấy dữ liệu
  Future<void> _fetchFilteredCars() async {
    setState(() => _isLoading = true);
    
    try {
      final queryParams = {
        if (_companyController.text.isNotEmpty) 'company': _companyController.text,
        if (_seatController.text.isNotEmpty) 'seat': _seatController.text,
        if (_gearController.text.isNotEmpty) 'gear': _gearController.text,
        if (_fuelController.text.isNotEmpty) 'fuel': _fuelController.text,
        'hasDriver': _hasDriver.toString(),
      };

      final uri = Uri.https('your-api-domain.com', '/api/cars', queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          _filteredCars = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Filter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Company TextField
                TextField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // Seat TextField
                TextField(
                  controller: _seatController,
                  decoration: InputDecoration(
                    labelText: 'Seat',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),

                // Gear TextField
                TextField(
                  controller: _gearController,
                  decoration: InputDecoration(
                    labelText: 'Gear',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // Fuel TextField
                TextField(
                  controller: _fuelController,
                  decoration: InputDecoration(
                    labelText: 'Fuel',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // HasDriver Switch
                SwitchListTile(
                  title: Text('Has Driver'),
                  value: _hasDriver,
                  onChanged: (value) {
                    setState(() => _hasDriver = value);
                  },
                ),

                // Search Button
                ElevatedButton(
                  onPressed: _fetchFilteredCars,
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCars.length,
                    itemBuilder: (context, index) {
                      final car = _filteredCars[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(car['company'] ?? ''),
                          subtitle: Text(
                            'Seats: ${car['seat']} | Gear: ${car['gear']} | Fuel: ${car['fuel']}',
                          ),
                          trailing: Icon(
                            car['hasDriver'] ? Icons.person : Icons.person_off,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _companyController.dispose();
    _seatController.dispose();
    _gearController.dispose();
    _fuelController.dispose();
    super.dispose();
  }
}