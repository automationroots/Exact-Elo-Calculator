%Calculating the ELO rating with the current approximation of the expected score of each player over the others
%It is assumed that each player has had several games with the others so that we have a good approximation of the expected score
%to avoid ELO results which tend to infinity initialize the 'draws' matrix to a matrix of ones.

%Author: David Toro
%Date: 02/Nov/2015

function ELO(wins, draws)
    %  wins: square matrix where each element (i,j) corresponds to the victories of the player i over the player j, the diagonal 
    %        is irrelevant
    % draws: symmetric square matrix where each element (i,j) corresponds to the draws of the player i with the player j, the 
    %        diagonal is irrelevant 

    % we calculate the results of each player
    result= wins + 0.5*draws;

    % we calculate the number of games played by every player, note that the matrix of defeats is the transpose of the 'wins' matrix
    games= wins + wins' + draws;

    % calculating the matrix of expected scores
    expectedScore= result ./ games;

    % Total number of players
    N= size(wins)(1);

    % initial value of ELO matrix
    estimatedELO= 1500*ones(N,1);
    
    % saving data for the graph
    registry= estimatedELO;

    % iteration to get the ELO rating of the players with the current approximation of the expected score
    do
        old= estimatedELO; 
        estimatedELO = calculateELO(estimatedELO, expectedScore);
        registry= [registry estimatedELO];
    until ( sum(abs(estimatedELO - old))/ N < 0.001 )

    % plot the evolution of the ELO rating of every player through the iterations
    figure(1)
    hold on
    for k=1:N
        plot(registry(k,:))
    endfor
    hold off        

endfunction

function R= calculateELO(estimatedELO, expectedScore)
    %calculate the total sum of the ELO
    total= sum(estimatedELO);

    % Total number of players
    N= size(estimatedELO)(1);

    %calculate the average ELO rating of the enemies of every player
    average= (total - estimatedELO) / (N-1);

    %calculate the logarithm of the geometric mean
    product= ones(N,1);

    for j=1:N
        e= ones(N,1);

        for i=1:N
            % when i == j we have that e(i) == 1 , so we can safely ignore this value of e(i) in the product
            if( i ~= j )
                e(i)= expectedScore(i, j);
                e(i)= e(i)/(1-e(i));
            endif
        endfor

        product= product .* e;
    endfor

    % 400 times the logarithm of the geometric mean
    product= (400/(N-1))*log10(product);

    %calculate the new ELO matrix
    R= average + product;
endfunction
