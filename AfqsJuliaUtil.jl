module AfqsJuliaUtil

using Combinatorics

export ExprCat
export polynomial_indices, polynomial_expansion

# A bad way to join quotes, but the first I got to work
function quotecat(quotes)
    ex = Expr(:block)
    for q in quotes
        for line in q.args
            push!(ex.args,line)
        end
    end
    ex
end

# A better way to handle quotes
sanitize_quotes(q::Expr) = (q.head == :block ? q.args : q )
ExprCat(quotes::Array) = ExprCat(quotes...)
ExprCat(quotes...) = Expr(:block, vcat(map(sanitize_quotes,quotes)...)...)
import Base.*
*(quote1::Expr,quote2::Expr) = ExprCat(quote1,quote2)
*(quotes::Expr...) = ExprCat(quotes...)


# Making polynomial basis sets
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

macro polynomial_function(len,order)
    terms = polynomial_indices(len,order)
    multiply_terms(indcs) = Expr(:call,*,[:(x[$i]) for i in indcs]...)
    quote
        function poly(x::Array{NumT}) where {NumT <: Number}
            NumT[$(map(multiply_terms,terms)...)]
        end
    end
end

end
