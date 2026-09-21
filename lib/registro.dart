import 'package:flutter/material.dart';
import 'package:basvi/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basvi/login.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmarPassword = true;
  bool cargando = false;

  Future<void> registrarUsuario() async {
    if (cargando) return;

    final nombre = nombreController.text.trim();
    final telefono = telefonoController.text.trim();
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();
    final confirmarPassword =
    confirmarPasswordController.text.trim();

    // Validación de campos del formulario
    if (nombre.isEmpty ||
        telefono.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmarPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Completa todos los campos"),
        ),
      );
      return;
    }

    // Validar correo
    if (!correo.contains("@") || !correo.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Ingresa un correo válido"),
        ),
      );
      return;
    }

    // Validar contraseña
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "La contraseña debe tener al menos 6 caracteres",
          ),
        ),
      );
      return;
    }

    // Confirmar contraseña
    if (password != confirmarPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Las contraseñas no coinciden"),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      // ==========================================
      // 1. CREAR USUARIO EN FIREBASE AUTHENTICATION
      // ==========================================

      print("=================================");
      print("INICIANDO REGISTRO");
      print("Correo: $correo");
      print("=================================");

      final UserCredential resultado =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );

      final User? usuario = resultado.user;

      if (usuario == null) {
        throw Exception("Firebase no devolvió ningún usuario.");
      }

      print("=================================");
      print("USUARIO CREADO EN AUTHENTICATION");
      print("UID: ${usuario.uid}");
      print("Correo: ${usuario.email}");
      print("=================================");

      // ==========================================
      // 2. GUARDAR DATOS EN FIRESTORE
      // ==========================================

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(usuario.uid)
          .set({
        "nombre": nombre,
        "telefono": telefono,
        "correo": correo,
        "rol": "cliente",
        "fechaRegistro": FieldValue.serverTimestamp(),
      });

      print("=================================");
      print("DATOS GUARDADOS EN FIRESTORE");
      print("=================================");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Usuario creado correctamente en Firebase",
          ),
        ),
      );

      // Volver al Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("=================================");
      print("ERROR EN FIREBASE AUTHENTICATION");
      print("Código: ${e.code}");
      print("Mensaje: ${e.message}");
      print("=================================");

      String mensaje = "Error al crear la cuenta.";

      if (e.code == "email-already-in-use") {
        mensaje = "Este correo ya está registrado.";
      } else if (e.code == "invalid-email") {
        mensaje = "El correo no es válido.";
      } else if (e.code == "weak-password") {
        mensaje = "La contraseña es demasiado débil.";
      } else if (e.code == "operation-not-allowed") {
        mensaje =
        "El registro por correo no está habilitado en Firebase.";
      } else if (e.code == "network-request-failed") {
        mensaje =
        "No hay conexión a Internet. Revisa tu conexión.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(mensaje),
        ),
      );
    } on FirebaseException catch (e) {
      print("=================================");
      print("ERROR DE FIREBASE");
      print("Código: ${e.code}");
      print("Mensaje: ${e.message}");
      print("=================================");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Error de Firebase: ${e.message ?? e.code}",
          ),
        ),
      );
    } catch (e) {
      print("=================================");
      print("ERROR GENERAL");
      print(e);
      print("=================================");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secundary,
            ],
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
                      Image.asset(
                        "assets/img/basvi_logo.png",
                        height: 140,
                      ),

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
                        "Regístrate para continuar",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // NOMBRE
                      TextField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          hintText: "Nombre",
                          prefixIcon: const Icon(
                            Icons.drive_file_rename_outline_sharp,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TELEFONO
                      TextField(
                        controller: telefonoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Teléfono",
                          prefixIcon: const Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CORREO
                      TextField(
                        controller: correoController,
                        keyboardType: TextInputType.emailAddress,
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

                      // CONTRASEÑA
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
                                ocultarPassword =
                                !ocultarPassword;
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

                      const SizedBox(height: 20),

                      // CONFIRMAR CONTRASEÑA
                      TextField(
                        controller: confirmarPasswordController,
                        obscureText: ocultarConfirmarPassword,
                        decoration: InputDecoration(
                          hintText: "Confirmar contraseña",
                          prefixIcon:
                          const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              ocultarConfirmarPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                ocultarConfirmarPassword =
                                !ocultarConfirmarPassword;
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

                      // BOTÓN REGISTRARSE
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                          cargando ? null : registrarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                          child: cargando
                              ? const SizedBox(
                            width: 25,
                            height: 25,
                            child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                              : const Text(
                            "REGISTRATE",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // IR AL LOGIN
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "¿Ya tienes cuenta? ",
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const Login(),
                                ),
                              );
                            },
                            child:
                            const Text("Iniciar sesión"),
                          ),
                        ],
                      ),

                      const Text(
                        "BASVI © 1985",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
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