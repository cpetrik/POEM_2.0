###! Get COBALT data
function get_COBALT!(COBALT,ID,DY,ENVR,Tref,Dthresh)
    ## Get data
    ENVR.Tp[:,1]  = COBALT["Tp"][ID,DY]
    ENVR.Tb[:,1]  = COBALT["Tb"][ID,DY]
    ENVR.Zm[:,1]  = COBALT["Zm"][ID,DY]
    ENVR.Zl[:,1]  = COBALT["Zl"][ID,DY]
    ENVR.det[:,1] = COBALT["det"][ID,DY]
    ENVR.dZm[:,1] = COBALT["dZm"][ID,DY]
    ENVR.dZl[:,1] = COBALT["dZl"][ID,DY]
    ENVR.U[:,1]   = COBALT["U"][ID,DY]
    ENVR.V[:,1]   = COBALT["V"][ID,DY]
    ENVR.T0[:,1] = Tref[ID]
    #ENVR.T0[:,1] = minimum(COBALT["Tp"][ID,:])
    ENVR.Dthresh[:,1] = Dthresh[ID]
end


###! Metabolism
function sub_met(bas,T,U)
	#! I think I need to redo including Activity multiplier better
	#! NOTE: keeping temp multiplier constant (at 12degC) across space
	met = bas * exp(0.03*(U*100/60/60/24)) * 5.258
	#met = bas * exp(0.0548*12) * exp(0.03*(U*100/60/60/24)) * 5.258
end


###! Fraction of time spent in pelagic (for piscivore)
function sub_tdif_pel(Z,bio1,bio2,biod)
	biop = bio1+bio2
	if Z < PI_be_cutoff
		tdif = biop ./ (biop+biod)
	else
		tdif = 1.0
	end
	return tdif
end

###! Fraction of time spent in pelagic (for demersal)
function sub_tdif_dem(Z,bio1,bio2,bio3,bio4)
	biop = bio1+bio2+bio3
  biod = bio4
	if Z < PI_be_cutoff
		tdif = biop ./ (biop+biod)
	else
		tdif = 0.0
	end
	return tdif
end


###!  Encounter rates
function sub_enc(pred,prey,a,td)
	# pred biomass density,
	# prey biomass density,
	# predator search rate,
	# time spent in pelagic.
	enc = pred*prey*a*td
end


###! Type I consumption
function sub_cons(enc,met)
	#! calculates consumption rate of first element of enc
	ENC = sum(enc) # total biomass encountered
	#tau = 1/ (4*met) # handling time
  # CAP BIOMASS CONSUMED BY TOTAL BIOMASS
  tau = 1/met
	out = enc[1] / (1+(tau*ENC)) # Type II
end


###! Offline coupling
function sub_offline(enc_1,enc_2,enc_3,dZ)
	#! offline switch
	if (enc_1 + enc_2 + enc_3) > dZ
		frac1 = enc_1 / (enc_1 + enc_2 + enc_3)
    frac2 = enc_2 / (enc_1 + enc_2 + enc_3)
    frac3 = enc_3 / (enc_1 + enc_2 + enc_3)
		out_1 = (frac1 * dZ)
		out_2 = (frac2 * dZ)
    out_3 = (frac3 * dZ)
	else
		out_1 = enc_1
		out_2 = enc_2
    out_3 = enc_3
	end
	return out_1, out_2, out_3
end


###! DEGREE DAYS
function sub_degday(dd,Tp,Tb,tdif,Tref,S,dtot)
  #if (S==0.0) #Don't accumulate temp while spawning, DD represents recovery after
  #if (sum(S[1:dtot]) < dtot) #Only spawn once per year
  if (sum(S[1:dtot]) > 0.0) #Only spawn once per year
    dd = 0.0
  else
    Tavg = (Tp.*tdif) + (Tb.*(1.0-tdif))
    dd += max((Tavg-Tref),0.0)
  end
  return dd
end


###! SPAWNING FLAG
function sub_kflag(S,dd,dthresh,dtot,lat)
  if (dd >= dthresh)
    dur=59
    #Change spawning flag
    if ((dtot+dur) <= DAYS)
      S[dtot:(dtot+dur)] = Sp
    else
      dleft = DAYS - dtot + 1
      S[dtot:DAYS] = Sp[1:dleft]
    end
    #Reset cumulative deg days
    dd = 0.0
  end
  return S, dd
end


###! ENERGY AVAILABLE FOR GROWTH NU
function sub_nu(I,B,met)
	# convert to biomass specific ingestion
	nu = ((I/B)*Lambda) - met
end


###! ENERGY AVAILABLE FOR SOMATIC GROWTH
function sub_gamma(K,Z,nu,d,B,S)
  # convert predation mortality to biomass specific rate
	D = (d/B) + Nat_mrt
  # Spawning flag
  if S>0.0
    kap=min(1.0, K + (1.0-S));
  else
    kap=1;
  end
	gg = ((kap*nu) - D)/(1-(Z^(1-(D/(kap*nu)))))
  if gg < 0 || isnan(gg)==true
		gamma = 0.0
	else
    gg = min(gg,nu)
		gamma = gg
	end
	return gamma
end


###! BIOMASS MADE FROM REPRODUCTION
function sub_rep(nu,K,S)
	if nu > 0.
    # Spawning flag
    if S>0.0
      kap=min(1.0, K + (1.0-S));
    else
      kap=1.0;
    end
		rep = (1-kap) * nu
	else
		rep = 0.
	end
	return rep
end

###! Biomass recruiting to size-class (g m-2 d-1)
function sub_rec(X,bio)
	# X could be biomass of eggs (for larval class) or maturing from smaller sizes
	rec = 0.0
	for i = 1:length(X)
		rec += X[i] * bio[i]
	end
	return rec
end


###! Update biomass
function sub_update_fi(bio_in,rec,nu,rep,gamma,die)
	# all inputs except rec are in g g-1 d-1; rec is g d-1
	# rec = rep from smaller size class = TOTAL biomass gained from recruitment
	# grw = nu = somatic growth within size class
	# rep = rep =  biomass lost to egg production
	# mat = gamma = biomass maturing to larger size class
	# Nat_mrt = natural mortality
	# die = predator mort = biomass lost to predation
  db = rec + ((nu - rep - gamma - Nat_mrt) * bio_in) - die
  bio_out =  bio_in + db
end

function sub_update_be(bio_in,det,die,bio_p)
  eat = sum(die.*bio_p)
  db = det - eat
	bio_out = bio_in + db
end


####! Fishing
#function sub_fishing(bio_pi,bio_pl,bio_de,AREA)
#	if FISHING > 0.0
#		#bio_pi = PISC.bio; bio_pl = PLAN.bio; bio_de = DETR.bio; AREA = GRD_A;
#		ALL_pi  = Array(Float64,NX,PI_N)
#		ALL_pl  = Array(Float64,NX,PL_N)
#		ALL_de  = Array(Float64,NX,DE_N)
#
#		for i = 1:NX
#			ALL_pi[i,:] = bio_pi[i] * AREA[i]
#			ALL_pl[i,:] = bio_pl[i] * AREA[i]
#			ALL_de[i,:] = bio_de[i] * AREA[i]
#		end
#
#		#! Total fish biomass
#		TOT = sum(ALL_pi) + sum(ALL_pl) + sum(ALL_de)
#		ALL_pi -= (ALL_pi./TOT).*FISHING
#		ALL_pl -= (ALL_pl./TOT).*FISHING
#		ALL_de -= (ALL_de./TOT).*FISHING
#
#		#! Calc total biomass of fish in the ocean
#		for i = 1:NX
#			bio_pi[i] = squeeze(ALL_pi[i,:],1) ./ AREA[i]
#			bio_pl[i] = squeeze(ALL_pl[i,:],1) ./ AREA[i]
#			bio_de[i] = squeeze(ALL_de[i,:],1) ./ AREA[i]
#		end
#	end
#	return bio_pi, bio_pl, bio_de
#end


###! Forward Euler checks
function sub_check!(bio)
	ID = find(bio .< 0)
	bio[ID] = eps()
end
