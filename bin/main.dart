import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Customer {
  String name;
  int age;
  String address;

  Customer(this.name, this.age, this.address);

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'address': address,
  };
}

final baseUrl = 'http://localhost:8888/api/customer';
Future<void> main() async {
  while (true) {
    print('\nChoose operation:');
    print('1. Create Customer');
    print('2. Read All Customers');
    print('3. Read Customer by ID');
    print('4. Update Customer');
    print('5. Delete Customer');
    print('0. Exit');

    var choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        await createCustomer();
        break;
      case 2:
        await readAllCustomers();
        break;
      case 3:
        await readCustomerById();
        break;
      case 4:
        await updateCustomer();
        break;
      case 5:
        await deleteCustomer();
        break;
      case 0:
        exit(0);
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> createCustomer() async {
  print('Enter customer details:');
  print('Name:');
  var name = stdin.readLineSync()!;
  print('Age:');
  var age = int.parse(stdin.readLineSync()!);
  print('Address:');
  var address = stdin.readLineSync()!;

  var customer = Customer(name, age, address);

  var response = await http.post(Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()));

  if (response.statusCode == 200) {
    print('Customer created successfully.');
  } else {
    print('Error creating customer. Status code: ${response.statusCode}');
  }
}

Future<void> readAllCustomers() async {
  var response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    var customers = jsonDecode(response.body);
    print('All Customers:');
    customers.forEach((customer) {
      print('ID: ${customer['id']}, Name: ${customer['name']}, Age: ${customer['age']}, Address: ${customer['address']}');
    });
  } else {
    print('Error reading customers. Status code: ${response.statusCode}');
  }
}

Future<void> readCustomerById() async {
  print('Enter customer ID:');
  var id = int.parse(stdin.readLineSync()!);

  var response = await http.get(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    var customer = jsonDecode(response.body);
    print('Customer Details:');
    print('ID: ${customer['id']}, Name: ${customer['name']}, Age: ${customer['age']}, Address: ${customer['address']}');
  } else {
    print('Error reading customer. Status code: ${response.statusCode}');
  }
}

Future<void> updateCustomer() async {
  print('Enter customer ID:');
  var id = int.parse(stdin.readLineSync()!);

  print('Enter new customer details:');
  print('Name:');
  var name = stdin.readLineSync()!;
  print('Age:');
  var age = int.parse(stdin.readLineSync()!);
  print('Address:');
  var address = stdin.readLineSync()!;

  var newCustomer = Customer(name, age, address);

  var response = await http.put(Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newCustomer.toJson()));

  if (response.statusCode == 200) {
    print('Customer updated successfully.');
  } else {
    print('Error updating customer. Status code: ${response.statusCode}');
  }
}

Future<void> deleteCustomer() async {
  print('Enter customer ID:');
  var id = int.parse(stdin.readLineSync()!);

  var response = await http.delete(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    print('Customer deleted successfully.');
  } else {
    print('Error deleting customer. Status code: ${response.statusCode}');
  }
}
