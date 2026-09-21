import 'package:basvi/pantallaCarta.dart';
import 'package:flutter/material.dart';
import 'package:basvi/colors.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Container(
                    padding: EdgeInsets.only(right: 5,left: 5, top: 50, bottom: 50),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(200),
                      )
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Lo mejor desde 1985",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PlayfairDisplay', // Cambia el tipo de letra (va entre comillas)
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 10),
                ),
                Center(
                  child: Image.asset("assets/img/basvi_logo.png",
                    width: MediaQuery.of(context).size.width/2,
                    height: 300,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), //  CORRECTO: Ahora está dentro de styleFrom
                    padding: const EdgeInsets.all(13), // Opcional: Le da un tamaño uniforme al círculo
                    backgroundColor: Colors.black,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext) => PantallaCarta(),
                      )
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
