import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PantallaAdmin extends StatelessWidget {
  const PantallaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pedidos")
            .orderBy("fecha", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text("Ocurrió un error"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pedidos = snapshot.data!.docs;

          if (pedidos.isEmpty) {
            return const Center(
              child: Text("No hay pedidos"),
            );
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {

              final pedido =
              pedidos[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(pedido["correo"] ?? ""),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Total: \$${pedido["total"]}"),

                      DropdownButton<String>(
                        value: pedido["estado"],
                        isExpanded: true,
                        items: const [

                          DropdownMenuItem(
                            value: "Pendiente",
                            child: Text("Pendiente"),
                          ),

                          DropdownMenuItem(
                            value: "Preparando",
                            child: Text("Preparando"),
                          ),

                          DropdownMenuItem(
                            value: "En camino",
                            child: Text("En camino"),
                          ),

                          DropdownMenuItem(
                            value: "Entregado",
                            child: Text("Entregado"),
                          ),

                        ],
                        onChanged: (nuevoEstado) async {

                          if (nuevoEstado == null) return;

                          // Actualizar pedido global
                          await FirebaseFirestore.instance
                              .collection("pedidos")
                              .doc(pedidos[index].id)
                              .update({
                            "estado": nuevoEstado,
                          });

                          // Actualizar pedido del cliente
                          await FirebaseFirestore.instance
                              .collection("usuarios")
                              .doc(pedido["usuarioId"])
                              .collection("pedidos")
                              .doc(pedido["pedidoUsuarioId"])
                              .update({
                            "estado": nuevoEstado,
                          });

                        },
                      ),

                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}