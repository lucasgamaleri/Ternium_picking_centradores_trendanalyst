function buscar_bobina(n)
    scf()
    plot(long_centro_db(:,n),cpildesp_db(:,n),'r-')
    plot(long_salida_db(:,n),c6desp_db(:,n),'b-')
    xlabel('metros')
    ylabel('Desplazamiento de chapa')
    legend(['Centrador de piletas';'Centrador 6'])
    title('BOBINA # '+string(n))
    
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
