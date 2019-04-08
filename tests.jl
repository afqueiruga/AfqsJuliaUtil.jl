using Test

include("./AfqsJuliaUtil.jl")
using .AfqsJuliaUtil
import .AfqsJuliaUtil.*
@testset "quoting" begin
    @test begin
        quotes = [
            quote
                a=1
            end,
            quote
                b=3
                println("hello")
            end
        ]
        catted = ExprCat(quotes)
        println(catted)
        length(catted.args) == sum([length(q.args) for q in quotes])
    end
    
    @test begin
        quotes = [
            quote
                a=1
            end,
            quote
                b=3
                println("hello")
            end
        ]
        catted = foldr(*, quotes)
        println(catted)
        length(catted.args) == sum([length(q.args) for q in quotes])
    end
    @test begin
        quotes = [
            quote
                a=1
            end,
            :(println("foo"))
        ]
        catted = foldr(*, quotes)
        println(catted)
        length(catted.args) == sum([length(q.args) for q in quotes[1:1]]) + 1
    end
end;

@testset "polynomials" begin
    @test_throws ArgumentError polynomial_indices(1,0)
    @test_throws ArgumentError polynomial_expansion([1],0)
end;
