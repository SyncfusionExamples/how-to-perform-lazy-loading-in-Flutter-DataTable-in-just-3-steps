import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  Employee(this.employeeID, this.employeeName, this.designation,
      this.salary,
      {this.reference});

  double employeeID;

  String employeeName;

  String designation;

  double salary;

  DocumentReference? reference;

  factory Employee.fromSnapshot(DocumentSnapshot snapshot) {
    Employee newEmployee = Employee.fromJson(snapshot.data()!);
    newEmployee.reference = snapshot.reference;
    return newEmployee;
  }

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _employeeFromJson(json);

  Map<String, dynamic> toJson() => _employeeToJson(this);

  @override
  String toString() => 'employeeName $employeeName';
}

Employee _employeeFromJson(Map<String, dynamic> data) {
  return Employee(
    data['employeeID'],
    data['employeeName'],
    data['designation'],
    data['salary'],
  );
}

Map<String, dynamic> _employeeToJson(Employee instance) {
  return {
    'employeeID' : instance.employeeID,
    'employeeName': instance.employeeName,
    'designation': instance.designation,
    'salary': instance.salary,
  };
}
