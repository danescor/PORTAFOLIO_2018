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
	capture isid ID_HOGAR
	duplicates report ID_HOGAR
	
	/*Hay valores perdidos eliminamos*/
	drop if ID_HOGAR == .
	
	isid ID_HOGAR
	duplicates report ID_HOGAR
	
*** 1.3 Uniformizando los caracteres de la varibale */
	
	/*  Variable IQ  */
	gen nrocarac=length(IQ), after (IQ)	 /*EL NRO DE CARACTERES NO ES UNIFORME*/
	
	/*NOTA: VARIABLE IQ = EXPEDIENTE + COD_ENC*/
	
	gen str2 COD_ENC_N = string(COD_ENC,"%02.0f"), after(COD_ENC)

	
	egen IQ_N = concat(EXPEDIENTE COD_ENC_N)
	replace IQ = IQ_N 
	gen nrocarac1=length(IQ), after (IQ)
	sum nrocarac1
	drop nrocarac nrocarac1 IQ_N COD_ENC_N
	
	/*  Variables de nombres, quitando espacios vacios */
		
	replace UUTT = strtrim(stritrim(UUTT))
	replace NOMDEP = strtrim(stritrim(NOMDEP))
	replace NOMPROV = strtrim(stritrim(NOMPROV))
	replace NOMDIS = strtrim(stritrim(NOMDIS))
	replace NUCL_EJEC = strtrim(stritrim(NUCL_EJEC))
	replace NOMCCPP = strtrim(stritrim(NOMCCPP))
	replace NOMVIA = strtrim(stritrim(NOMVIA))
	replace JEFE_AP_P = strtrim(stritrim(JEFE_AP_P))
	replace JEFE_AP_M = strtrim(stritrim(JEFE_AP_M))
	replace JEFE_AP_NOM = strtrim(stritrim(JEFE_AP_NOM))
	replace JEFE_DNI = strtrim(stritrim(JEFE_DNI))
	replace JEFE_CEL = strtrim(stritrim(JEFE_CEL))
	replace CONY_AP_NOM = strtrim(stritrim(CONY_AP_NOM))
	replace CONY_AP_P = strtrim(stritrim(CONY_AP_P))
	replace CONY_AP_M = strtrim(stritrim(CONY_AP_M))
	replace CONY_CEL = strtrim(stritrim(CONY_CEL))
	replace CONY_DNI = strtrim(stritrim(CONY_DNI))
	
*** 1.4 Verificando los ubigeos

	/* VAriable CODDIS CODPROV */
	egen coddis2 = concat(CODDEP CODPROV) /* Crear variable de comparacion */
	egen flag = diff(CODDIS coddis2) /* diff compara valores de dos columnas */
	
	sort NOMDEP NOMPROV NOMDIS 
	
	/* Notas */
	note CODDIS: Existen algunos distritos que tienen dos codigos o codigos que tienen dos nombres 
	
	/* Distritos: COPORAQUE Y TUTI tienen el mismo codigo*/
		replace NOMDIS = "COPORAQUE" if NOMDIS=="TUTI" /* 5 cambios */
	
	/* Distritos: FITZCARRALD Y MANU tienen el mismo codigo*/
		*** Cambiar el codigo del distrito MANU 
		replace CODDIS = "170202" if CODDIS=="170201" /* 6 cambios */
	
		replace NOMDIS = "FITZCARRALD" if NOMDIS=="MANU" /* 7 cambios */

	/* Distritos: QUILAHUANI CANDARAVE CURIBAYA, todos tienen que ser QUILAHUANI tienen el mismo codigo*/
		*** Cambiar el codigo del distrito CANDARAVE 
		replace CODDIS = "230206" if CODDIS=="230201"  /* 8 cambios */
		replace CODDIS = "230206" if CODDIS=="230204"  /* 4 cambios */
	
		replace NOMDIS = "QUILAHUANI" if NOMDIS=="CANDARAVE" /* 7 cambios */
		replace NOMDIS = "QUILAHUANI" if NOMDIS=="CURIBAYA" /* 4 cambios */
	
	/* Distritos: COLCA CHACAPAMPA, todos tienen que ser COLCA tienen el mismo codigo*/
		*** Cambiar el codigo del distrito COLCA 
		replace CODDIS = "120112" if CODDIS=="120212"  /* 1 cambios */
		replace CODDIS = "120112" if CODDIS=="120105"  /* 4 cambios */
	
		replace NOMDIS = "COLCA" if NOMDIS=="CHACAPAMPA" /* 4 cambios */
		
	
	/* Distritos: USQUIL, tiene dos codigos*/
		*** Cambiar el codigo del distrito USQUIL 
		replace CODDIS = "130614" if CODDIS=="131406"  /* 1 cambios */
		
	/* Cambiar departamento UCAYALI por JUNIN */
		replace CODDEP = "12" if NOMPROV=="ATALAYA" & CODDEP=="25"   /* 8 cambios */
		replace NOMDEP = "JUNIN" if NOMDEP=="UCAYALI" &  CODDEP=="12" /* 8 cambios */
		replace NOMPROV = "SATIPO" if NOMPROV=="ATALAYA" &  CODDEP=="12" /* 8 cambios */
		replace CODPROV = "1206" if CODPROV=="2502" &  CODDEP=="12" /* 8 cambios */
		replace CODDIS = "120608" if CODDIS=="250201" &  CODDEP=="12" /* 8 cambios */
		replace NOMDIS = "RIOTAMBO" if NOMDIS=="RAYMONDI" &  CODDEP=="12" /* 8 cambios */
		
	/*24.04.2021 23.31 horas, revisar los codigos de dep y prov*/
	

	
	
	
	if (flag==1) {
		display as text in smcl "Coinciden los codigos"
	}
	else {
		display as text in smcl "No coinciden los codigos"
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
	
	