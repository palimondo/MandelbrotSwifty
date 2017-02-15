import CoreGraphics

func curry<A, B, R>(_ f: @escaping (A, B) -> R) -> (A) -> (B) -> R {
    return { a in { b in f(a, b) } }
}

infix operator >>> : MultiplicationPrecedence // associativity: left
func >>> <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

public struct ComplexNumber : CustomStringConvertible {
    let Re: Double
    let Im: Double
    
    init() { self.Re = 0.0; self.Im = 0.0 }
    init(_ real: Double) { self.Re = real; self.Im = 0.0 }
    init(_ real: Double, i imaginary: Double) { self.Re = real; self.Im = imaginary }
    
    func normal() -> Double { return Re * Re + Im * Im }
    public var description: String {return "\(Re) \(Im)i" }
}
/*
public typealias ℂ = ComplexNumber
func + (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a + c, i: b + d)
}
func * (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a*c - b*d, i: b*c + a*d)
 }
 */
public typealias ℂ = CGPoint
func + (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.x, x.y), (y.x, y.y))
    return ℂ(x:a + c, y: b + d)
}
func * (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.x, x.y), (y.x, y.y))
    return ℂ(x:a*c - b*d, y: b*c + a*d)
}
extension CGPoint : CustomStringConvertible {
    init(_ real: Double){ self.init(x: real, y:0.0) }
    func normal() -> Double { return Double(x * x) + Double(y * y) }
    public var description: String {return "\(x) \(y)i" }
}


extension Sequence {
    // Not to spec: missing throwing, noescape
    public func prefix (
        while predicate: @escaping (Self.Iterator.Element) -> Bool) -> 
        UnfoldSequence<Self.Iterator.Element, Self.Iterator> {
            return sequence(state: makeIterator(), next: {
                (myState: inout Iterator) -> Iterator.Element? in
                guard let next = myState.next() else { return nil }
                return predicate(next) ? next : nil
            })
    }
}

let b = CGPoint(x:2.0, y:2.5)

let quadrat: (ℂ, ℂ) -> ℂ = { c, z in z*z + c }
let C = ℂ(x:0.5, y:0.5)
let z0 = ℂ(0)
let z1 = quadrat(C, z0)
let z2 = quadrat(C, z1)
let z3 = quadrat(C, z2)
let z4 = quadrat(C, z3)

func quad(c: ℂ, z: ℂ) -> ℂ { return z*z + c}
let orbit: (ℂ) -> AnyIterator<ℂ> = { c in AnyIterator(sequence(first: ℂ(0), next: curry(quad)(c)))}
var q: ℂ
for z in orbit(C).prefix(10) {
    q = z
}
[orbit(C).prefix(10).map({$0})]

let maxIter = 15 // asciiGradient.lenght - 1
let _iterations: (AnyIterator<ℂ>) -> Int = { seq in
    seq.prefix(maxIter).prefix(while: {z in z.normal() < 2}).reduce(0, {$0.0 + 1})
}
let side: (Int, Double, Double) -> StrideTo<Double> = {size, start, end in
    stride(from: start, to: end, by: (end-start)/Double(size))
}
let w = 32
let h = 16

let sideX = side(w, -2, 2)
let sideY = side(h, -2, 2)

//let asciiGradient = Array(" .,:;|!([$O0*%#@".characters)
let asciiGradient = Array(" ⬜️1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟🔢#️⃣*️⃣⬛️".characters)
let toAscii: (Int) -> Character = { n in asciiGradient[n]}

let grid = sideY.map({ y in sideX.map({ x in ℂ(x:x, y:y) }) })
let art = grid.map {
    String($0.map(toAscii >>> _iterations >>> orbit))
    }.joined(separator: "\n")
art
/*
let art = grid.map {
    $0.map(toAscii >>> iterations >>> orbit)
        .reduce("", { $0 + String($1) })
    }.reduce("", {$0 + "\n" + $1}) // combinatorial explosion on compiler solving constraints for type inferrence
 */
