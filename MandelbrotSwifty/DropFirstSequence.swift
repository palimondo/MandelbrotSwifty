// Drop First

let d = ys.dropFirst(2)

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            return sequence(state: (n, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> Iterator.Element? in
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count -= 1
                }
                return state.iterator.next()
            })
    }
    
    public func __dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            func dropNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count = state.count &- 1
                }
                return state.iterator.next()
            }
            return sequence(state: (n, makeIterator()), next: dropNext)
    }
}
let dd = ys._dropFirst(2)
let ddd = ys.__dropFirst(2)
