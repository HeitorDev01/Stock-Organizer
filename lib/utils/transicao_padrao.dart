import 'package:flutter/material.dart';

Route criarRotaPadrao(Widget pagina) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pagina,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define o ponto de origem (da direita para a esquerda)
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart; // Animação suave

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}