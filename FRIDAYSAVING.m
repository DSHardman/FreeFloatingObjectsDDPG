    if sv
        matname = strcat('C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\RL',string(datetime),'.mat');
        save(matname, 'results');
    end