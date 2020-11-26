using CurveFit
using Test
using LinearAlgebra
using Polynomials

lspf(start, stop, len) = range(start, stop=stop, length=len)

@testset "CurveFit.jl" begin

# Testing linear fit
x = lspf(1,10,10);
fun0(x) = 1.0 + 2.0*x
y = fun0.(x)
f = linear_fit(x, y)

@test f[1] ≈ 1.0 atol=1.0e-7
@test f[2] ≈ 2.0 atol=1.0e-7

f = curve_fit(LinearFit, x, y)
@test f(1.5) ≈ fun0(1.5) atol=1.0e-7

# power
fun1(x) = 1.0 + 2.0*log(x)
y = fun1.(x)
f = log_fit(x, y)
@test f[1] ≈ 1.0 atol=1.0e-7
@test f[2] ≈ 2.0 atol=1.0e-7
f = curve_fit(LogFit, x, y)
@test f(1.5) ≈ fun1(1.5) atol=1.0e-7


# log
fun2(x) = 2.0*x.^0.8
y = fun2(x)
f = power_fit(x, y)
@test f[1] ≈ 2.0 atol=1.0e-7
@test f[2] ≈ 0.8 atol=1.0e-7
f = curve_fit(PowerFit, x, y)
@test f(1.5) ≈ fun2(1.5) atol=1.0e-7


# Exp
fun3(x) = 2.0*exp.(0.8*x)
y = fun3(x)
f = exp_fit(x, y)
@test f[1] ≈ 2.0 atol=1.0e-7
@test f[2] ≈ 0.8 atol=1.0e-7
f = curve_fit(ExpFit, x, y)
@test f(1.5) ≈ fun3(1.5) atol=1.0e-7


# Poly
fun4(x) = 1.0 + 2.0*x + 3.0*x^2 + 0.5*x^3
y = fun4.(x)
f = poly_fit(x, y, 4)
@test f[1] ≈ 1.0 atol=1.0e-7
@test f[2] ≈ 2.0 atol=1.0e-7
@test f[3] ≈ 3.0 atol=1.0e-7
@test f[4] ≈ 0.5 atol=1.0e-7
@test f[5] ≈ 0.0 atol=1.0e-7


f = curve_fit(Polynomial, x, y, 4)
@test f(1.5) ≈ fun4(1.5) atol=1.0e-7 

# Polynomials with large numbers
coefs = [80.0, -5e-18, -7e-20, -1e-36]
P = Polynomial(coefs)
x1 = 1e10 * (0:0.1:5)
y1 = P.(x1)
P2 = curve_fit(Polynomial, x1, y1, 3)
c = coeffs(P2)    
@test coefs[1] ≈ c[1] rtol=1e-5
@test coefs[2] ≈ c[2] rtol=1e-5
@test coefs[3] ≈ c[3] rtol=1e-5
@test coefs[4] ≈ c[4] rtol=1e-5


# King's law
U = [lspf(1, 20, 20);]
A = 5.0
B = 1.5
n = 0.5
E = sqrt.(A .+ B*U.^n)
fun5(E) = ((E.^2 - A)/B).^(1 ./ n)

f = linear_king_fit(E, U)
@test f[1] ≈ A atol=1.0e-7
@test f[2] ≈ B atol=1.0e-7
f= curve_fit(LinearKingFit, E, U)
@test f(3.0) ≈ fun5(3.0) atol=1.0e-7

# Modified King's law
n = 0.42

E = sqrt.(A .+ B.*U.^n)
fun6(E) = ((E^2 - A)/B)^(1 / n)

f = king_fit(E, U)
@test f[1] ≈ A atol=1.0e-7
@test f[2] ≈ B atol=1.0e-7
@test f[3] ≈ n atol=1.0e-7
f= curve_fit(KingFit, E, U)
@test f(3.0) ≈ fun6(3.0) atol=1.0e-5



# Linear Rational fit
r =  RationalPoly([1.0, 0.0, -2.0], [1.0, 2.0, 3.0])
y = r.(x)
f = linear_rational_fit(x, y, 2, 3)
@test f[1] ≈ 1.0 atol=1.0e-8
@test f[2] ≈ 0.0 atol=1.0e-8
@test f[3] ≈ -2.0 atol=1.0e-8
@test f[4] ≈ 2.0 atol=1.0e-8
@test f[5] ≈ 3.0 atol=1.0e-8
@test f[6] ≈ 0.0 atol=1.0e-8

# Nonlinear Rational fit
f = rational_fit(x, y, 2, 3)

@test f[1] ≈ 1.0 atol=1.0e-7
@test f[2] ≈ 0.0 atol=1.0e-7
@test f[3] ≈ -2.0 atol=1.0e-7
@test f[4] ≈ 2.0 atol=1.0e-7
@test f[5] ≈ 3.0 atol=1.0e-7
@test f[6] ≈ 0.0 atol=1.0e-7



f = curve_fit(RationalPoly, x, y, 2, 3)
@test f(1.5) ≈ r(1.5) atol=1.0e-8
@test f(4.5) ≈ r(4.5) atol=1.0e-8





end
