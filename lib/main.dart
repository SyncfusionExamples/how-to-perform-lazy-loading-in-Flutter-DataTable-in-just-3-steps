import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_datagrid_loadmore/repositories/employee_repository.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SfDataGridLoadMoreApp());
}

class SfDataGridLoadMoreApp extends StatelessWidget {
  final EmployeeDataGridSource employeeDataGridSource =
      EmployeeDataGridSource();

  SfDataGridLoadMoreApp() {
    employeeDataGridSource.loadMoreDataFromStream();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DataGrid Lazy Loading'),
        ),
        body: SfDataGrid(
          source: employeeDataGridSource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridTextColumn(
                columnName: 'employeeID',
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                  alignment: Alignment.centerRight,
                )),
            GridTextColumn(
                columnName: 'employeeName',
                label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Name',
                      overflow: TextOverflow.ellipsis,
                    ),
                    alignment: Alignment.centerLeft)),
            GridTextColumn(
                columnName: 'designation',
                label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Role',
                      overflow: TextOverflow.ellipsis,
                    ),
                    alignment: Alignment.centerLeft)),
            GridTextColumn(
                columnName: 'salary',
                label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Salary',
                      overflow: TextOverflow.ellipsis,
                    ),
                    alignment: Alignment.centerRight)),
          ],
          loadMoreViewBuilder: loadMoreButtonBuilder,
        ),
      ),
    );
  }

  /// Hook this builder for apply the infinite scrolling support
  Widget loadMoreInfiniteBuilder(
      BuildContext context, LoadMoreRows loadMoreRows) {
    Future<String> loadRows() async {
      await loadMoreRows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
        initialData: 'loading',
        future: loadRows(),
        builder: (context, snapShot) {
          if (snapShot.data == 'loading') {
            return Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        top: BorderSide(
                            width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepPurple)));
          } else {
            return SizedBox.fromSize(size: Size.zero);
          }
        });
  }

  /// Hook this builder for apply the load more
  Widget loadMoreButtonBuilder(BuildContext context, LoadMoreRows loadMoreRows) {
    bool showIndicator = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter innerSetState) {
      if (showIndicator) {
        return Container(
            height: 60.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                    top: BorderSide(
                        width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.deepPurple)));
      } else {
        return Container(
          height: 60.0,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: BorderDirectional(
                  top: BorderSide(
                      width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
          child: Container(
            height: 36.0,
            width: 142.0,
            child: MaterialButton(
                color: Colors.deepPurple,
                child: Text('LOAD MORE', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  innerSetState(() {
                    showIndicator = true;
                  });

                  await loadMoreRows();

                  innerSetState(() {
                    showIndicator = false;
                  });
                }),
          ),
        );
      }
    });
  }
}
