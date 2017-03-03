// How many core Iterators/Sequences can be implemented as UnfoldSequence? At what performance costs?

let xs = ["a", "b", "c"]
let ys = stride(from: 4, through: 1, by: -1)
let zs: Array<Int> = []
Array(ys)

// ripped-off from _ClosureBasedIterator
public struct _AnyIterator<Element> : IteratorProtocol, Sequence {
    let _next: () -> Element?
    var done = false
    public init(_ next: @escaping () -> Element?) {
        _next = next
    }
    public mutating func next() -> Element? {
        guard !done else { return nil }
        if let nextElement = _next() {
            return nextElement
        } else {
            done = true
            return nil
        }
    }
}

// ripped-off from _ClosureBasedSequence
public struct _AnySequence<Iterator: IteratorProtocol> : Sequence {
    let _makeIterator: () -> Iterator
//    var _makeIterator: () -> Iterator
    public init(_ makeIterator: @escaping () -> Iterator) {
        self._makeIterator = makeIterator
    }
    public func makeIterator() -> Iterator {
        return _makeIterator()
    }
}

 // Enumerator (EnumeratedSequence)
 xs.enumerated()
 let e = Array(xs.enumerated())
 e[1].offset
 e[1].element
 
extension Sequence {
    
    public func _enumerated() -> _AnyIterator<(Int, Iterator.Element)> {
        var count = 0
        var iterator = makeIterator()
        
        return _AnyIterator {
            guard let element = iterator.next() else { return nil }
            defer { count += 1 }
            return (count, element)
        }
    }
}
xs._enumerated()
let ee = Array(xs._enumerated())



// Drop First

Array(ys.dropFirst(2))

extension Sequence {
    
    public func _dropFirst(_ n: Int) -> _AnyIterator<Iterator.Element> {
            var count = n
            var iterator = makeIterator()
            
            return _AnyIterator {
                while count > 0 {
                    if iterator.next() == nil {
                        return nil
                    }
                    count -= 1
                }
                return iterator.next()
            }
    }
}
Array(ys._dropFirst(2))
Array(zs._dropFirst(2))

// TODO ??
// Drop Last (Lazy)
// Suffix


// Drop While

//let dw = ys.drop(while: {$0 > 2})
//dw

extension Sequence {
    
    public func _drop(while predicate: @escaping (Iterator.Element) -> Bool) -> _AnyIterator<Iterator.Element> {
        var predicateHasFailed = false
        var iterator = makeIterator()
        
        return _AnyIterator {
            guard predicateHasFailed else {
                while let nextElement = iterator.next() {
                    guard predicate(nextElement) else {
                        predicateHasFailed = true
                        return nextElement
                    }
                }
                return nil // exhausted underlying sequence
            }
            return iterator.next()
        }
    }
}

let ddw = ys._drop(while: {$0 > 2})
Array(ddw)

 // Zip (Zip2Sequence)
let z = zip(xs, ys)
Array(zip(xs, ys))
Array(zip(xs, zs))

public func _zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> _AnyIterator<(S1.Iterator.Element, S2.Iterator.Element)> {
    var i1 = s1.makeIterator()
    var i2 = s2.makeIterator()
    return _AnyIterator {
        guard let e1 = i1.next(), let e2 = i2.next()
            else { return nil }
        return (e1, e2)
    }
}

let zz = _zip(xs, ys)
Array(_zip(xs, ys))
Array(_zip(xs, zs))


 // Prefix
let p = ys.prefix(2)
Array(p)

extension Sequence {
    
    public func _prefix(_ maxLength: Int) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            var count = maxLength // count = 0
            
//            return _AnyIterator {
//                defer { count -= 1 } //  { count += 1 }
//                return (count > 0) ? iterator.next() : nil // (count < maxLength) ? iterator.next() : nil
//            }
            return _AnyIterator {
                count -= 1
                return (0 <= count) ? iterator.next() : nil
            }
    }
}

ys._prefix(2)
let pp = Array(ys._prefix(2))
Array(zs._prefix(2))


 // Prefix While (PrefixWhileSequence)
 
extension Sequence {
    public typealias Predicate = (Iterator.Element) -> Bool
    
    public func _prefix (while predicate: @escaping Predicate) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            return _AnyIterator {
                guard let e = iterator.next() else { return nil }
                return predicate(e) ? e : nil
            }
    }
    
}

let pw = Array(ys._prefix(while: {$0 > 2}))
pw

// Stride ??
