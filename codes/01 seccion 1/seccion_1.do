/********************************************************************************
* Título:	Manejo y Limpieza de Datos

* Autor:	Dante Cordova
*********************************************************************************
	
*** Outline:
	1. Variable ID y Duplicados
		1.1 Cargar datos
		1.2 Duplicates and ID variable 
	2. Glimpse de algunas variables
		2.1 Variables demográficas
		2.2 Una mejor manera de ver los missings
		2.3 Recoding 
	
*********************************************************************************
***	PART 1: Variable ID y Duplicados
********************************************************************************/

*** 1.1 Cargar data
	use "${data_1}/seccion_01.dta", clear 
		
*** 1.2 Duplicados y variable ID
	isid ID_HOGAR
	duplicates report ID_HOGAR
	
	/*Hay valores perdidos eliminamos*/
	drop if ID_HOGAR == .
	
	isid ID_HOGAR
	duplicates report ID_HOGAR
	
*** 1.3 N° de caracteres de principales variables
	count
	local obs =r(N)
	display "`obs'"
	
	forvalues p = 1/1030 {
		strlen (EXPEDIENTE)
		
		
	}
	
	/* Expandimos para tener duplicados 
	expand 2
	capture isid newid 

	// Drop los duplicados 
	duplicates report newid 
	duplicates drop newid, force*/
	
	/*Guardamos en nueva base de datos*/
	save "${data_1}/seccion_01r.dta", replace
		
*********************************************************************************
***	PART 2: Glimpse de algunas variables
*********************************************************************************
	
*** 2.1 Variables demográficas (missings)
	use "${data_1}/SECCION_01r.dta", clear 
	count 
	local obs = r(N)
	
	local variab UUTT NOMDEP NOMPROV
		
	foreach var in `variab' {
		tab `var'
		if (r(N) == `obs') {
			display "Las observaciones en la tabla es igual al número total de observaciones"
		}
		else {
			display "El número de observaciones en la tabla es diferente al número total de observaciones"
		}
	}

	
	
	
	
	
*** 2.2 Una mejor manera de ver los missings
	local ejemplo ssex star1 star2 star3 
	
	foreach var in `ejemplo' {
		capture assert !missing(`var')
		
		if _rc == 9 { /*error de valores perdidos*/
			display "variable `var' tiene valores perdidos"
			replace `var' = 0 if missing(`var')
		}
		
		else {
			display "Variable `var' no tiene valores perdidos"
		}
		
	}
		
*** 2.3 Recoding	
	gen ssex2 = ssex 
	gen ssex3 = ssex 
	
	local sex ssex ssex2 ssex3
	
	foreach var in `sex' {
		capture assert `var' == 2 
		if _rc == 9 {
			recode `var' (2=0)
		}
	}
	
	