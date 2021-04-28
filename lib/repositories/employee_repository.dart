import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/employee.dart';

class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource() {
    collection = FirebaseFirestore.instance.collection('employees');
  }

  late CollectionReference collection;

  static const double perPage = 50;

  List<Employee> employees = [];

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == 'employeeID' ||
          dataGridCell.columnName == 'salary') {
        return Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            (dataGridCell.columnName == 'salary')
                ? NumberFormat.currency(locale: 'en_US', symbol: '\$')
                    .format(dataGridCell.value)
                    .toString()
                : dataGridCell.value.toInt().toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis),
      );
    }).toList());
  }

  void addDataGridRow(Employee data) {
    dataGridRows.add(DataGridRow(cells: [
      DataGridCell<double>(columnName: 'employeeID', value: data.employeeID),
      DataGridCell<String>(
          columnName: 'employeeName', value: data.employeeName),
      DataGridCell<String>(columnName: 'designation', value: data.designation),
      DataGridCell<double>(columnName: 'salary', value: data.salary),
    ]));
  }

  Future loadMoreDataFromStream() async {
    final stream = collection
        .where('employeeID',
            isGreaterThan:
                employees.isEmpty ? 1000.0 : employees.last.employeeID,
            isLessThan: employees.isEmpty
                ? 1000.0 + perPage
                : employees.last.employeeID + perPage)
        .snapshots();

    stream.listen((snapShot) async {
      await Future.forEach(snapShot.docs, (DocumentSnapshot element) {
        final Employee data = Employee.fromSnapshot(element);
        if (!employees
            .any((element) => element.employeeID == data.employeeID)) {
          employees.add(data);
          addDataGridRow(data);
        }
      });

      updateDataGridDataSource();
    });
  }

  @override
  Future<void> handleLoadMoreRows() async {
    /// Perform delay to load the data to show the loading indicator if required
    await Future.delayed(const Duration(milliseconds: 500), () {
      loadMoreDataFromStream();
    });
  }

  void updateDataGridDataSource() {
    notifyListeners();
  }
}
