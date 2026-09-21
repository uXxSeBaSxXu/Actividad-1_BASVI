import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basvi/colors.dart';


class PantallaPedidos extends StatelessWidget {

  const PantallaPedidos({super.key});


  @override
  Widget build(BuildContext context) {


    User? usuario = FirebaseAuth.instance.currentUser;

    Color _colorEstado(String estado) {
      switch (estado) {
        case "Pendiente":
          return Colors.orangeAccent;

        case "Preparando":
          return Colors.blue;

        case "En camino":
          return Colors.deepPurple;

        case "Entregado":
          return Colors.green;

        default:
          return Colors.black;
      }
    }

    return Scaffold(

      backgroundColor: AppColors.fondo,

      appBar: AppBar(
        title: const Text(
          "Mis pedidos",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: AppColors.primary,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),


      body: usuario == null

          ? const Center(
        child: Text("No hay usuario iniciado"),
      )


          : StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("usuarios")
            .doc(usuario.uid)
            .collection("pedidos")
            .orderBy(
          "fecha",
          descending: true,
        )
            .snapshots(),


        builder: (context, snapshot) {


          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(),
            );

          }



          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){

            return const Center(
              child: Text(
                "No tienes pedidos todavía",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );

          }



          return ListView.builder(

            padding: const EdgeInsets.all(12),

            itemCount: snapshot.data!.docs.length,


            itemBuilder: (context,index){


              var pedido = snapshot.data!.docs[index];


              var datos = pedido.data()
              as Map<String,dynamic>;



              return Card(

                elevation: 4,

                margin: const EdgeInsets.only(
                  bottom: 15,
                ),


                child: ExpansionTile(

                  leading: const Icon(
                    Icons.shopping_bag,
                    color: AppColors.primary,
                  ),


                  title: Text(
                    "Pedido #${pedido.id.substring(0,5)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Total: \$${datos["total"].toStringAsFixed(2)}",
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Estado: ${datos["estado"]}",
                        style: TextStyle(
                          color: _colorEstado(datos["estado"]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),



                  children: [


                    ...(datos["productos"] as List)
                        .map((producto){


                      return ListTile(

                        title: Text(
                          producto["nombre"],
                        ),

                        subtitle: Text(
                          "Cantidad: ${producto["cantidad"]}",
                        ),


                        trailing: Text(
                          "\$${producto["precio"]}",
                        ),

                      );


                    }).toList(),



                    const Divider(),


                    Padding(

                      padding: const EdgeInsets.all(12),

                      child: Text(
                        "Fecha: ${datos["fecha"].toDate()}",
                      ),

                    ),


                  ],

                ),

              );


            },

          );


        },

      ),

    );

  }

}