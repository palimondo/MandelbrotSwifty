let quadrat: (ℂ, ℂ) -> ℂ = {c, z in z*z + c}

let orbit: (ℂ) -> AnyIterator<ℂ> = {c in iterate(curry(quadrat)(c), x0: ℂ(0))}

let iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.isPotentiallyInSet()}, source: take(maxIter, source: seq)))
}
let _iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.isPotentiallyInSet()}, source: seq.prefix(maxIter)))
}
let __iterations: (AnyIterator<ℂ>) -> Int = {seq in
    seq.prefix(maxIter).lazy.prefix(while: {z in z.isPotentiallyInSet()}).reduce(0, {i, _ in i + 1})
}

//let _orbit = {z in sequence(first: ℂ(0), next: curry({c, z in z*z + c})(z))}
let _orbit = {c in AnyIterator(sequence(first: ℂ(0), next: curry({c, z in z*z + c})(c)))}

func quad(_ c: ℂ, _ z: ℂ) -> ℂ { return z*z + c }
let orbitFuncQuad = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quad)(c)))}
let orbitFuncQuadrat = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quadrat)(c)))}

func quadC(_ c: ℂ) -> (ℂ) -> ℂ { return {z in z*z + c}}
let orbitQuadClosure = {c in AnyIterator(sequence(first: ℂ(0), next: quadC(c)))}


let functional = [
    ("orbitFuncQuad                   ", __iterations >>> orbitFuncQuad),
    ("orbitFuncQuadrat                ", __iterations >>> orbitFuncQuadrat),
    ("orbitQuadClosure                ", __iterations >>> orbitQuadClosure),
    //    ("takeWhile take length iterate   ", iterations >>> orbit),
    //    ("takeWhile prefix length iterate ", _iterations >>> orbit),
    //    ("prefix prefix reduce iterate    ", __iterations >>> orbit),
    //    ("takeWhile take length sequence  ", iterations >>> _orbit),
    //    ("takeWhile prefix length sequence", _iterations >>> _orbit),
    ("prefix prefix reduce sequence   ", __iterations >>> _orbit)
]
