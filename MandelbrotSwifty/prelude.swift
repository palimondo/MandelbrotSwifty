func takeWhile<S : Sequence>(_ includeElement: @escaping (S.Iterator.Element) -> Bool, source: S) ->  AnyIterator<S.Iterator.Element> {
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
        defer {i += 1;}
        return (i < count) ? g.next() : .none
    }
}

@_specialize(Int)
func iterate<A>(_ f: @escaping (A) -> A, x0: A) -> AnyIterator<A> {
    var x = x0
    return AnyIterator {
        defer {x = f(x)}
        return x
    }
}

func curry<A,B,R>(_ f: @escaping (A,B) -> R) -> (A) -> (B) -> R {
    return { a in { b in f(a,b) } }
}

func length<S: Sequence>(_ sequence: S) -> Int {
    return sequence.reduce(0, {i, _ in i + 1})
}

infix operator >>> : MultiplicationPrecedence // associativity: left
func >>> <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

