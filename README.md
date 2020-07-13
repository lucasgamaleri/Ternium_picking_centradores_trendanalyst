# Ternium_picking_centradores_trendanalyst
Analisis de datos de centradores basado en Scilab
Creado por Lucas GAMALERI; consultas: LGAMALER@ternium.com.ar
Las variables deben ser descargadas desde el trending de piso de planta en el siguiente orden
 DEC.PLC4.N2_PRUEBA4 (Registro de prueba contador de alarma de automatismo)
 DEC.PLC10.AN2L_CENTRO_RAMPA_REF_VELOCIDAD (Velocidad centro BR3 m/min)
 DEC.PLC4.AN2L_CENTRADOR_6_DESPLAZ_CHAPA (Desplazamiento de chapa en Centrador 6)
 DEC.PLC4.AN2L_CENTRADOR_6_POSIC_RODILLO (Posicion rodillo centrador 6)
 DEC.PLC4.AN2L_PILETAS_CENTR_DESPLAZ_CHAPA (Desplazamiento de chapa en Centrador de Piletas)
 DEC.PLC4.AN2L_PILETAS_CENTR_POSIC_RODILLO (Posicion rodillo centrador de piletas)
 DEC.PLC10.AN2L_BR_4_SAL_VELOC_ACTUAL (Velocidad salida BR4 m/min)
---------------------------------------NOTA-------------------------------------------------
El intervalo maximo de la bajada de datos NO DEBE EXCEDER los 3 días puesto que
Se produciran errores en el calculo de la frecuencia de muestreo producto del
Formato de los datos importados desde el piso de planta.
