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
    
    p = @polynomial_function(1,1)
    println(p)
    @test p(1.0) == 1.0
    @test p([1.0]) == [1.0]
    @test p([[1.0],[2.0]]) == [[1.0],[2.0]]

    p3 = @polynomial_function(1,3)
    println(p3)
    @test p3(1.0) == [1.0,1.0,1.0]
    @test p3([1.0]) == [1.0,1.0,1.0]
    @test p3([[1.0]]) == [[1.0,1.0,1.0]]
    @test p3([[1.0],[2.0]]) == [[1.0,1.0,1.0],[2.0,4.0,8.0]]

end;
