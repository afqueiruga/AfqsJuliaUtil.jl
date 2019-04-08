using Test

include("./AfqsJuliaUtil.jl")
using .AfqsJuliaUtil

@testset "quoting" begin
    quotes = [
        quote
            a=1
        end,
        quote
            b=3
            println("hello")
        end
    ]
    catted = quotecat(quotes)
    println(catted)
    @test length(catted.args) == sum([length(q.args) for q in quotes])
end;

@testset "polynomials" begin
    @test_throws ArgumentError polynomial_indices(1,0)
    @test_throws ArgumentError polynomial_expansion([1],0)
end;