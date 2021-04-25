/*******************************************************************************
* PROJECTO: 	Linea de base - portafolio 2018                           
* TITULO: 		Master Do File
* YEAR:			2021
* Author: 		Dante Córdova
********************************************************************************
	
*** Outline:
	0. Set initial configurations and globals
	1. Primera Semana
	2. Segunda Semana
	3. Tercera Semana
	4. Cuarta  Semana

********************************************************************************
*** PART 0: Configuración de estructura y variables globales
*******************************************************************************/

display "`c(username)'"

*** 0.1 Settings user's paths
	if ("`c(username)'" == "jcordova") {
		global project 				"E:\DANTE\2021\21. LINEA DE SALIDA 2018\PORTAFOLIO_2018"
	}	
	
*** 0.2 Setting folder structure
	global codes					"${project}/codes"
	global data						"${project}/data"
	global outputs 					"${project}/outputs"
	
	
	/*para probar*/
	
	
	
	// Semana 1
	global codes_1					"${codes}/01 seccion 1"
	global codes_2					"${codes}/02 seccion 2"
	global codes_3					"${codes}/03 seccion 3"
	global codes_4					"${codes}/04 seccion 4"
	global codes_5					"${codes}/05 seccion 5"
	global codes_6					"${codes}/06 seccion 6"
	global codes_7					"${codes}/07 seccion 7"
	global codes_8					"${codes}/08 seccion 8"
	global codes_9					"${codes}/09 seccion 9"
	global codes_10					"${codes}/10 seccion 10"
	global codes_11					"${codes}/11 seccion 11"
	
	
	global data_1					"${data}/01 seccion 1"
	global data_2					"${data}/02 seccion 2"
	global data_3					"${data}/03 seccion 3"
	global data_4					"${data}/04 seccion 4"
	global data_5					"${data}/05 seccion 5"
	global data_6					"${data}/06 seccion 6"
	global data_7					"${data}/07 seccion 7"
	global data_8					"${data}/08 seccion 8"
	global data_9					"${data}/09 seccion 9"
	global data_10					"${data}/10 seccion 10"
	global data_11					"${data}/11 seccion 11"
	/*global data_12					"${data}/base consolidada"
	global data_13					"${data}/base id"*/
	
	//global data_1_2					"${data}/02-manejo-limpieza-datos"
	
		
	
*** 0.3 Install required packages:	
/*INstalando los paquetes que se utilizará en el codigo*/

	local packages ietoolkit iefieldkit winsor estout outreg2 reghdfe xml_tab outwrite
		
	foreach pgks in `packages' {	
	  				
		capture which `pgks'
		
		if (_rc != 111) { /*error 111 indica que el paquete no esté instalado*/
			display as text in smcl "Paquete {it:`pgks'} está instalado "
		}
		
		else {
			display as error in smcl `"Paquete {it:`pgks'} necesita instalarse."'
			
			capture ssc install `pgks', replace
			
			if (_rc == 601) {
				display as error in smcl `"Package `pgks' is not found at SSC;"' _newline ///
				`"Please check if {it:`pgks'} is spelled correctly and whether `pgks' is indeed a user-written command."'
			}
			
			else {
				display as result in smcl `"Paquete `pgks' ha sido instalado."'
			}
		}
	}
	
	ieboilstart, version(15.0)

*** Ejecutar hasta línea 97	

*** 0.4 Setting up execution 
	global primera_semana 1
	global segunda_semana 1
	global tercera_semana 1
	global cuarta_semana  1
		
********************************************************************************
***	PART 1: Primera Semana  
********************************************************************************
	if (${primera_semana} == 1) {
		do "${codes_1_1}/sesion_1.do"
		do "${codes_1_2}/sesion_2.do"
	} 

********************************************************************************
***	PART 2: Segunda Semana  
********************************************************************************
	if (${segunda_semana} == 1) {
		do "${codes_2_1}/sesion_3.do"					// Crear base dummy
		do "${codes_2_1}/sesion_3a_nodup.do"			// Crear base de datos sin duplicados
		do "${codes_2_1}/sesion_3b_clean.do"			// Crear base de datos limpia	
		do "${codes_2_1}/sesion_3c_hps.do"				// Crear HPS level dataset
		do "${codes_2_2}/sesion_4_hpsc.do"				// Crear HPSC level dataset
		do "${codes_2_2}/sesion_4_hc_prices.do"			// Crear HC level dataset (prices)
		do "${codes_2_2}/sesion_4_merge_hps_hpsc.do"	// Merge HPS and HPSC datasets
	}

********************************************************************************
***	PART 3: Tercera Semana 
********************************************************************************
	if (${tercera_semana} == 1) {
		do "${codes_3_1}/sesion_5_hpsc_constructed.do"
		do "${codes_3_1}/sesion_5_hpsc_bal_tab.do"
		do "${codes_3_1}/sesion_5_excel-tables.do"
		do "${codes_3_2}/sesion_6_esttab.do"
		do "${codes_3_2}/sesion_6_rct_tab_1.do"
		do "${codes_3_2}/sesion_6_rct_tab_3.do"
	} 

********************************************************************************
***	PART 4: Cuarta Semana 
********************************************************************************
	if (${cuarta_semana} == 1) {
		do "${codes_4_1}/sesion_7_did.do"
		do "${codes_4_2}/sesion_8_rdd.do"
		do "${codes_4_2}/sesion_8_program.do"
	}
	
