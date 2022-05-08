function idx = RouletteWheel( P )

idx = 0;
N = size(P,1);

% calculate cumulative probabilities
cumProb = zeros(N, 1);
for i = 1:N
    cumProb(i, 1) = sum(P(1:i));
end
cumProb = cumProb / cumProb(N);
cumProb = [0; cumProb];

% perform roulette wheel
rnd = rand;
for i = 1:N
    if(cumProb(i)<=rnd && rnd<cumProb(i+1))
        idx = i;
        break
    end
end

if(idx==0)
    disp('NO!')
end

end