%{
//------------------------------------------------------------------
//Partie declaration globale et les bibliothèques :
#include "Declaration.h" // fichier externe "Declaration" variable
#include <stdio.h>
#include <stdlib.h>
#define Pi 3.14159265358979323846
#define E 2.71828182845904523536

//Les Fonctions :
double puissance(double x, int n){
	double result = 1;
	int i;
	for(i = 1; i <= n ; i++){
		result = result * x ;
	}
	return result;
}

double racine(double x){
	double i;
	double diff;
	if(x == 0 || x == 1){
		return(x);
	}else{
		i = x;
		do{
			diff = i;
			i= 0.5 * (i + x / i); 
		}while(i != diff);
	return (i);
	}
}

double sin_calc(double x) { // en Radiane
	double result = x;
	int i;
	for (i = 3; i < 10; i+=2) {
		result += puissance(-1, i) * puissance(x, i) / factorial(i);
	}
	return result;
}

double cos_calc(double x) { // en Radiane
	double result = 1;
	int i;
	for (i = 2; i < 10; i+=2) {
		result += puissance(-1, i) * puissance(x, i) / factorial(i);
	}
	return result;
}

double tan_calc(double x) { // en Radiane
	return sin_calc(x) / cos_calc(x);
}

double arcsin_calc(double x) { // en Radiane
	double result = x;
	int i;
	for (i = 3; i < 10; i+=2) {
		result += puissance(x, i) / (i * (i+1));
	}
	return result;
}

double arccos_calc(double x) { // en Radiane
	return (Pi/2 - arcsin_calc(x));
}

double arctan_calc(double x) { // en Radiane
	double result = x;
	int i;
	for (i = 3; i < 10; i+=2) {
		result += puissance(-1, (i-1)/2) * puissance(x, i) / i;
}
	return result;
}

int factorial(int x) {
	if (x == 0) {
		return 1;
	} else {
		return x * factorial(x-1);
	}
}

%}
//--------------------------------------------------------------
//Partie declarations des tokens :
%token NOMBRE
%token PLUS MOINS FOIS DIVISE PUISSANCE
%token ABS SIN COS TAN ASIN ACOS ATAN SQRT EXP LN LOG
%token VRAI FAUX OU ET NON LT GT LE GE EQ NE
%token PI
%token VRLOG
%token BINAIRE HEX OCTAL
%token PG PD
%token FIN

%left PLUS MOINS
%left FOIS DIVISE
%left MOD
%left NEG
%right PUISSANCE

%start Input //Axiome "Input"
%%
//--------------------------------------------------------------
//Partie Grammaire :
Input:
	/* Vide */
	|Input Ligne
	;

Ligne:
	FIN
	|BINAIRE PG Expression PD {
		int num = (int) $1;
		char result[32];
		int i = 0;
		while (num > 0) {
			result[i] = (num % 2) + '0';
			num /= 2;
			i++;
		}
		result[i] = '\0';
		printf("Resultat: ");
		for (i = strlen(result)-1; i >= 0; i--) {
			printf("%c", result[i]);
		}
			printf("\n");
		}
	|HEX PG Expression PD {
		int num = (int) $1;
		char result[32];
		int i = 0;
		while (num > 0) {
			int rem = num % 16;
			if (rem < 10) {
				result[i] = rem + '0';
			} else {
				result[i] = (rem-10) + 'A';
			}
			num /= 16;
			i++;
		}
		result[i] = '\0';
		printf("Resultat: ");
		for (i = strlen(result)-1; i >= 0; i--) {
			printf("%c", result[i]);
		}
		printf("\n");
		}
	|OCTAL PG Expression PD {
		int num = (int) $1;
		char result[32];
		int i = 0;
		while (num > 0) {
			result[i] = (num % 8) + '0';
			num /= 8;
			i++;
		}
		result[i] = '\0';
		printf("Resultat: ");
		for (i = strlen(result)-1; i >= 0; i--) {
			printf("%c", result[i]);
		}
		printf("\n");
		}
	|PI {
    		printf("Resultat: %f\n",Pi);
    	}
    	|EXP {
    		printf("Resultat: %f\n",E);
    	}
	|Expression FIN {printf("Resultat: %f\n", $1);}
	|ExpressionLogique FIN {
     		if($1==1){
        		printf("Resultat: vrai\n");
      		}else{
       			printf("Resultat: faux\n");
      		}
    	}
	|error FIN {yyerror();}
	;
	
Expression:
	NOMBRE {$$=$1;}
	|Expression PLUS Expression {$$=$1+$3;}
	|Expression MOINS Expression {$$=$1-$3;}
	|Expression FOIS Expression {$$=$1*$3;}
	|Expression DIVISE Expression {
		if($3 != 0){
			$$=$1/$3;
		}else{
			printf("Impossible de diviser sur 0\n");
			$$=0;
		}
	}
	|Expression MOD Expression {$$=(int)$1%(int)$3;}
	|MOINS Expression %prec NEG {$$=-$2;}
	|Expression PUISSANCE Expression {$$=puissance($1,$3);}
	|ABS PG Expression PD {$$=fabs($3);}
	|SIN PG Expression PD {$$=sin_calc($3);}
  	|COS PG Expression PD {$$=cos_calc($3);}
  	|TAN PG Expression PD {
  		if (cos_calc($3) == 0) {
			printf("Erreur, division par 0");
			$$ = 0;
		} else {
			$$ = tan_calc($3);
		}
	}
  	|ASIN PG Expression PD {
	  	if (fabs($3) > 1) {
			printf("Erreur, arcsin de |x| > 1 est impossible\n");
			$$ = 0;
		} else {
			$$ = arcsin_calc($3);
		}
  	}
  	|ACOS PG Expression PD {
  		if (fabs($3) > 1) {
			printf("Erreur, arccos de |x| > 1 est impossible\n");
			$$ = 0;
		} else {
			$$ = arccos_calc($3);
		}
  	
  	}
  	|ATAN PG Expression PD {$$=arctan_calc($3);}
	|SQRT PG Expression PD {
		if($3 >= 0){
			$$=racine($3);
		}else{
			printf("Impossible de calculer la racine d'un nombre négatif\n");
			$$=0;
		}
	}
	|EXP PG Expression PD {$$=exp($3);}
	|LN PG Expression PD {
		if($3 > 0){
			$$=log($3);
		}else{
			printf("Impossible de calculer le logarithme népérien d'un nombre négatif ou nul\n");
			$$=0;
		}
	}
	|LOG PG Expression PD {
		if($3 > 0){
			$$=log10($3);
		}else{
			printf("Impossible de calculer log sur une valeur négative ou nulle\n");
			$$=0;
		}
		}
	|LOG PG Expression VRLOG Expression PD {
		if($3 > 0 && $5 > 0){
			$$=log($5)/log($3);
		}else{
			printf("Impossible de calculer log sur une valeur négative ou nulle\n");
			$$=0;
		}
	}
	|PI {$$=Pi;}
    	|EXP {$$=E;}
	|PG Expression PD {$$=$2;}
	|ExpressionLogique {$$=$1;}
	;
	
ExpressionLogique:
	ComparisonExpression
	|Expression ET Expression {$$ = $1 && $3;}
	|Expression OU Expression {$$ = $1 || $3;}
        |NON Expression {$$=!($2);}
  	|PG ExpressionLogique PD {$$=$2;}
  	|VRAI {$$ = 1;}
  	|FAUX {$$ = 0;}
	;

ComparisonExpression:
	  Expression LT Expression {$$ = $1 < $3;}
	  |Expression GT Expression {$$ = $1 > $3;}
	  |Expression LE Expression {$$ = $1 <= $3;}
	  |Expression GE Expression {$$ = $1 >= $3;}
	  |Expression EQ Expression {$$ = $1 == $3;}
	  |Expression NE Expression {$$ = $1 != $3;}
	  ;

%%
//--------------------------------------------------------------
//Partie C :
void yyerror(){
printf("Erreur de syntaxe\n");
}
int main(void){
printf("Entrez une expression à évaluer :\n");
yyparse();
}
