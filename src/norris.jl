
"""
```julia
norris_data
```
These data are from a NIST study involving calibration of ozone monitors.
The response variable (y) is the customer's measurement of ozone concentration and 
the predictor variable (x) is NIST's measurement of ozone concentration.
https://www.itl.nist.gov/div898/strd/lls/data/LINKS/i-Norris.shtml
"""

function norris_data(sink = DataFrame)
    get_nist_data(:Norris)
end

"""
```julia
norris_certified_values
```
NIST certified values for Norris dataset
"""
function norris_certified_values()
    NISTLRCertifiedValues(
        [-0.262323073774029, 1.00211681802045],
        [0.232818234301152, 0.429796848199937E-03],
        0.884796396144373,
        0.999993745883712,
        :Norris)
end

"""
```julia
norris_model_formula
```
Formula of the model for this dataset
"""
norris_model_formula() = @formula(y ~ 1 + x)



function norris_compare(beta, stderr, rsd, rsq)
    ct = norris_certified_values()
    compare(ct, beta, stderr, rsd, rsq)
end


"""
```julia
norris_certified_values
```
NIST certified values for Norris dataset
"""
function norris_certified_values()
    NISTLRCertifiedValues(
        [-0.262323073774029, 1.00211681802045],
        [0.232818234301152, 0.429796848199937E-03],
        0.884796396144373,
        0.999993745883712,
        :Norris)
end

function norris_model()
    NISTLRCModel(norris_data(), norris_model_formula(), :Norris)
end




"""
```julia
julia_summary_norris
```

Uses `julia` to calculate datas for Norris.
"""


function julia_summary_norris(filename)
    nist_d=get_nist_data(filename)
    jlm=lm(@formula(y~ x), nist_d)
    jbeta= coef(jlm)
    jse = stderror(jlm)
    jrsd = GLM.dispersion(jlm.model)
    jrsq=r2(jlm)
    return jbeta, jse, jrsd, jrsq
end

"""
```julia
R_summary_norris
```

Uses `R` to calculate datas for Norris.
"""

function R_summary_norris(filename)

    nist_ddata=get_nist_data(filename)

    @rput nist_ddata
    R"""
    options(digits=16)
    rlm = lm(y ~ x, data = nist_ddata)
    rbeta = coef(rlm)
    rse = sqrt(diag(vcov(rlm)))
    rrse = sigma(rlm)
    rrsq = summary(rlm)$r.squared
    """
    @rget rbeta
    @rget rse
    @rget rrse
    @rget rrsq

    return(rbeta,rse,rrse,rrsq)
end

"""
```julia
full_norris
```

Uses `julia` and `R` to calculate datas for Norris Dataset and displays them with actual NIST-Datasets.
"""

function full_norris(filename)    
    nist_beta=[]
    for i in range(1,2)
        append!(nist_beta,get_nist_beta(filename,i))
    end
    
    nist_se=[]
    for i in range(1,2)
        append!(nist_se,get_nist_standarderror(filename,i))
    end
    
    nist_rsd=get_nist_rsd(filename)
    nist_rsquare=get_nist_rsquare(filename)
    
    j_l=julia_summary_norris(filename)
    r_l=R_summary_norris(filename)

    df = DataFrame("NIST-Beta"=>nist_beta, "R-Beta"=>r_l[1], "Julia-Beta"=>j_l[1], 
    "NIST-SE"=>nist_se, "R-SE" => r_l[2], "Julia-SE" => j_l[2], 
    "NIST-RSD"=>nist_rsd, "R-RSD"=>r_l[3], "Julia-RSD"=>j_l[3], 
    "NIST-RSquare"=>nist_rsquare, "R-RSquare"=>r_l[4], "Julia-RSquare"=>j_l[4])
    
end

"""
```julia
full_compare_norris
```

Uses `julia` and `R` to calculate datas for Norris Dataset and compares them with actual NIST-Datasets and display.
"""

function full_compare_norris(filename)
    
    nist_beta=[]
    for i in range(1,2)
        append!(nist_beta,get_nist_beta(filename,i))
    end
    
    nist_se=[]
    for i in range(1,2)
        append!(nist_se,get_nist_standarderror(filename,i))
    end
    
    nist_rsd=get_nist_rsd(filename)
    nist_rsquare=get_nist_rsquare(filename)
    
    j_l=julia_summary_norris(filename)
    r_l=R_summary_norris(filename)
    
    j_beta=[]
    j_se=[]
    r_beta=[]
    r_se=[]
    
    for i in range(1,2)
        append!(j_beta,compare_nist_beta(filename,i,j_l[1][i]))
        append!(j_se,compare_nist_standarderror(filename,i,j_l[2][i]))
        append!(r_beta,compare_nist_beta(filename,i,r_l[1][i]))
        append!(r_se,compare_nist_standarderror(filename,i,r_l[2][i]))
    end
        

    df = DataFrame("NIST-Beta"=>nist_beta, "R-Beta Com"=>r_beta, "Julia-Beta Com"=>j_beta, 
    "NIST-SE"=>nist_se, "R-SE Com" => r_se, "Julia-SE Com" => j_se, 
    "NIST-RSD"=>nist_rsd, "R-RSD Com"=>compare_nist_rsd(filename,r_l[3]), "Julia-RSD Com"=>compare_nist_rsd(filename,j_l[3]), 
    "NIST-RSquare"=>nist_rsquare, "R-RSquare Com"=>compare_nist_rsquare(filename,r_l[4]), "Julia-RSquare Com"=>compare_nist_rsquare(filename,j_l[4]))
    
end