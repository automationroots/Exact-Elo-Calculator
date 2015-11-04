function ELOsimulation()
    disp("Simulation of the ELO rating system for 4 chess players");

    % set the initial ELO of the players 
    estimatedELO= [1500 1500 1500 1500]';
    registry= estimatedELO;

    % iterate to get the exact ELO
    for k=1:20
        estimatedELO = calculateELO(estimatedELO);
        registry= [registry estimatedELO];
    endfor

    figure(1)

    hold on
    for k=1:4
        plot(registry(k,:))
    endfor
    hold off

endfunction

function Eai= expectedScore(Ra, Ri)
    Eai= 1 / ( 1 + 10^((Ri-Ra)/400) );
endfunction

function R= calculateELO(ELO)
    %total sum
    total= sum(ELO);

    %average ELO of enemies for every player
    average= (total - ELO) / 3;

    %real ELO of players (used only to calculate the exact expected score of every player)
    x= [1300 1800 1200 1700]';

    %calculate the logarithm of the geometric mean
    product= [1 1 1 1]';

    for j=1:4
        e= [1 1 1 1]';

        for i=1:4
            % when i == j we have that e(i) == 1 , so we can safely ignore this value of e(i) in the product
            if( i ~= j )
                e(i)= expectedScore(x(i), x(j));
                e(i)= e(i)/(1-e(i));
            endif
        endfor

        product= product .* e;
    endfor

    % 400 times the logarithm of the geometric mean
    product= (400/3)*log10(product);

    %calculate the new ELO matrix
    R= average + product;
endfunction
