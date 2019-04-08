using Test

include("./AfqsJuliaUtil.jl")
using .AfqsJuliaUtil

@testset "polynomials" begin
    @test_throws ArgumentError polynomial_indices(1,0)
    @test_throws ArgumentError polynomial_expansion([1],0)
end;