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
		
	/* Cambiar departamento UCAYALI provincia Atalaya distrito Raymondi */
		replace CODDEP = "12" if NOMPROV=="ATALAYA" & CODDEP=="25"   /* 8 cambios */
		replace NOMDEP = "JUNIN" if NOMDEP=="UCAYALI" &  CODDEP=="12" /* 8 cambios */
		replace NOMPROV = "SATIPO" if NOMPROV=="ATALAYA" &  CODDEP=="12" /* 8 cambios */
		replace CODPROV = "1206" if CODPROV=="2502" &  CODDEP=="12" /* 8 cambios */
		replace CODDIS = "120608" if CODDIS=="250201" &  CODDEP=="12" /* 8 cambios */
		replace NOMDIS = "RIOTAMBO" if NOMDIS=="RAYMONDI" &  CODDEP=="12" /* 8 cambios */
		
	/* Cambiar provincia Bongara distrito San Jazan */
		replace CODPROV = "0105" if CODPROV=="0103" & CODDEP=="01"   /* 2 cambios */
		replace NOMPROV = "LUYA" if NOMPROV=="BONGARA" & CODDEP=="01" /* 2 cambios */
		replace NOMDIS = "SAN JERONIMO" if NOMDIS=="JAZAN" & CODDEP=="01"  /* 2 cambios */
		replace CODDIS = "010518" if CODDIS=="010307" & CODDEP=="01"   /* 2 cambios */

	/* Cambiar provincia HUamanga distrito Vinchos */
		replace CODPROV = "0502" if CODPROV=="0501" & CODDEP=="05"   /* 4 cambios */
		replace NOMPROV = "CANGALLO" if NOMPROV=="HUAMANGA" & CODDEP=="05" /* 4 cambios */
		replace NOMDIS = "CHUSCHI" if NOMDIS=="VINCHOS" & CODDEP=="05"  /* 4 cambios */
		replace CODDIS = "050202" if CODDIS=="050114" & CODDEP=="05"   /* 4 cambios */
	
	/* Cambiar provincia HUamanga distrito Vinchos */
		replace CODPROV = "1607" if CODPROV=="1603" & CODDIS=="160703"   /* 1 cambios */
		replace NOMPROV = "DATEM DEL MARAÑON" if NOMPROV=="LORETO" & CODDIS=="160703" /* 1 cambios */
		replace NOMPROV = "DATEM DEL MARAÑON" if CODPROV=="1607"  /* 39 cambios */	
		replace JEFE_DNI = "05609746" if JEFE_DNI=="05609764" & ID_HOGAR==682  /* 1 cambios */	
		
	/* Cambiar distrito Chipao */
		replace CODDIS = "050603" if CODDIS=="050606" & ID_HOGAR==664   /* 1 cambios */
		replace NOMDIS = "CABANA" if NOMDIS=="CHIPAO" & ID_HOGAR==664 /* 1 cambios */
		replace NUCL_EJEC = "CABANA" if NUCL_EJEC=="CHIPAO" & ID_HOGAR==664 /* 1 cambios */
		
	/* Cambiar distrito Cuchumbaya */
		replace CODDIS = "180102" if CODDIS=="180103" & ID_HOGAR==788   /* 1 cambios */
		replace NOMDIS = "CARUMAS" if NOMDIS=="CUCHUMBAYA" & ID_HOGAR==788 /* 1 cambios */
		replace NUCL_EJEC = "CARUMAS" if NUCL_EJEC=="CUCHUMBAYA" & ID_HOGAR==788 /* 1 cambios */
	
		replace CODDIS = "180102" if CODDIS=="180103" & ID_HOGAR==786   /* 1 cambios */
		replace NOMDIS = "CARUMAS" if NOMDIS=="CUCHUMBAYA" & ID_HOGAR==786 /* 1 cambios */
		replace NUCL_EJEC = "CARUMAS" if NUCL_EJEC=="CUCHUMBAYA" & ID_HOGAR==786 /* 1 cambios */

	
	/* Verificar codigos de distritos*/
		gen codprov1 = substr(CODDIS,1,4), after (CODPROV)
		egen flagprov = diff(CODPROV codprov1) /* diff compara valores de dos columnas */
		
		summarize flagprov
		
		if (r(sum)==0) {
			display as text in smcl "Coinciden los codigos"
		}
		else {
			display as text in smcl "No coinciden los codigos"
		} 
	
	
	/* Variable CODDIS NROCCPP */
		gen caracdis = length(NROCCPP), after (NROCCPP)
		
		replace NROCCPP= substr(NROCCPP,7,16) if caracdis==16 /* 22 cambios */
	
		
	/* Verificar codigos de CCPP */
		gen codccpp1 = substr(NROCCPP,1,6), after (NROCCPP)
		egen flagccpp = diff(CODDIS codccpp1) /* diff compara valores de dos columnas */
		
		summarize flagccpp
		
		if (r(sum)==0) {
			display as text in smcl "Coinciden los codigos"
		}
		else {
			display as text in smcl "No coinciden los codigos"
		} 
	
		
note NROCCPP: Existen algunos ubigeos de CCPP que tienen ubigeos de distritos erroneos, vamos a cambiar los 6 primeros digitos del ubigeo de CCPP.
		
		
		/* Generando los 4 ultimos digitos del ubigeo de CCPP */
		gen codccpp2 = substr(NROCCPP,7,10), after(NROCCPP) /* Crear variable de comparacion */
		
		/*Concatenando variables CODDIS + codccpp2 */
		 egen codccpp_n = concat(CODDIS codccpp2) /* Crear variable de comparacion */
		
		replace NROCCPP=codccpp_n /* 47 cambios */
	
	
		drop caracdis codccpp1 codccpp2 codccpp_n flagccpp flagprov
		
		
1.5. Verificando DNI de jefes y conyugues

		/* DNI jefes de hogar */
			gen caracdnij = length(JEFE_DNI), after (JEFE_DNI)
		  
			/* Colocando ceros a la ezquierda del DNI */	
			gen str8 dni_j = string(real(JEFE_DNI),"%08.0f"), after(JEFE_DNI)
		
			/* reemplazando variable JEFE_DNI */
			replace JEFE_DNI = dni_j
			replace JEFE_DNI = "N.D" if caracdnij==10
		
			drop caracdnij dni_j
		
		/* DNI jefes de conyugues */
			sort ID_HOGAR
			
			/* Recuperando nros de celular del conyugue*/
			replace CONY_CEL = CONY_DNI if ID_HOGAR==821
			replace CONY_CEL = CONY_DNI if ID_HOGAR==822
			replace CONY_CEL = CONY_DNI if ID_HOGAR==824
			replace CONY_CEL = CONY_DNI if ID_HOGAR==829
			replace CONY_CEL = CONY_DNI if ID_HOGAR==830
			replace CONY_CEL = CONY_DNI if ID_HOGAR==831
			replace CONY_CEL = CONY_DNI if ID_HOGAR==832
			replace CONY_CEL = CONY_DNI if ID_HOGAR==833
			replace CONY_CEL = CONY_DNI if ID_HOGAR==834
			replace CONY_CEL = CONY_DNI if ID_HOGAR==835
			replace CONY_CEL = CONY_DNI if ID_HOGAR==836
			replace CONY_CEL = CONY_DNI if ID_HOGAR==839
			replace CONY_CEL = CONY_DNI if ID_HOGAR==840
			replace CONY_CEL = CONY_DNI if ID_HOGAR==841
			replace CONY_CEL = CONY_DNI if ID_HOGAR==842
			replace CONY_CEL = CONY_DNI if ID_HOGAR==843
			replace CONY_CEL = CONY_DNI if ID_HOGAR==844
			replace CONY_CEL = CONY_DNI if ID_HOGAR==845
			replace CONY_CEL = CONY_DNI if ID_HOGAR==847
			replace CONY_CEL = CONY_DNI if ID_HOGAR==848
			replace CONY_CEL = CONY_DNI if ID_HOGAR==849
			replace CONY_CEL = CONY_DNI if ID_HOGAR==850
			replace CONY_CEL = CONY_DNI if ID_HOGAR==852
			replace CONY_CEL = CONY_DNI if ID_HOGAR==853
			replace CONY_CEL = CONY_DNI if ID_HOGAR==854
			replace CONY_CEL = CONY_DNI if ID_HOGAR==855
			replace CONY_CEL = CONY_DNI if ID_HOGAR==856
			replace CONY_CEL = CONY_DNI if ID_HOGAR==857
			replace CONY_CEL = CONY_DNI if ID_HOGAR==858
			replace CONY_CEL = CONY_DNI if ID_HOGAR==859
			
			
			/* Recuperando nros de dni del conyugue*/
			replace CONY_DNI = "04481636" if ID_HOGAR==185
			
			replace CONY_DNI = "44677158" if ID_HOGAR==821
			replace CONY_DNI = "01552144" if ID_HOGAR==822
			replace CONY_DNI = "45906423" if ID_HOGAR==824
			replace CONY_DNI = "43025598" if ID_HOGAR==829
			replace CONY_DNI = "01531791" if ID_HOGAR==830
			replace CONY_DNI = "47045509" if ID_HOGAR==831
			replace CONY_DNI = "01485794" if ID_HOGAR==832
			replace CONY_DNI = "46569665" if ID_HOGAR==833
			replace CONY_DNI = "01486314" if ID_HOGAR==834
			replace CONY_DNI = "01531494" if ID_HOGAR==835
			replace CONY_DNI = "01484212" if ID_HOGAR==836
			replace CONY_DNI = "41505744" if ID_HOGAR==839
			replace CONY_DNI = "01485445" if ID_HOGAR==840
			replace CONY_DNI = "43331853" if ID_HOGAR==841
			replace CONY_DNI = "47466376" if ID_HOGAR==842
			replace CONY_DNI = "01531656" if ID_HOGAR==843
			replace CONY_DNI = "43402434" if ID_HOGAR==844
			replace CONY_DNI = "01530106" if ID_HOGAR==845
			replace CONY_DNI = "01530005" if ID_HOGAR==847
			replace CONY_DNI = "01531053" if ID_HOGAR==848
			replace CONY_DNI = "46002813" if ID_HOGAR==849
			replace CONY_DNI = "01543816" if ID_HOGAR==850
			replace CONY_DNI = "01530114" if ID_HOGAR==852
			replace CONY_DNI = "80190356" if ID_HOGAR==853
			replace CONY_DNI = "01544036" if ID_HOGAR==854
			replace CONY_DNI = "01530205" if ID_HOGAR==855
			replace CONY_DNI = "01553300" if ID_HOGAR==856
			replace CONY_DNI = "01531404" if ID_HOGAR==857
			replace CONY_DNI = "01485853" if ID_HOGAR==858
			replace CONY_DNI = "01530073" if ID_HOGAR==859
			
	
			/* completando con ceros los dni del conyugue*/						
			gen caracdnic = length(CONY_DNI), after (CONY_DNI)
		  
			/* Colocando ceros a la ezquierda del DNI */	
			gen str8 dni_c = string(real(CONY_DNI),"%08.0f"), after(CONY_DNI)
		
			/* reemplazando variable JEFE_DNI */
			replace CONY_DNI = dni_c
				
			drop caracdnic dni_c
		
			/* completar missing ceros y otros */
			replace CONY_DNI="88888888" if (CONY_DNI=="00000000" | CONY_DNI=="99999999" | CONY_DNI==".")
			
	
	

	
	
	
	
	
	
	
	
	
	
	
	
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
	
	