func takeWhile<S : Sequence>(_ includeElement: @escaping (S.Iterator.Element) -> Bool, source: S) -> AnyIterator<S.Iterator.Element> {
    var takeMore = true
    var g = source.makeIterator()
    
    return AnyIterator {
        if takeMore {
            if let e = g.next() {
                takeMore = includeElement(e)
                return takeMore ? e : .none
            }
        }
        return .none
    }
}

func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
    var i = 0
    var g = source.makeIterator()
    
    return AnyIterator {
        defer { i += 1 }
        return (i < count) ? g.next() : .none
    }
}

@_specialize(Int)
func iterate<A>(_ f: @escaping (A) -> A, x0: A) -> AnyIterator<A> {
    var x = x0
    return AnyIterator {
        defer { x = f(x) }
        return x
    }
 }
 
func curry<A, B, R>(_ f: @escaping (A, B) -> R) -> (A) -> (B) -> R {
    return { a in { b in f(a, b) } }
}

func length<S: Sequence>(_ sequence: S) -> Int {
    return sequence.reduce(0, {i, _ in i + 1})
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
    init(i imaginary: Double) { self.Re = 0.0; self.Im = imaginary }
    init(_ real: Double, i imaginary: Double) { self.Re = real; self.Im = imaginary }
    
    func normal() -> Double { return Re * Re + Im * Im }
    public var description: String {return "\(Re) \(Im)i" }
    func asTuple() -> (real: Double, imaginary: Double) { return (Re, Im) }
}

public typealias ℂ = ComplexNumber
/*
func + (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a + c, i: b + d)
}
func * (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a*c - b*d, i: b*c + a*d)
 }
*/
public func +(l: ℂ, r: ℂ) -> ℂ { return ℂ(l.Re + r.Re, i:l.Im + r.Im) }
public func -(l: ℂ, r: ℂ) -> ℂ { return ℂ(l.Re - r.Re, i:l.Im - r.Im) }
public prefix func -(c: ℂ) -> ℂ { return ℂ( -c.Re, i:-c.Im) }
public func *(l: ℂ, r: ℂ) -> ℂ { return ℂ(l.Re * r.Re - l.Im * r.Im, i:l.Re * r.Im + r.Re * l.Im) }

let quadrat: (ℂ, ℂ) -> ℂ = { c, z in z*z + c }
let orbit: (ℂ) -> AnyIterator<ℂ> = { c in iterate(curry(quadrat)(c), x0: ℂ(0))}

[orbit(ℂ(1)).prefix(6)]
//let _orbit: (ℂ) -> UnfoldSequence<ℂ, (ℂ)->ℂ?> = { c in sequence(first: ℂ(0), next: curry(quadrat)(c))}

let maxIter = 15 // asciiGradient.lenght - 1
let iterations: (AnyIterator<ℂ>) -> Int = { seq in 
    length(takeWhile({z in z.normal() < 2}, source: take(maxIter, source: seq)))
}
let side: (Int, Double, Double) -> StrideTo<Double> = {size, start, end in
    stride(from: start, to: end, by: (end-start)/Double(size))
}
let w = 32
let h = 16

let sideX = side(w, -2, 2)
let sideY = side(h, -2, 2)

let asciiGradient = Array(" .,:;|!([$O0*%#@".characters)
let toAscii: (Int) -> Character = { n in asciiGradient[n]}

let grid = sideY.map({ y in sideX.map({ x in ℂ(x, i:y) }) })


/*
 let art = grid.map {
    $0.map(String.init(_:) >>> toAscii >>> iterations >>> orbit)
        .joined()
    }.joined(separator: "\n")
 */
