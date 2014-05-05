/* Reglas de precedencia */

%right ASSIGN
%right '*'
%left '+'

%right THEN ELSE

/* Declaración de tokens */

%token EOF  END_SENTENCE COMMA ID ASSIGN PROGRAM LINE POINT
%token PAR_OPEN PAR_CLOSE NUMBER LLAVE_OPEN LLAVE_CLOSE  SET ROUTE

%start program

/* Comienzo de la descripción de la gramática */

%%

program
: flight EOF
{
    $$ = $1;
    return $$;
}
;

flight
: PROGRAM ID LLAVE_OPEN blocks LLAVE_CLOSE
{
    $$ = {
    type: 'PROGRAM',
    id: $2,
    block: $4
    };
}
;

blocks
: staments rutas
{
    $$ = {
    type: 'BLOCK',
    var: $1,
    stament: $2
    };
}
;

ruta
: ROUTE ID LLAVE_OPEN staments set_r LLAVE_CLOSE END_SENTENCE
{
    $$ = {
    type: 'ROUTE',
    id: $2,
    stament:$4,
    set:$5
    };
}
;
set_r
: SET ID END_SENTENCE
{

}
;
rutas
: /*empty*/
| ruta rutas
{
    $$ = [$1];
    if ($2 && $2.length > 0)
        $$ = $$.concat($2);
}
;
staments
: /*empty*/
| stament END_SENTENCE staments
{
    $$ = [$1];
    if ($3 && $3.length > 0)
        $$ = $$.concat($3);
}
;

stament
: POINT ID
{
    $$ = {
    type: 'POINT',
    id: $2
    };
}
| LINE '*' ID
{
    $$ = {
    type: 'LINE*',
    id: $3
    };
}
| LINE ID
{
    $$ = {
    type: 'LINE',
    id: $2
    };
}
| ID ASSIGN expression
{
    $$ = {
    type: '=',
    right: $1,
    left: $3
    };
}
;
expression
: expression_id
{
    $$ = $1;
}
| expression_p
{
    $$ = $1;
}
| expression_l
{
    $$ = $1;
}
;
expression_id
: ID
| expression_id '+' ID
{
    $$ = {
    type: '+',
    right: $1,
    left: $3
    };
}
;
expression_p
: punto
| expression_p '+' punto
;
expression_l
: linea
| expression_l '+' linea
;

punto
: NUMBER COMMA NUMBER
{
    $$ = {
    type: 'POINT',
    x: $1,
    y: $3
    };
}
;

linea
: PAR_OPEN punto PAR_CLOSE COMMA PAR_OPEN punto PAR_CLOSE
{
    $$ = {
    type: 'LINE',
    start: $2,
    end: $6
    };
}
| PAR_OPEN punto PAR_CLOSE COMMA ID
{
    $$ = {
    type: 'LINE',
    start: $2,
    end: $5
    };
}
| ID COMMA PAR_OPEN punto PAR_CLOSE
{
    $$ = {
    type: 'LINE',
    start: $1,
    end: $4
    };
}
;


lineas
: linea lineas
{
    $$ = [$1];
    if ($2 && $2.length > 0)
        $$ = $$.concat($2);
}
;