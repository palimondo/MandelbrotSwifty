extension Sequence {
    func _length() -> Int {
        return reduce(0, {$0.0 + 1})
    }
    
    func last() -> Iterator.Element?
    {
        var i = makeIterator()
        guard var lastOne = i.next() else {
            return nil
        }
        while let element = i.next() {
            lastOne = element
        }
        return lastOne
    }
    
    func _last() -> Iterator.Element? {
        var i = makeIterator()
        guard let first = i.next() else {return nil}
        return reduce(first, {$1})
    }
}
