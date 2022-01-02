import 'dart:async';

import 'package:churrys_waffles/providers/order.dart';
import 'package:churrys_waffles/providers/products.dart';
import 'package:churrys_waffles/views/add_order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

import '../providers/orders.dart';
import '../components/commons/order_list.dart';

class History extends StatefulWidget {
  static const String id = '/history';
  final String? restorationId;

  const History({Key? key, this.restorationId}) : super(key: key);
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with RestorationMixin {
  List<Order> filteredOrders = [];
  final _directionController = TextEditingController();
  var _productSelection = '';
  var _paymentTypeSelection = '';
  RestorableDateTimeN _startDate = RestorableDateTimeN(DateTime(2022, 1, 1));
  RestorableDateTimeN _endDate = RestorableDateTimeN(DateTime(2022, 1, 5));

  @override
  String? get restorationId => widget.restorationId;

  @override
  void didChangeDependencies() {
    final orders = Provider.of<Orders>(context);
    final isInit = orders.initListHistoryOrders;
    if (!isInit) {
      setState(() {
        filteredOrders = filteringData(orders.deliveredOrders, context);
        _startDate = RestorableDateTimeN(filteredOrders.first.createdAt);
        _endDate = RestorableDateTimeN(filteredOrders.last.createdAt);
        orders.setinitListHistoryOrders(true);
      });
    }
    super.didChangeDependencies();
  }

  late final RestorableRouteFuture<DateTimeRange?>
      _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          fieldStartHintText: 'Seleccione una fecha',
          fieldEndHintText: 'Selecciones una fecha',
          fieldStartLabelText: 'Inicio',
          fieldEndLabelText: 'Fin',
          saveText: 'Guardar',
          helpText: 'Seleccionar Fecha',
          confirmText: 'Confirmar',
          cancelText: 'Cancelar',
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(2022, 1, 1),
          currentDate: DateTime(2022, 6, 15),
          lastDate: DateTime(2030),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  void setCurrentFilter() {
    Provider.of<Orders>(context, listen: false).setFilters({
      "direction": _directionController.text.toLowerCase(),
      "product": _productSelection,
      "paymentType": _paymentTypeSelection.toLowerCase(),
      "startDate": _startDate.value,
      "endDate": _endDate.value,
    });
  }

  List<Order> filteringData(
      List<Order> iniFilteredOrders, BuildContext context) {
    final filters = Provider.of<Orders>(context, listen: false).filters;
    if (filters.isEmpty) {
      return iniFilteredOrders;
    } else {
      final direction = filters["direction"];
      final product = filters["product"];
      final paymentType = filters["paymentType"];
      final startDate = filters["startDate"];
      final endDate = filters["endDate"];
      final orders = iniFilteredOrders.where((order) {
        if (direction != '' &&
            !order.direction.toLowerCase().contains(direction)) {
          return false;
        }

        if (product != '' &&
            !order.products
                .map((product) => product.name)
                .toList()
                .contains(product)) {
          return false;
        }

        if (paymentType != '' &&
            !order.paymentType.toLowerCase().contains(paymentType)) {
          return false;
        }
        if (order.createdAt.isBefore(startDate) ||
            order.createdAt.isAfter(endDate.add(const Duration(hours: 24)))) {
          return false;
        }

        return true;
      }).toList();
      return orders;
    }
  }

  Future<void> buildOverlayCircularProgress(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.of(context).pop(true);
        });
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;

    final AlertDialog dialog = AlertDialog(
      title: const Text('Filtros'),
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  controller: _directionController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SmartSelect<String>.single(
                  placeholder: 'Selecciona',
                  title: 'Producto',
                  value: 'Producto',
                  choiceItems: products
                      .map((product) => S2Choice<String>(
                          value: product.name, title: product.name))
                      .toList(),
                  onChange: (state) {
                    _productSelection = state.value;
                  }),
              const SizedBox(
                height: 15,
              ),
              SmartSelect<String>.single(
                  placeholder: 'Selecciona',
                  title: 'Tipo de Pago',
                  value: 'Tipo de Pago',
                  choiceItems: [
                    S2Choice<String>(value: 'E', title: 'Efectivo'),
                    S2Choice<String>(value: 'T', title: 'Transferencia'),
                  ],
                  onChange: (state) {
                    _paymentTypeSelection = state.value;
                  }),
              const SizedBox(
                height: 15,
              ),
              OutlinedButton(
                onPressed: () {
                  _restorableDateRangePickerRouteFuture.present();
                },
                child: const Text('Seleccionar Rango de Fecha'),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.resolveWith((_) => Colors.black),
              backgroundColor:
                  MaterialStateProperty.resolveWith((_) => Colors.red)),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.resolveWith((_) => Colors.black),
              backgroundColor:
                  MaterialStateProperty.resolveWith((_) => Colors.green)),
          onPressed: () {
            setCurrentFilter();
            final orders = filteringData(
                Provider.of<Orders>(context, listen: false).deliveredOrders,
                context);
            setState(() {
              filteredOrders = orders;
            });
            Navigator.pop(context);
            buildOverlayCircularProgress(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.filter_list_rounded),
          onPressed: () {
            setState(() {
              _directionController.clear();
              _productSelection = '';
              _paymentTypeSelection = '';
            });
            showDialog(builder: (context) => dialog, context: context);
          },
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: Title(
                    color: Colors.black,
                    child: const Text(
                      'Historial de Pedidos',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              OrderList(
                orders: filteredOrders,
              ),
            ],
          ),
        ));
  }
}
