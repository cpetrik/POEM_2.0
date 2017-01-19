%%% Fraction of time spent in pelagic (for demersal)
function tdif = sub_tdif_dem(Z,bio1,bio2,bio3,bio4)
    % bio1, bio2: pelagic prey
    % bio3, bio4: demersal prey

    global PI_be_cutoff 

    biop = bio1+bio2;
    % use preference for benthic prey in calculation
    %biod = bio3+(LD_phi_BE*bio4)
    biod = bio3+bio4;
    if Z < PI_be_cutoff
        tdif = biop ./ (biop+biod);
    else
        tdif = 0.0;
    end
end
