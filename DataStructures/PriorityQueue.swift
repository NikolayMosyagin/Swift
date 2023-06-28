struct PriorityQueue<Element> {
    let priority: (Element, Element) -> Bool
    var items: [Element]

    init(priorityFunction: @escaping (Element, Element) -> Bool) {
        items = [Element]()
        self.priority = priorityFunction
    }

    func isEmpty() -> Bool {
        return items.count == 0
    }

    func peek() -> Element? {
        return items.count == 0 ? nil : items[0]
    }

    mutating func append(_ value: Element) {
        items.append(value)
        self.lift()
    }

    mutating func pop() -> Element {
        let result = items[0]
        let last = items.removeLast()
        if items.count > 0 {
            items[0] = last
            self.sift()
        }
        return result
    }

    mutating func lift() {
       var u = items.count - 1
       let item = items[u]
       while u > 0 {
           let v = self.getParentIndex(u)
           if self.priority(items[v], item) {
               break
           }
           items[u] = items[v]
           u = v
       } 
       items[u] = item
    }

    mutating func sift() {
        var u = 0
        var left = self.getFirstChildIndex(u)
        let count = items.count
        let item = items[0]
        while left < count {
            let right = left + 1
            let v = right < count && self.priority(items[right], items[left]) ? right : left
            if self.priority(item, items[v]) {
                break
            }
            items[u] = items[v]
            u = v;
            left = self.getFirstChildIndex(u)
        }  
        items[u] = item 
    }

    func getFirstChildIndex(_ index: Int) -> Int {
        return (index << 1) + 1
    }

    func getParentIndex(_ index: Int) -> Int {
        return (index - 1) >> 1
    }
}