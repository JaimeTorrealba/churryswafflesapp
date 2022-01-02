import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:churrys_waffles/providers/order.dart';
import '../../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  Future<void> buildOverlayCircularProgress(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> familyButtons(BuildContext context, Order order) {
    List<Widget> buttons = [];
    if (!order.isPaid && !order.isDelivered) {
      buttons.add(
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.green[600]),
          ),
          child: const Text('Pagado'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .setStatusOrder(widget.order.id, false, true);
          },
        ),
      );
      buttons.add(
        ElevatedButton(
          child: const Text('Eliminar'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .deleteOrder(widget.order);
          },
        ),
      );
    }

    if (order.isPaid && !order.isDelivered) {
      buttons.add(
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.green[600]),
          ),
          child: const Text('Entregado'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .setStatusOrder(widget.order.id, true, true);
          },
        ),
      );
      buttons.add(
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.orange[600]),
          ),
          child: const Text('A Pagar'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .setStatusOrder(widget.order.id, false, false);
          },
        ),
      );

      buttons.add(
        ElevatedButton(
          child: const Text('Eliminar'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .deleteOrder(widget.order);
          },
        ),
      );
    }

    if (order.isPaid && order.isDelivered) {
      buttons.add(
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.orange[600]),
          ),
          child: const Text('A Entregar'),
          autofocus: false,
          onPressed: () {
            buildOverlayCircularProgress(context);
            Provider.of<Orders>(context, listen: false)
                .setStatusOrder(widget.order.id, false, true);
          },
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: const Icon(
              Icons.restaurant_rounded,
              size: 60,
              color: Colors.red,
            ),
            title: Text(
              widget.order.direction,
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
                'Fecha de Orden: ${DateFormat('dd/MM hh:mm').format(widget.order.createdAt)}\nTipo de Pago: ${Order.paymentTypes[widget.order.paymentType]}\nCantidad de Productos: ${widget.order.quantity}\nPrecio: \$ ${widget.order.price}'),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              size: 40,
            ),
            isThreeLine: true,
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Column(
                children: [
                  ...widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price} = ${prod.quantity * prod.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: familyButtons(context, widget.order),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
