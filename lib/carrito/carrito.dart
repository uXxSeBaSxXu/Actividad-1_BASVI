import 'package:flutter/material.dart';
import 'package:basvi/model/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Carrito extends ChangeNotifier {
  Map<String, Item> _items = {};

  Map<String, Item> get items {
    return {..._items};
  }

  int get numeroItems {

    int cantidad = 0;

    _items.forEach((key, item) {

      cantidad += item.cantidad;

    });

    return cantidad;

  }

  double get subTotal {
    double total = 0.0;
    _items.forEach(
      (key, elemento) =>
          total += (elemento.precio * elemento.cantidad) as double,
    );
    return total;
  }

  double get impuesto {
    return subTotal * 0.16;
  }

  double get total {
    return subTotal + impuesto;
  }

  Future<void> cargarCarrito() async {

    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    final datos = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("carrito")
        .get();


    _items.clear();


    for(var doc in datos.docs){

      var item = doc.data();


      _items[doc.id] = Item(

        id: item["productoId"],
        nombre: item["nombre"],
        precio: item["precio"],
        unidad: item["unidad"],
        imagen: item["imagen"],
        cantidad: item["cantidad"],

      );

    }


    notifyListeners();

  }

  Future<void> confirmarCompra() async {

    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) return;

    final firestore = FirebaseFirestore.instance;

    final referenciaUsuario = firestore
        .collection("usuarios")
        .doc(usuario.uid);

    final pedido = {
      "usuarioId": usuario.uid,
      "correo": usuario.email ?? "",
      "fecha": Timestamp.now(),

      "productos": _items.values.map((item) {
        return {
          "productoId": item.id,
          "nombre": item.nombre,
          "precio": item.precio,
          "cantidad": item.cantidad,
          "imagen": item.imagen,
        };
      }).toList(),

      "total": total,
      "estado": "Pendiente",
    };

// Guardar historial del usuario
    final pedidoUsuario = await referenciaUsuario
        .collection("pedidos")
        .add(pedido);

// Guardar en colección global para el administrador
    await firestore
        .collection("pedidos")
        .add({
      ...pedido,
      "pedidoUsuarioId": pedidoUsuario.id,
    });

    // Borrar carrito de Firestore
    for (var item in _items.values) {
      await referenciaUsuario
          .collection("carrito")
          .doc(item.id)
          .delete();
    }

    // Limpiar carrito local
    _items.clear();
    notifyListeners();
  }

  Future<void> agregarItem(
      String productoId,
      String nombre,
      double precio,
      String unidad,
      String imagen,
      int cantidad,
      ) async {


    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    if(_items.containsKey(productoId)){

      cantidad = _items[productoId]!.cantidad + 1;

    }


    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("carrito")
        .doc(productoId)
        .set({

      "productoId": productoId,
      "nombre": nombre,
      "precio": precio,
      "unidad": unidad,
      "imagen": imagen,
      "cantidad": cantidad,

    });


    _items[productoId] = Item(

      id: productoId,
      nombre: nombre,
      precio: precio,
      unidad: unidad,
      imagen: imagen,
      cantidad: cantidad,

    );


    notifyListeners();

  }

  Future<void> removerItem(String productoId) async {


    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("carrito")
        .doc(productoId)
        .delete();


    _items.remove(productoId);


    notifyListeners();

  }

  Future<void> incrementarCantidadItem(String productoId) async {

    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    if(_items.containsKey(productoId)){

      final item = _items[productoId]!;

      final nuevaCantidad = item.cantidad + 1;


      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("carrito")
          .doc(productoId)
          .update({

        "cantidad": nuevaCantidad,

      });


      _items.update(
        productoId,
            (old) => Item(
          id: old.id,
          nombre: old.nombre,
          precio: old.precio,
          unidad: old.unidad,
          imagen: old.imagen,
          cantidad: nuevaCantidad,
        ),
      );


      notifyListeners();

    }

  }

  Future<void> decrementarCantidadItem(String productoId) async {


    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    if(!_items.containsKey(productoId)) return;


    final item = _items[productoId]!;


    if(item.cantidad > 1){

      final nuevaCantidad = item.cantidad - 1;


      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("carrito")
          .doc(productoId)
          .update({

        "cantidad": nuevaCantidad,

      });


      _items.update(
        productoId,
            (old) => Item(
          id: old.id,
          nombre: old.nombre,
          precio: old.precio,
          unidad: old.unidad,
          imagen: old.imagen,
          cantidad: nuevaCantidad,
        ),
      );


    } else {

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("carrito")
          .doc(productoId)
          .delete();


      _items.remove(productoId);

    }


    notifyListeners();

  }
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
