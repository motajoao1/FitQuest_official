import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RPGTheme {
  // Paleta de Cores D&D Taverna
  static const Color parchmentBackground = Color(0xFFF1E4C3); // Pergaminho envelhecido
  static const Color inkDark = Color(0xFF3E2723); // Tinta marrom muito escura (quase preto)
  static const Color woodMedium = Color(0xFF5D4037); // Madeira da taverna
  static const Color leatherLight = Color(0xFF8D6E63); // Couro claro para bordas
  static const Color potionRed = Color(0xFFB71C1C); // Vermelho poção de vida/erro

  static ThemeData get tavernTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: parchmentBackground,
      colorScheme: const ColorScheme.light(
        primary: woodMedium,
        secondary: leatherLight,
        surface: parchmentBackground,
        error: potionRed,
        onPrimary: Colors.white,
        onSecondary: inkDark,
        onSurface: inkDark,
      ),
      
      // Barra superior estilo viga de madeira
      appBarTheme: AppBarTheme(
        backgroundColor: woodMedium,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: parchmentBackground),
        titleTextStyle: GoogleFonts.medievalSharp(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: parchmentBackground,
          letterSpacing: 1.2,
        ),
      ),
      
      // Menu inferior de navegação
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: woodMedium,
        selectedItemColor: parchmentBackground,
        unselectedItemColor: leatherLight,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 8,
      ),
      
      // Cards com cara de pedaços de pergaminho recortados
      cardTheme: CardThemeData(
        color: const Color(0xFFFAF0D9), // Um tom levemente mais claro que o fundo para destacar
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: leatherLight, width: 2), // Borda de couro
          borderRadius: BorderRadius.circular(6), // Levemente arredondado, mas rústico
        ),
      ),
      
      // Fontes medievais e cartunescas
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.medievalSharp(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: inkDark,
        ),
        headlineMedium: GoogleFonts.medievalSharp(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: inkDark,
        ),
        titleLarge: GoogleFonts.macondo( // Macondo é ótima para corpo de texto com cara de fantasia
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: inkDark,
        ),
        bodyLarge: GoogleFonts.macondo(
          fontSize: 18,
          color: inkDark,
        ),
        bodyMedium: GoogleFonts.macondo(
          fontSize: 16,
          color: woodMedium,
        ),
      ),
      
      // Divisórias das telas
      dividerTheme: const DividerThemeData(
        color: leatherLight,
        thickness: 1.5,
      ),
      
      // Botões padronizados com cara de placa de madeira
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: woodMedium,
          foregroundColor: parchmentBackground,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.medievalSharp(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}