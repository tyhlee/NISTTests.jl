module NISTTests

using CSV, DataFrames, StatsModels, GLM, Printf, RCall

export nist_data, coef, stderror, dispersion, r2, r², compare, modelcols, formula,
       nist_model, certified_values, estimated_values
export norris_data, norris_certified_values, norris_model, norris_compare, norris_model_formula
export pontius_data, pontius_certified_values, pontius_model, pontius_compare, pontius_model_formula
export filip_data, filip_certified_values, filip_model, filip_compare, filip_model_formula
export longley_data, longley_certified_values, longley_model, longley_compare, longley_model_formula
export noint1_data, noint1_certified_values, noint1_model, noint1_compare, noint1_model_formula
export noint2_data, noint2_certified_values, noint2_model, noint2_compare, noint2_model_formula
export julia_compare

const FP = AbstractFloat
const FPVector{T<:FP} = AbstractArray{T,1}
const _NIST_LR_DATASETS = [:Norris, :Pontius, :NoInt1, :NoInt2, :Filip, :Longley,
    :Wampler1, :Wampler2, :Wampler3, :Wampler4, :Wampler5]

abstract type NISTResults end                       # model comparison results
abstract type NISTModel end                         # model compa results

include("utils.jl")
include("nist.jl")
include("compare.jl")
include("noint.jl")
include("wampler.jl")
include("pontius.jl")
include("norris.jl")
include("longley.jl")
include("filip.jl")

end

