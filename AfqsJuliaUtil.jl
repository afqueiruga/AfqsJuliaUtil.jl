module AfqsJuliaUtil

using Combinatorics
using MacroTools

using Images
using Plots

export ExprCat
export polynomial_indices, polynomial_expansion, @polynomial_function
export Azip
export plot_array2img

"Plot an array as an image, automatically squaring it if needed."
function plot_array2img(A::Array{T}, shape=0) where T
    if shape==0
        shape = map(y->trunc(Int,y), ( (sqrt(length(A))),length(A)/sqrt(length(A)) ) )
    end
    cv = colorview(Gray, reshape(A, shape) )
    #plot(0:1:shape[1],0:1:shape[2], cv)
end

"Do a zip but return a 2d array instead of a pesky array of tuples"
Azip(dat...) = hcat([ collect(a) for a in zip(dat...)]...)

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
"Join together an array of quotes and Expressions into one quote block."
ExprCat(quotes...) = Expr(:block, vcat(map(sanitize_quotes,quotes)...)...)
import Base.*
*(quote1::Expr,quote2::Expr) = ExprCat(quote1,quote2)
"String-concatenation syntax for an array of quotes and Expressions into one quote block."
*(quotes::Expr...) = ExprCat(quotes...)


# Making polynomial basis sets
"Return an array of all exponents for polynomials of `order` with `len` variables." 
function polynomial_indices(len,order)
    if order <= 0
        throw(ArgumentError("Polynomial Order <= 0 does not make sense."))
    end
    if len <= 0
        throw(ArgumentError("Polynomials with less than 0 variables do not make sense."))
    end
    indcs = []
    for o in 1:order
        append!(indcs, with_replacement_combinations(1:len,o) )
    end
    indcs
end

"Return all polynomial terms on an array x. Dynamically checks the length of x."
function polynomial_expansion(x, order)
    indcs = polynomial_indices(length(x), order)
    map( i->reduce(*,1,x[i]), indcs)
end

"Return a function that calculates the terms of a polynomial for a fixed length
array."
macro polynomial_function(len,order)
    terms = polynomial_indices(len,order)
    multiply_terms(indcs) = Expr(:call,*,[:(x[$i]) for i in indcs]...)
    Q = quote
        @inline function poly(x::Array{NumT}) where {NumT <: Number}
            @inbounds begin
                NumT[$(map(multiply_terms,terms)...)]
            end
        end
        @inline function poly(x::Array{Array{NumT,1},1}) where {NumT <: Number}
            poly.(x)
        end
        @inline function poly(x::Array{NumT,2}) where {NumT <: Number}
            #hcat(poly.(x)...)
            hcat([poly(y) for y in x]...)
        end
    end 
    if len==1 && order==1
        Q *= quote
            @inline function poly(x::NumT) where {NumT <:Number}
                poly([x])[1]
            end
        end
    elseif len==1
         Q *= quote
            @inline function poly(x::NumT) where {NumT <:Number}
                poly([x])
            end
        end 
    end
    # println(rmlines(Q))
    Q
end

function polynomial_function(len,order)
    terms = polynomial_indices(len,order)
    multiply_terms(indcs) = Expr(:call,*,[:(x[$i]) for i in indcs]...)
    poly = gensym("poly")
    Q = quote
        @inline function $poly(x::Array{NumT}) where {NumT <: Number}
            @inbounds begin
                NumT[$(map(multiply_terms,terms)...)]
            end
        end
        @inline function $poly(x::Array{Array{NumT,1},1}) where {NumT <: Number}
            $poly.(x)
        end
        @inline function $poly(x::Array{NumT,2}) where {NumT <: Number}
            #hcat(poly.(x)...)
            hcat([$poly(y) for y in x]...)
        end
    end 
    if len==1 && order==1
        Q *= quote
            @inline function $poly(x::NumT) where {NumT <:Number}
                $poly([x])[1]
            end
        end
    elseif len==1
         Q *= quote
            @inline function $poly(x::NumT) where {NumT <:Number}
                $poly([x])
            end
        end 
    end
    # println(rmlines(Q))
    eval(Q)
end
    
end
