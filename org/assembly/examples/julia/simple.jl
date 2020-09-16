function add5(n)
    n + 5
end

function return15()
    a::Int64 = 9
    add5(a + 1)
end

println("add5, Int64:")
code_native(add5, (Int64,), syntax = :intel)

println("add5, Float64:")
code_native(add5, (Float64,), syntax = :intel)

println("return15:")
code_native(return15, (), syntax = :intel)
