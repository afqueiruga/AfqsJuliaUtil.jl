module AfqsJuliaUtil

using Combinatorics

export quotecat
export polynomial_indices, polynomial_expansion

function quotecat(quotes)
    ex = Expr(:block)
    for q in quotes
        for line in q
            push!(ex.args,line)
        end
    end
    ex
end

function polynomial_indices(len,order)
    if order <= 0
        throw(ArgumentError("Polynomial Order <= 0 does not make sense."))
    end
    if len <= 0
        throw(ArgumentError("Polynomials with less than 0 variables do not make sense."))
    end
    indcs = []
    for o in 1:order
        append!(indcs, with_replacement_combinations(range(1,len),o) )
    end
    indcs
end

function polynomial_expansion(x, order)
    indcs = polynomial_indices(length(x), order)
    map( i->reduce(*,1,x[i]), indcs)
end

end