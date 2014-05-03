/* Reglas de precedencia */

%right ASSIGN
%right '*'
%left '+'

%right THEN ELSE

/* Declaración de tokens */

%token EOF  END_SENTENCE COMMA ID ASSIGN PROGRAM LINE POINT KLEEN    
%token PAR_IZK PAR_DER NUMBER LLAVE_IZK LLAVE_DER  SET ROUTE

%start program

/* Comienzo de la descripción de la gramática */

%%

program
  : PROGRAM ID LLAVE_IZK  vars  LLAVE_DER EOF
    {
		$$ = $1; 
        console.log($$);
        return $$;
    }
  ;
vars
  : blocks
  | linea blocks
  ;

blocks
  : ruta blocks
  | /*empty*/
  ;

linea
  : LINE ID ASSIGN punto
  | LINE '*' ID ASSIGN linelist
  | ID 
  ;

linelist
  : ID '+' linelist
  {
	$$ = {
		type: 'linelist',
	};
  }
  | ID END_SENTENCE
  ;
  


punto
  : POINT ID ASSIGN punto
  | PAR_IZK NUMBER COMMA NUMBER PAR_DER COMMA punto
  | PAR_IZK NUMBER COMMA NUMBER PAR_DER END_SENTENCE
  | NUMBER COMMA NUMBER END_SENTENCE
  | ID COMMA punto
  | ID END_SENTENCE
  ;

ruta
  : ROUTE ID LLAVE_IZK sentencias LLAVE_DER END_SENTENCE
  ;

sentencias
  : punto sentencias
  | linea sentencias
  | ID ASSIGN linelist sentencias
  | SET ID END_SENTENCE sentencias
  | /*empty*/
  ;