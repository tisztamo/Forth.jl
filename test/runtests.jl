using Forth
using Test

import Forth.interpret

function pushnums(forth)
    interpret(forth, "2.1")
    @test forth.stack[end] == 2.1

    interpret(forth, "10")
    @test forth.stack[end] == 10
end

@testset "VM basics" begin
    out = IOBuffer()
    vm = VM(out)
    interpret(vm, "asd")
    @test String(take!(out)) == "?"
    pushnums(vm)
end

@testset "Interpreter basics" begin
    forth = interpreter()
    pushnums(forth)
    interpret(forth, "+")
    @test length(forth.stack) == 1
    @test forth.stack[end] == 12.1
end

@testset "Defining new words" begin
    forth = interpreter()
    Forth.define(forth, "5*", ["5", "*"])
    pushnums(forth)
    interpret(forth, "5*")
    @test length(forth.stack) == 2
    @test forth.stack[end] == 50
end

@testset "Execute" begin
    out = IOBuffer()
    forth = interpreter(out)
    execute(forth, "5 6 +")
    @test forth.stack[end] == 11

    execute(forth, ".")
    @test length(forth.stack) == 0
    @test String(take!(out)) == "11.0"
end

@testset "Defining with : and ;" begin
    forth = interpreter()
    execute(forth, ": 5* 5 * ;")
    pushnums(forth)
    interpret(forth, "5*")
    @test length(forth.stack) == 2
    @test forth.stack[end] == 50
end