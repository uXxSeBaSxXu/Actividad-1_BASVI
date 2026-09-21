import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basvi/carrito/carrito.dart';
import 'package:basvi/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaCarrito extends StatefulWidget {

  const PantallaCarrito({super.key});

  @override
  State<PantallaCarrito> createState() => _PantallaCarritoState();

}

class _PantallaCarritoState extends State<PantallaCarrito> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      Provider.of<Carrito>(
        context,
        listen: false,
      ).cargarCarrito();

    });

  }

  Future<String?> obtenerTelefonoUsuario() async {

    User? usuario = FirebaseAuth.instance.currentUser;

    if(usuario == null){
      return null;
    }


    DocumentSnapshot datos = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .get();


    if(datos.exists){

      return datos["telefono"];

    }


    return null;

  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<Carrito>(context);

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text("Carrito",
              style: TextStyle(color: Colors.white),
          )
      ),

      body:carrito.items.isEmpty
          ? Center(
        child: Text(
          "No tienes articulos",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ):
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carrito.items.length,
              itemBuilder: (context, index) {
                final item = carrito.items.values.toList()[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            "assets/img/${item.imagen}",
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nombre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "${item.cantidad} x \$${item.precio}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.secundary,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton( icon: Icon(Icons.remove, size: 16, color: Colors.white,),
                                      onPressed: () async{
                                      await carrito.decrementarCantidadItem(item.id);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    child: Center(child: Text(
                                      item.cantidad.toString(),
                                      style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                       ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton( icon: Icon(Icons.add, size: 16, color: Colors.white,),
                                      onPressed: () async{
                                      await carrito.incrementarCantidadItem(item.id);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            carrito.removerItem(item.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 80),
            child: Column(
              children: [
                Text(
                  "Subtotal: \$${carrito.subTotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18),
                ),

                Text(
                  "IVA: \$${carrito.impuesto.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18),
                ),

                Text(
                  "Total: \$${carrito.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      String pedido = "";
                      carrito.items.forEach((key, value){
                        pedido = '$pedido' +
                            value.nombre + " CANTIDAD "+ value.cantidad.toString()+"\n"+
                            " PRECIO UNITARIO " + "\$" + value.precio.toString() + "\n" +
                            " PRECIO TOTAL "  + "\$" + (value.cantidad * value.precio).toStringAsFixed(2)+ "\n"
                            "\n************************\n";
                      });
                      pedido = '$pedido' + "SUBTOTAL " + "\$" +carrito.subTotal.toStringAsFixed(2)+"\n";
                      pedido = '$pedido' + "IVA " + "\$" +carrito.impuesto.toStringAsFixed(2)+"\n";
                      pedido = '$pedido' + "TOTAL " + "\$" +carrito.total.toStringAsFixed(2)+"\n";

                      //print(pedido);

                      final String? celular = await obtenerTelefonoUsuario();
                      if(celular == null){
                        return;
                      }
                      final String mensaje = Uri.encodeComponent(pedido);

                      final Uri url = Uri.parse(
                        "https://wa.me/$celular?text=$mensaje",
                      );

                      print(url);

                      if (await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        // Se abrió correctamente
                      } else {
                        throw Exception("No se pudo abrir WhatsApp");
                      }

                      await carrito.confirmarCompra();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("✅ Tu compra se realizó con éxito"),
                        ),
                      );
                    },
                    child: const Text("COMPRAR", style: TextStyle(color: Colors.white,)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
