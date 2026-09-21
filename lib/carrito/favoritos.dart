import 'package:flutter/material.dart';
import 'package:basvi/model/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favoritos extends ChangeNotifier {

  Map<String, Item> _items = {};


  Map<String, Item> get items {
    return {..._items};
  }


  int get numeroItems {
    return _items.length;
  }

  Future<void> cargarFavoritos() async {

    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;

    final datos = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("favoritos")
        .get();

    print("Favoritos encontrados: ${datos.docs.length}");

    for(var doc in datos.docs){
      print(doc.data());
    }

    _items.clear();


    for(var doc in datos.docs){

      var item = doc.data();


      _items[doc.id] = Item(

        id: item["productoId"].toString(),

        nombre: item["nombre"],

        precio: (item["precio"] as num).toDouble(),

        unidad: item["unidad"].toString(),

        imagen: item["imagen"],

        cantidad: item["cantidad"],

      );

    }


    notifyListeners();

  }

  Future<void> agregarFavorito(
      String productoId,
      String nombre,
      double precio,
      String unidad,
      String imagen,
      int cantidad,
      ) async {


    User? usuario = FirebaseAuth.instance.currentUser;

    print("Usuario actual: ${usuario?.uid}");

    if(usuario == null) return;


    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("favoritos")
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



  Future<void> removerFavorito(String productoId) async {


    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null) return;


    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("favoritos")
        .doc(productoId)
        .delete();


    _items.remove(productoId);


    notifyListeners();

  }



  bool esFavorito(String productoId){

    return _items.containsKey(productoId);

  }



  void removeAll(){

    _items.clear();

    notifyListeners();

  }

}