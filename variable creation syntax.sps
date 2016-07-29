* Encoding: UTF-8.

STRING #ad_pair_name (a20).
COMPUTE #ad_pair_name='fghf_'.
COMPUTE temp_var = 1.
EXECUTE.
RENAME VARIABLES temp_var = jjjjjj.

COMPUTE ba_pred_confidence=(50*(Q006b__1_ba_53+21)/21). 
VARIABLE LABELS  ba_pred_confidence 'predicted confidence percentage (BA)'.

COMPUTE be_pred_conf_extremize=((ba_pred_confidence/100)**2.5)/(((ba_pred_confidence/100)**2.5) +((1-(ba_pred_confidence/100))**2.5)).
VARIABLE LABELS  be_pred_conf_extremize 'predicted confidence percentage (BA)'.



IF  (Q006a_ba_53 = ba_outcome) ba_score=(((ba_pred_confidence/100))**2)

IF  (Q006a_ba_53~= ba_outcome) ba_score=-(((ba_pred_confidence/100))**2)

loop # = 1 to 3.
compute sentence = replace(sentence,' ',' ').
end loop.

begin program.
#This program alters the variable labels //DONT RUN AGAIN
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]
ad_name ='_2012' # Specify suffix.

import spss,spssaux

vdict=spssaux.VariableDict()
for ad in ad_names:
    substr = "a_"+ad+"_"
    for variable in vdict:
        #print ad
        if substr in str(variable):
            #print('Match found: ', variable)
            #spss.Submit("COMPUTE temp_var"+ad_name+" = 1")
            spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(variable.VariableName, variable.VariableLabel + " ("+ad+")"))
            #break
end program.



begin program.
#This program gnerates the pie charts for all the nessary variables
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]
ad_name ='_2012' # Specify suffix.

import spss,spssaux

vdict=spssaux.VariableDict()
for ad in ad_names:
    substr = "a_"+ad+"_"
    for variable in vdict:
        #print ad
        if substr in str(variable):
            #print('Match found: ', variable)
            #spss.Submit("COMPUTE temp_var"+ad_name+" = 1")
            spss.Submit("""
            FREQUENCIES VARIABLES=%s
              /FORMAT dfreq
              /PIECHART.
            """ %(variable))
            break
end program.



begin program.
#initialize the ad outcomes
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]
ad_outcomes = [1,2,1,1, 1,1,2,1,2, 1, 1,2,2, 1,1,1 ]

import spss,spssaux

#vdict=spssaux.VariableDict()
for i in range(len(ad_names)): 
    outcome_var_name = ad_names[i]+"_outcome"
    spss.Submit("COMPUTE "+ad_names[i]+"_outcome = "+str(ad_outcomes[i])+"")
    spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(ad_names[i]+"_outcome", "Most preferred "+ad_names[i]+" ad"))
           
end program.

begin program.
#setup the computation vars
ad_names = ['ba','adidas1','burbury','cola', 'j20','lucazade','mands','mb1','mul', 'samsung', 'spsp','dogfood','asda', 'magnum1','mub','walls' ]
ad_outcomes = [1,2,1,1, 1,1,2,1,2, 1, 1,2,2, 1,1,1 ]

import spss,spssaux

vdict=spssaux.VariableDict()
#ss = vdict["ba_score"]
#print ss
for ad in ad_names:
    substr = "a_"+ad+"_"
    substr2 = "b__1_"+ad+"_"
    substr_firstfound = False
    substr2_firstfound = False
    for variable in vdict:
       #print ad
        if substr in str(variable):
            if not substr_firstfound:
                print('first found: ', variable, "new name", ad+"_opinion_pref")
                new_ad_name= ad+"_opinion_pref"
                
                spss.Submit("COMPUTE "+new_ad_name+" = "+str(variable)+"")
                spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(new_ad_name, variable.VariableLabel))
                
                substr_firstfound = True
            else:
                new_ad_name= ad+"_prediction_pref"
                
                spss.Submit("COMPUTE "+new_ad_name+" = "+str(variable)+"")
                spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(new_ad_name, variable.VariableLabel))
                
                print('second found: ', variable, "new name", ad+"_prediction_pref")

        elif substr2 in str(variable):
            if not substr2_firstfound:
                print('substr2  first found: ', variable, "new name", ad+"_opinion_conf")
                new_ad_name= ad+"_opinion_conf"
                
                spss.Submit("COMPUTE "+new_ad_name+" = "+str(variable)+"")
                spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(new_ad_name, "Opinion confidence"+" ("+ad+")"))
                
                substr2_firstfound = True
            else:
                print('substr2 second found: ', variable, "new name", ad+"_prediction_conf")
                new_ad_name= ad+"_prediction_conf"
                
                spss.Submit("COMPUTE "+new_ad_name+" = "+str(variable)+"")
                spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(new_ad_name, variable.VariableLabel +" ("+ad+")"))
                
for i in range(len(ad_names)): 
    outcome_var_name = ad_names[i]+"_outcome"
    #spss.Submit("COMPUTE "+ad_names[i]+"_outcome = "+str(ad_outcomes[i])+"")
    #spss.Submit(r"""VARIABLE LABELS %s "%s" .""" %(ad_names[i]+"_outcome", "Most preferred "+ad_names[i]+" ad"))
           
end program.



