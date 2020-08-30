%============== INITIAL CONDITIONS =============%
function ENV = sub_init_env_empHP(ID)
    %%%! Number of spatial cells
    NX = length(ID);
    ENV.Tp  = NaN*ones(NX,1);
    ENV.Tb  = NaN*ones(NX,1);
    ENV.Zm  = NaN*ones(NX,1);
    ENV.dZm  = NaN*ones(NX,1);
    ENV.det = NaN*ones(NX,1);
    ENV.U   = NaN*ones(NX,1);
    ENV.V   = NaN*ones(NX,1);
    ENV.fZl = NaN*ones(NX,1);
    ENV.H  = NaN*ones(NX,1);
    ENV.A  = NaN*ones(NX,1);
end
