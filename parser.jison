/* Reglas de precedencia */

%right ASSIGN
%left '+' '-'

%right THEN ELSE

/* Declaración de tokens */

%token EOF  END_SENTENCE COMMA ID ASSIGN PROGRAM LINE POINT     
%token PAR_IZK PAR_DER NUMBER LLAVE_IZK LLAVE_DER  SET ROUTE

%start program

/* Comienzo de la descripción de la gramática */

%%

program
  : ID blocks EOF
    {
      return $1;
    }
  ;

blocks
  : LLAVE_IZK line statements
  | LLAVE_IZK route statements
  | LLAVE_DER
  ;

/* statements
  : statement
  | statement END_SENTENCE statement
  ;

statement
  : /*empty *"/
  | point END_SENTENCE 
*/

line
  : ID ASSIGN point
  | ID 
  ;

point
  : ID ASSIGN punto
  | PAR_IZK NUMBER COMMA NMBER PAR_DER
  | ID
  ;

route
  :ID blocks
  ;

