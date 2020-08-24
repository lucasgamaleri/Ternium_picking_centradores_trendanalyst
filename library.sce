function buscar_bobina(n)
    scf()
    plot(long_centro_db(:,n),cpildesp_db(:,n),'r-')
    plot(long_salida_db(:,n),c6desp_db(:,n),'b-')
    xlabel('metros')
    ylabel('Desplazamiento de chapa')
    legend(['Centrador de piletas';'Centrador 6'])
    title('BOBINA # '+string(n))
    
endfunction
function bb = cargar_bobina(n)
    try 
        if isstruct(bb) then
            bb = struct('vs',vel_salida_db(:,n),'vc',vel_centro_db(:,n),'lc',long_centro_db(:,n),'ls',long_salida_db(:,n),'t',time_db(:,n),'cpilp',cpilpos_db(:,n),'cpild',cpildesp_db(:,n),'c6p',c6pos_db(:,n),'c6d',c6desp_db(:,n));
        else
            bb = struct('vs',vel_salida_db(:,n),'vc',vel_centro_db(:,n),'lc',long_centro_db(:,n),'ls',long_salida_db(:,n),'t',time_db(:,n),'cpilp',cpilpos_db(:,n),'cpild',cpildesp_db(:,n),'c6p',c6pos_db(:,n),'c6d',c6desp_db(:,n));

        printf(' bb.vs -- velocidad de salida \n bb.vc -- velocidad de centro \n bb.lc -- longitud centro \n bb.ls -- longitud salida \n bb.t -- tiempo \n bb.cpilp -- posicion de rodillos centrador de piletas \n bb.cpild -- desplazamiento centrador de pileta \n bb.c6p -- posicion de rodillo centrador 6 \n bb.c6d -- desplazamiento de chapa centrador 6')
        end
    catch
        bb = struct('vs',vel_salida_db(:,n),'vc',vel_centro_db(:,n),'lc',long_centro_db(:,n),'ls',long_salida_db(:,n),'t',time_db(:,n),'cpilp',cpilpos_db(:,n),'cpild',cpildesp_db(:,n),'c6p',c6pos_db(:,n),'c6d',c6desp_db(:,n));

        printf(' bb.vs -- velocidad de salida \n bb.vc -- velocidad de centro \n bb.lc -- longitud centro \n bb.ls -- longitud salida \n bb.t -- tiempo \n bb.cpilp -- posicion de rodillos centrador de piletas \n bb.cpild -- desplazamiento centrador de pileta \n bb.c6p -- posicion de rodillo centrador 6 \n bb.c6d -- desplazamiento de chapa centrador 6')
    end
    bb = resume(bb)
endfunction

function mapa(x,z)
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('mapa (Doble click para cambiar titulo)')
    gcf().color_map = jetcolormap(100);
    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [40 -60];
endfunction

function superf(x,z)
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('mapa (Doble click para cambiar titulo)')

    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [0 90];
endfunction

function info()
    subplot(221)
    x = long_centro_db
    z = cpildesp_db
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('Centrador de piletas - Desplazamiento de chapa')
    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [0 90];
    
    subplot(222)
    x = long_centro_db
    z = cpilpos_db
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('Centrador de piletas - Posición de rodillos')
    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [0 90];
    
    subplot(223)
    x = long_salida_db
    z = c6desp_db
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('Centrador 6 - Desplazamiento de chapa')
    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [0 90];
    
    subplot(224)
    x = long_salida_db
    z = cpilpos_db
    surf(1:1:size(z)(2),linspace(1,max(x),size(z)(1)),z)
    ylabel('metros de chapa')
    xlabel('número de muestra')
    title('Centrador de piletas - Posición de rodillos')
    set(gcf(), "axes_size", [800 350], "rotation_style","multiple");
    gca().rotation_angles = [0 90];
endfunction

function derivar(variable,n)
    cargar_bobina(n)
    var = zeros(length(bb.t),1);
    for i = 2:length(var)-1
        var(i)=(variable(i+1)-variable(i))/(bb.t(i+1)-bb.t(i));
    end
    var = resume(var);
endfunction

function graficar(n)
    subplot(321)
    //Grafico de centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
    plot(time_db(:,n),amp_factor_pos_db(:,n)*c6pos_db(:,n),'b-')
    plot(time_db(:,n),cpilpos_db(:,n),'r-')
    plot(0,240) //max eje y
    plot(0,-240) //max neg eje y
    xlabel('Tiempo [min]')
    ylabel('Posicion centradores [%]')
    title('Posición C6 y Centrador de piletas en func del tiempo')
    legend(['Centrador 6*300%';'Centrador de piletas'])

    subplot(325)
    //Grafico de velocidad sobre tiempo
    plot(time_db(:,n),vel_centro_db(:,n),'r-')
    plot(time_db(:,n),vel_salida_db(:,n),'b-')
    plot(0,240) //max eje y
    //plot(0,-240) //max neg eje y

    ylabel('Velocidad [m/min]')
    title('Velocidad de la línea, Centro y salida')
    legend(['Centrador de Pileta (BR3)';'Centrador 6 (BR4)'])

    subplot(326)
    //Grafico de contador de alarma
    //plot(time,contador,'r*')
    //plot(0,240) //max eje y
    //plot(0,-240) //max neg eje y
    //ylabel('Contador')
    //title('Contador de activacion de lógica')
    //legend(['Centrador 6';'Centrador de piletas'])
    //Grafico de Longitud por tracking
    plot(time_db(:,n),longitud_trk_db(:,n),'b-')
    ylabel('m')
    title('Longitud trk salida')

    subplot(323)
    //Grafico de desplazamiento en centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
    plot(time_db(:,n),-cpildesp_db(:,n),'r-')
    plot(time_db(:,n),amp_factor_desp_db(:,n)*c6desp_db(:,n),'b-')
    plot(0,240) //max eje y
    plot(0,-240) //max neg eje y

    ylabel('Desplazamiento de chapa [mm]')
    title('Posición C6 y Centrador de piletas por trending')
    legend(['Centrador de piletas';'Centrador 6*500%'])

    subplot(322)
    //Grafico de centrador 6 y centrador de piletas con desfazaje por trayecto de chapa
    plot(long_salida_db(:,n),amp_factor_pos_db(:,n)*c6pos_db(:,n),'b-')
    plot(long_centro_db(:,n)+85,cpilpos_db(:,n),'r-')
    plot(0,240) //max eje y
    plot(0,-240) //max neg eje y
    xlabel('Metros de chapa [m]')
    ylabel('Posicion centradores [%]')
    title('Posición C6 y Centrador de piletas por metro de chapa')
    legend(['Centrador 6*300%';'Centrador de piletas'])

    subplot(324)
    //Grafico de desplazamiento en centrador 6 y centrador de piletas sin desfazaje por trayecto de chapa
    plot(long_centro_db(:,n)+85,cpildesp_db(:,n),'r-')
    plot(long_salida_db(:,n),amp_factor_desp_db(:,n)*c6desp_db(:,n),'b-')
    plot(0,240) //max eje y
    plot(0,-240) //max neg eje y
    xlabel('Metros de chapa [m]')
    ylabel('Desplazamiento de chapa [mm]')
    title('Desplazamiento en C6 y Centrador de piletas por metro de chapa')
    legend(['Centrador de piletas';'Centrador 6*500%'])

endfunction
