function thr_rel = f_make_threhold(thr_rel, num_min, i)

thr_rel=thr_rel+(1-thr_rel)/(1+exp(-0.4*(i-num_min)));
