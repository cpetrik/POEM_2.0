%%% Offline coupling
function [out_1, out_2, bf] = sub_offline_bent(enc_1,enc_2,bio_1,bio_2,B)
    con_1 = enc_1 .* bio_1;
    con_2 = enc_2 .* bio_2;
    
    out_1 = enc_1;
    out_2 = enc_2;
        
    id=((con_1 + con_2) > B);
    frac1(id,1) = con_1(id,1) ./ (con_1(id,1) + con_2(id,1));
    frac2(id,1) = con_2(id,1) ./ (con_1(id,1) + con_2(id,1));
    
    out_1(id,1) = (frac1(id,1) .* B(id,1)) ./ bio_1(id,1);
    out_2(id,1) = (frac2(id,1) .* B(id,1)) ./ bio_2(id,1);
        
    bf = (out_1.*bio_1 + out_2.*bio_2) ./ B; 
end
