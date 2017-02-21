struct ComplexNumber {
    let Re: Double
    let Im: Double
    
    init() { self.Re = 0.0; self.Im = 0.0}
    init(_ real: Double) { self.Re = real; self.Im = 0.0 }
    init(i imaginary: Double) { self.Re = 0.0; self.Im = imaginary }
    init(_ real: Double, i imaginary: Double) {
        self.Re = real
        self.Im = imaginary
    }
    
    func normal() -> Double {
        return Re * Re + Im * Im
    }
    
    func asTuple() -> (real:Double, imaginary:Double) {
        return (Re, Im)
    }
}

typealias ℂ = ComplexNumber

func + (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a + c, i: b + d)
}
func * (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a*c - b*d, i:b*c + a*d)
}
