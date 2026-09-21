import 'package:basvi/pantallaAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basvi/pantallaInicio.dart';
import 'package:basvi/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basvi/registro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  bool ocultarPassword = true;

  Future<void> iniciarSesion() async {
    try {
      UserCredential resultado =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usuarioController.text.trim(),
        password: passwordController.text.trim(),
      );


      User? usuario = resultado.user;


      if(usuario != null){

        DocumentSnapshot datos = await FirebaseFirestore.instance
            .collection("usuarios")
            .doc(usuario.uid)
            .get();


        String rol = datos["rol"];


        if(rol == "admin"){

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PantallaAdmin(),
            ),
          );


        } else {


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PantallaInicio(),
            ),
          );


        }

      }

    } on FirebaseAuthException catch (e) {

      String mensaje = "Error al iniciar sesión";

      if (e.code == 'user-not-found') {
        mensaje = "El usuario no existe";
      }
      else if (e.code == 'wrong-password') {
        mensaje = "Contraseña incorrecta";
      }
      else if (e.code == 'invalid-email') {
        mensaje = "Correo inválido";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(mensaje),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secundary ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/img/basvi_logo.png", height: 140),

                      const SizedBox(height: 15),

                      const Text(
                        "Bienvenido",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Inicia sesión para continuar",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: usuarioController,
                        decoration: InputDecoration(
                          hintText: "Correo",
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: passwordController,
                        obscureText: ocultarPassword,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              ocultarPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                ocultarPassword = !ocultarPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "INICIAR SESIÓN",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Text("¿No tienes cuenta? "),
                        Container(
                          child: TextButton(onPressed: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext) => const Registro(),
                                ),
                            );
                          },
                            child: const Text("Registrate"),
                          ),
                        )
                      ]),
                      const Text(
                        "BASVI © 1985",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
