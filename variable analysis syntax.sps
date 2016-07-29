* Encoding: UTF-8.
begin program.
#setup the total_sum_pred_conf  vars
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]

import spss,spssaux
trans_to_join = []
extreme_to_join = []
for ad in ad_names:
    trans_var_name  = ad+"_pred_conf_transformed"
    trans_to_join.append(trans_var_name)
    
    extre_var_name  = ad+"_pred_conf_extremized"
    extreme_to_join.append(extre_var_name)

joined_trans_ad_string = ",".join(trans_to_join )
joined_extre_to_join_for_correct = ",".join(extreme_to_join )
print joined_extre_to_join_for_correct
spss.Submit("COMPUTE  total_sum_pred_conf_transformed = SUM("+joined_trans_ad_string+")")
spss.Submit("COMPUTE  total_sum_pred_conf_extremized = SUM("+joined_extre_to_join_for_correct+").")
end program.


begin program.
#setup the prediction confidence and extremize conf
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]

import spss,spssaux
vdict=spssaux.VariableDict()

for ad in ad_names:
    new_var_name = ad+"_pred_conf_transformed"
    pred_conf = vdict[ad+"_prediction_conf"]
    
    spss.Submit("COMPUTE "+new_var_name+" = ("+str(pred_conf)+"/21)")
    spss.Submit("IF  ("+new_var_name+" = 0) "+new_var_name+"= .005")   

    extremized_var_name = ad+"_pred_conf_extremized"
    v = new_var_name
    spss.Submit("COMPUTE "+extremized_var_name+" = "+"("+v+"**2.5)/(("+v+"**2.5) +((1-"+v+")**2.5))")
    
    pred_correctness = vdict[ad+"_did_make_correct_prediction"]
    spss.Submit("COMPUTE "+new_var_name+" = "+new_var_name+"*"+str(pred_correctness))
    spss.Submit("COMPUTE "+extremized_var_name+" = "+extremized_var_name+"*"+str(pred_correctness))
end program.

COMPUTE  total_avg_predicted_score =total_num_predicted_correct / total_num_predicted .

begin program.
#setup the did_make_correct_prediction vars
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]

import spss,spssaux
vars_to_join = []
vars_to_join_for_correct = []
for ad in ad_names:
    vars_to_join.append(ad+"_did_make_correct_prediction")
    vars_to_join_for_correct.append("ANY("+ad+"_did_make_correct_prediction,1)")

joined_ad_string = ",".join(vars_to_join )
joined_vars_to_join_for_correct = ",".join(vars_to_join_for_correct )
print joined_vars_to_join_for_correct
#spss.Submit("COMPUTE  total_num_predicted = NVALID("+joined_ad_string+").")
spss.Submit("COMPUTE  total_num_predicted_correct = SUM("+joined_vars_to_join_for_correct+").")
end program.



begin program.
#setup the did_make_correct_prediction vars
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]
ad_outcomes = [1,2,1,1, 1,1,2,1,2, 1, 1,2,2, 1,1,1 ]

import spss,spssaux

vdict=spssaux.VariableDict()
#ss = vdict["ba_score"]
#print ss
for ad in ad_names:
    new_var_name = ad+"_did_make_correct_prediction"
    pred_var = vdict[ad+"_prediction_pref"]
    outcome_var = vdict[ad+"_outcome"]
    #spss.Submit("COMPUTE "+new_var_name+" = "+str(ad_outcomes[i])+"")
    #spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(ad_names[i]+"_outcome", "Most preferred "+ad_names[i]+" ad"))


    #SPECIFY IF THE CORRECT PREDICTION WAS MADE
    spss.Submit("IF  ("+str(pred_var)+" = "+str(outcome_var)+") "+new_var_name+"= 1")
    spss.Submit("IF  ("+str(pred_var)+" ~= "+str(outcome_var)+") "+new_var_name+"= -1")   

             
for i in range(len(ad_names)): 
    outcome_var_name = ad_names[i]+"_outcome"
    #spss.Submit("COMPUTE "+ad_names[i]+"_outcome = "+str(ad_outcomes[i])+"")
    #spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(ad_names[i]+"_outcome", "Most preferred "+ad_names[i]+" ad"))
           
end program.


IF  (Q006a_ba_53 = ba_outcome) ba_score=(((ba_pred_confidence/100))**2)

IF  (Q006a_ba_53~= ba_outcome) ba_score=-(((ba_pred_confidence/100))**2)

