import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basvi/colors.dart';

class PantallaUsuario extends StatelessWidget {
  const PantallaUsuario({super.key});

  @override
  Widget build(BuildContext context) {

    User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mi usuario",
          style: TextStyle(color: Colors.white),
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

      :StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("usuarios")
            .doc(usuario.uid)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("No se encontraron datos"),
            );
          }


          final datos = snapshot.data!.data()!;


          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigoAccent,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),


                const SizedBox(height: 30),


                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Nombre"),
                    subtitle: Text(datos["nombre"]),
                  ),
                ),


                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Correo"),
                    subtitle: Text(datos["correo"]),
                  ),
                ),


                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Teléfono"),
                    subtitle: Text(datos["telefono"]),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}