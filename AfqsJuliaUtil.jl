module AfqsJuliaUtils

using Combinatorics

function quotecat(quotes)
    ex = Expr(:block)
    for q in quotes
        for line in q
            push!(ex.args,line)
        end
    end
    ex
end

function polynomial_coefficients(len,order)
    indcs = []
    for o in 1:order
        append!(indcs, with_replacement_combinations(range(1,len),o)
    end
    indcs
end


end