%{
/*-------------------------------------------------------------------*/
/* Partie Declaration : */
#include "Declaration.h"
#include "calavanc.tab.h"
#include <stdlib.h>
%}
/*-------------------------------------------------------------------*/
/* Partie Declaration expression regulière : */
blancs [\t]+
chiffre [0-9]
entier {chiffre}+
exposant [eE][+-]?{entier}
reel {entier}("."{entier})?{exposant}?
/*-------------------------------------------------------------------*/
/* Partie expression regulière : */
%%
{blancs} { /* On ignore */ }
{reel}+ { yylval=atof(yytext); return NOMBRE; }
"+" return PLUS;
"-" return MOINS;
"*" return FOIS;
"/" return DIVISE;
"^" return PUISSANCE;
"%" return MOD;
"abs" return ABS;
"sin" return SIN;
"cos" return COS;
"tan" return TAN;
"asin" return ASIN;
"acos" return ACOS;
"atan" return ATAN;
"sqrt" return SQRT;
"exp" return EXP;
"ln" return LN;
"log" return LOG;
"pi" return PI;
"," return VRLOG; // Virgule dans Log, par exemple : log(10,2)
"bin" return BINAIRE;
"hex" return HEX;
"oct"  return OCTAL;
"vrai" return VRAI;
"faux" return FAUX;
"||" return OU;
"&&" return ET;
"!" return NON;
"(" return PG;
")" return PD;
"<" return LT;
">" return GT;
"<=" return LE;
">=" return GE;
"==" return EQ;
"!=" return NE;
"\n" return FIN;
. {printf("Caractère non reconnu : %s\n", yytext);}
%%
