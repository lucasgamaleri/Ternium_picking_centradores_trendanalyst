//Creado por Lucas GAMALERI; consultas: LGAMALER@ternium.com.ar
//Las variables deben ser descargadas desde el trending de piso de planta en el siguiente orden
// DEC.PLC4.N2_PRUEBA4 (Registro de prueba contador de alarma de automatismo)
// DEC.PLC10.AN2L_CENTRO_RAMPA_REF_VELOCIDAD (Velocidad centro BR3 m/min)
// DEC.PLC4.AN2L_CENTRADOR_6_DESPLAZ_CHAPA (Desplazamiento de chapa en Centrador 6)
// DEC.PLC4.AN2L_CENTRADOR_6_POSIC_RODILLO (Posicion rodillo centrador 6)
// DEC.PLC4.AN2L_PILETAS_CENTR_DESPLAZ_CHAPA (Desplazamiento de chapa en Centrador de Piletas)
// DEC.PLC4.AN2L_PILETAS_CENTR_POSIC_RODILLO (Posicion rodillo centrador de piletas)
// DEC.PLC10.AN2L_BR_4_SAL_VELOC_ACTUAL (Velocidad salida BR4 m/min)
// ---------------------------------------NOTA-------------------------------------------------
// El intervalo maximo de la bajada de datos NO DEBE EXCEDER los 3 días puesto que
// Se produciran errores en el calculo de la frecuencia de muestreo producto del
// Formato de los datos importados desde el piso de planta.
//clear
//Abre base de datos de variables
load('ddbb')
echo = %F; %T si desea tener acceso a todos los datos creados por el programa, caso contrario reemplazar por %F
guardar = %T; //%T si desea guardar la ejecución en la base de datos, para pruebas o casos particulares reemplazar por %F
//Carga de datos desde trending
if echo then
    print('echo is on')
end
if ~guardar  then
    print('Precaución! las variables no se guardarán en la base de datos')
end


path1='C:\Users\LGAMALER\Downloads\trends.csv';
path2 ='C:\Users\LGAMALER\""OneDrive - TERNIUM""\Documentos\Decapado\""2019.09 - Oscilacion en centrador 6""\""Analisis de patrones en centrador 6 y centrador de piletas""\trends.csv';
command = 'MOVE /Y '+path1+' '+path2;
dos(command,'-echo')
Datanum = csvRead('trends.csv',';',',','double')
Datastr = csvRead('trends.csv',';',',','string')

a = size(Datanum)
a = a(1)

datetime = Datastr(2:a,1);
contador = Datanum(2:a,2);
vel_centro = Datanum(2:a,3);
c6desp = Datanum(2:a,4);
c6pos = Datanum(2:a,5);
cpildesp = Datanum(2:a,6);
cpilpos = Datanum(2:a,7);
vel_salida = Datanum(2:a,8);
longitud_trk = Datanum(2:a,9)
bobina_numero = input("Escriba el numero de bobina: ","string");

if echo == %F then
    clear Datanum Datastr a
end

amp_factor_pos = -3
amp_factor_desp = -8
//Handling time
date1 = datetime(1);
date2 = datetime(2);
second1 = part(date1,(length(date1)-5:length(date1)))
second2 = part(date2,(length(date2)-5:length(date2)))
second1 = strtod(second1)
second2= strtod(second2)
frequency_seq = abs(second2-second1)
frequency_min = frequency_seq/60
if echo == %F then
    clear second1 second2 date1 date2 datetime
end
time = linspace(0,frequency_min*1000,1000)'

// Integracion numerica
//Pasaje de señal en funcion del tiempo a funcion de los metros de chapa [CORREGIR]
long_centro = zeros(length(time));
long_centro(1) = 0; //metros respecto a centrador de pileta
long_salida = zeros(length(time));
long_salida(2) = 375; //metros respecto a centrador de pileta
T1 = 0; T2 = 0;
for i = 2:length(time)
    j = i-1
    long_centro(i) = long_centro(j)+vel_centro(i)*(time(i)-time(j))

    long_salida(i) = long_salida(j)+vel_salida(i)*(time(i)-time(j))

end
// Fin de integración
clear T1 T2 dt1 dt2 i j










subplot(321)
//Grafico de centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
plot(time,amp_factor_pos*c6pos,'b-')
plot(time,cpilpos,'r-')
plot(0,240) //max eje y
plot(0,-240) //max neg eje y
xlabel('Tiempo [min]')
ylabel('Posicion centradores [%]')
title('Posición C6 y Centrador de piletas en func del tiempo')
legend(['Centrador 6*300%';'Centrador de piletas'])

subplot(325)
//Grafico de velocidad sobre tiempo
plot(time,vel_centro,'r-')
plot(time,vel_salida,'b-')
plot(0,240) //max eje y
//plot(0,-240) //max neg eje y

ylabel('Velocidad [m/min]')
title('Velocidad de la línea, Centro y salida')
legend(['Centrador de Pileta (BR3)';'Centrador 6 (BR4)'])

subplot(326)
//Grafico de contador de alarma
plot(time,contador,'r*')
//plot(0,240) //max eje y
//plot(0,-240) //max neg eje y

ylabel('Contador')
title('Contador de activacion de lógica')
//legend(['Centrador 6';'Centrador de piletas'])

subplot(323)
//Grafico de desplazamiento en centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
plot(time,-cpildesp,'r-')
plot(time,amp_factor_desp*c6desp,'b-')
plot(0,240) //max eje y
plot(0,-240) //max neg eje y

ylabel('Desplazamiento de chapa [mm]')
title('Posición C6 y Centrador de piletas por trending')
legend(['Centrador de piletas';'Centrador 6*500%'])

subplot(322)
//Grafico de centrador 6 y centrador de piletas con desfazaje por trayecto de chapa
plot(long_salida,amp_factor_pos*c6pos,'b-')
plot(long_centro,cpilpos,'r-')
plot(0,240) //max eje y
plot(0,-240) //max neg eje y
xlabel('Metros de chapa [m]')
ylabel('Posicion centradores [%]')
title('Posición C6 y Centrador de piletas por metro de chapa')
legend(['Centrador 6*300%';'Centrador de piletas'])

subplot(324)
//Grafico de desplazamiento en centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
plot(long_centro,cpildesp,'r-')
plot(long_salida,amp_factor_desp*c6desp,'b-')
plot(0,240) //max eje y
plot(0,-240) //max neg eje y
xlabel('Metros de chapa [m]')
ylabel('Desplazamiento de chapa [mm]')
title('Desplazamiento en C6 y Centrador de piletas por metro de chapa')
legend(['Centrador de piletas';'Centrador 6*500%'])








//Guardado de variables desde archivo
save('variables')
clear ans
//Guardado de base de datos

if guardar == %T then 
    amp_factor_desp_db = [amp_factor_desp_db,amp_factor_desp];
    amp_factor_pos_db = [amp_factor_pos_db,amp_factor_pos];
    c6desp_db = [c6desp_db,c6desp];
    c6pos_db = [c6pos_db,c6pos];
    contador_db = [contador_db,contador];
    cpildesp_db = [cpildesp_db,cpildesp];
    cpilpos_db = [cpilpos_db,cpilpos];
    frequency_min_db = [frequency_min_db,frequency_min];
    frequency_sec_db = [frequency_sec_db,frequency_seq];
    long_centro_db = [long_centro_db,long_centro];
    long_salida_db = [long_salida_db,long_salida];
    time_db = [time_db,time];
    vel_centro_db = [vel_centro_db,vel_centro];
    vel_salida_db = [vel_salida_db,vel_salida];
    longitud_trk_db = [longitud_trk,longitud_trk];
    bobina_numero_db = [bobina_numero,bobina_numero];
    save('ddbb')
end
if echo == %F then
    clear amp_factor_desp amp_factor_pos c6desp c6pos contador cpildesp cpilpos frequency_min frequency_seq long_centro long_salida time vel_centro vel_salida
end

clear ans
