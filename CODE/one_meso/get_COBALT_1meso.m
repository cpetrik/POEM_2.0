%%% Get COBALT data
function ENVR = get_COBALT_1meso(COBALT,GRD,ID,DY)

    %% Get data
    ENVR.Tp(:,1)  = COBALT.Tp(ID,DY);
    ENVR.Tb(:,1)  = COBALT.Tb(ID,DY);
    ENVR.Zm(:,1)  = COBALT.Zm(ID,DY) + COBALT.Zl(ID,DY);
    ENVR.dZm(:,1)  = COBALT.dZm(ID,DY) + COBALT.dZl(ID,DY);
    ENVR.det(:,1) = COBALT.det(ID,DY);
%     ENVR.U(:,1)   = COBALT.U(ID,DY);
%     ENVR.V(:,1)   = COBALT.V(ID,DY);
    ENVR.fZl(:,1) = zeros(length(ID),1);
    ENVR.fZb(:,1) = zeros(length(ID),1);
    ENVR.H(:,1)   = GRD.Z(ID);
    ENVR.A(:,1)   = GRD.AREA(ID);
end
