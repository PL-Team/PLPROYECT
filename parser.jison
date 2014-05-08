/* Symbol table */

%{
var point_table = [];
var line_table = [];
var list_table = [];


function upIndex(){
	index++;
}

%}

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
    point_table[$2]={x:'null',y:'null'};
    $$ = {
    type: 'POINT',
    id: $2
    };

}
| LINE '*' ID
{
    list_table[$3]={line:[]};
    $$ = {
    type: 'LINE*',
    id: $3
    };
}
| LINE ID
{
    line_table[$2]={ini:'null',fin:'null'};
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
    if ($3.type == "POINT"){
 	point_table[$1].x = $3.x;
 	point_table[$1].y = $3.y;
    }else if($3.type == "LINE"){
	line_table[$1].ini = {x: $3.start.x, y: $3.start.y};
	line_table[$1].fin = {x: $3.end.x, y: $3.end.y};
    }else if ($3.type == "LINE*"){
	list_table[$1].line.push({});
    }
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
{ 

}
| expression_id '+' ID
{
	
    $$ = {
    type: '+',
    right: {
	id:$1,
	inicio:{
		x:'null',
		y:'null'
	
	},
	fin:{
		x:'null',
		y:'null'
	}
	
    },
    left: {
	id:$3,
	inicio:{
		x:line_table[$3].ini.x,
		y:line_table[$3].ini.y
	
	},
	fin:{
		x:line_table[$3].fin.x,
		y:line_table[$3].fin.y
	}
	
    }
    };
}
;
expression_p
: punto
| expression_p '+' punto
{
    $$ = {
    type: '+',
    right: $1,
    left: $3
    };
}
;
expression_l
: linea
| expression_l '+' linea
{
    $$ = {
    type: '+',
    right: $1,
    left: $3
    };
}
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
    //end: $5        //change ID for point.
    end: {
	type: 'POINT',
    	x: point_table[$5].x,
  	y: point_table[$5].y
    }
    };
}
| ID COMMA PAR_OPEN punto PAR_CLOSE
{
    $$ = {
    type: 'LINE',
    //start: $1, CHANGE ID FOR POINT
    start: {
	type: 'POINT',
    	x: point_table[$1].x,
  	y: point_table[$1].y
    },
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
