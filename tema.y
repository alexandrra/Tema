%{
	#include<stdio.h>
	#include<string.h>

	int yylex();
	int yyerror(const char* msg);

	int esteCorecta = 1;
	char msg[50];

	class tSimb
	{
		char* name;
		bool init;
		tSimb* next;

	public:
		static tSimb* head;
		static tSimb* tail;

		tSimb(char* n)
		{
			this->name = new char[strlen(n)+1];
			strcpy(this->name, n);
			this->init = 0;
			this->next = NULL;
		}

		tSimb()
		{
			tSimb::head = NULL;
			tSimb::tail = NULL;
		}
			
		int exists(char* n)
		{
			tSimb* tmp = tSimb::head;
			while(tmp != NULL)
			{
				if(strcmp(tmp->name, n) == 0)
					return 1;
				tmp = tmp->next;
			}
			return 0;
		}

		void add(char* n)
		{
			tSimb* elem = new tSimb(n);
			if(head == NULL)
			{
				tSimb::head = tSimb::tail = elem;
			}
			else
			{
				tSimb::tail->next = elem;
				tSimb::tail = elem;
			}
		}

		void setValue(char* n)
		{
			tSimb* tmp = tSimb::head;
			while(tmp != NULL)
			{
				if(strcmp(tmp->name, n) == 0)
					tmp->init = 1;
				tmp = tmp->next;
			}
		}

		int getValue(char* n) 
		{
			tSimb* tmp = tSimb::head;
			while(tmp != NULL)
			{
				if(strcmp(tmp->name, n) == 0) {
					if(tmp -> init == 0)
						return 0;
					else
						return 1;
				}
				tmp = tmp->next;
			}
			return 0;
		}

	};

	tSimb* tSimb::head;
	tSimb* tSimb::tail;

	tSimb* ts = NULL;
%}

%union { char* sir; bool init; } 

%token TOK_PROGRAM TOK_DECLARE TOK_BEGIN TOK_END TOK_TYPE TOK_DIVIDE
	TOK_ASSIGN TOK_READ TOK_WRITE TOK_RIGHT TOK_LEFT TOK_FOR TOK_DO TOK_TO 
%token <sir> TOK_NAME
%token <sir> TOK_VALUE

%type <sir> id_list

%start progr

%left '+' '-'
%left '*' TOK_DIVIDE

%locations

%%

progr : 
	TOK_PROGRAM progr_name TOK_DECLARE dec_list TOK_BEGIN stmt_list TOK_END '.'
	|
	error
		{esteCorecta = 0;}
	;

progr_name : 
	TOK_NAME
	;

dec_list : 
	dec
	|
	dec_list ';' dec
	;

dec :
	id_list ':' type 
	{
		char* tmp = strtok($1, ",");
		while(tmp != NULL)
		{
			if(ts -> head != NULL)
			{ 
				if(ts -> exists(tmp) == 1)
				{		
					printf("\nVariabila %s a mai fost declarata!", tmp);
					yyerror(msg);
	    				esteCorecta = 0;
				}
				else
					ts -> add(tmp);
			}			
			else
			{
				ts -> add(tmp);
			}
		tmp = strtok(NULL, ",");
		}
	}			
	;


type : 
	TOK_TYPE
	;

id_list :
	TOK_NAME
	|
	id_list ',' TOK_NAME
	{
		strcat($$, ",");
		strcat($$, $3);
	}
	;

stmt_list :
	stmt
	|
	stmt_list ';' stmt
	;

stmt :
	assign 
	|
	read
	|
	write 
	|
	for
	;

assign :
	TOK_NAME TOK_ASSIGN exp
	{
		if(ts -> exists($1) == 0)
		{
			printf("\nVariabila %s este folosita fara a fi declarata!", $1);
			yyerror(msg);
	    		esteCorecta = 0;
		}	
		else
			ts -> setValue($1);	
	}
	;

exp :
	term
	|
	exp '+' term
	|
	exp '-' term
	;

term :
	factor
	|
	term '*' factor
	|
	term TOK_DIVIDE factor
	;

factor :
	TOK_NAME
	|
	TOK_VALUE
	|
	TOK_LEFT exp TOK_RIGHT
	;

read :
	TOK_READ TOK_LEFT id_list TOK_RIGHT
	{
		char* tmp = strtok($3, ",");
		while(tmp != NULL)
		{
			if(ts -> exists(tmp) == 0)
			{		
				printf("\nVariabila %s este folosita fara a fi declarata", tmp);
				yyerror(msg);
	    			esteCorecta = 0;
			}
		tmp = strtok(NULL, ",");
		}
	}	
	;

write :
	TOK_WRITE TOK_LEFT id_list TOK_RIGHT
	{
		char* tmp = strtok($3, ",");
		while(tmp != NULL)
		{
			if(ts -> getValue(tmp) == 0)
			{		
				printf("\nVariabila %s este folosita fara a fi initializata", tmp);
				yyerror(msg);
	    			esteCorecta = 0;
			}
		tmp = strtok(NULL, ",");
		}
	}	
	;

for : 
	TOK_FOR index_exp TOK_DO body
	;

index_exp :
	TOK_NAME TOK_ASSIGN exp TOK_TO exp
	{
		if(ts -> exists($1) == 0)
		{
			printf("\nVariabila %s este folosita fara a fi declarata", $1);
			yyerror(msg);
	    		esteCorecta = 0;
		}
	}
	;

body :
	stmt
	|
	TOK_BEGIN stmt_list TOK_END
	;
 
%%

int main()
{
	yyparse();

	
	if(esteCorecta == 1)
	{
		printf("CORECTA\n");
	}
	
	else
		printf("\nGRESITA\n");

	return 0;
}

int yyerror(const char *msg)
{
	printf("\nError %s", msg);
	return 1;
}

