import SwiftUI

public struct IndexedForEach<Element, Content>: View where Content: View {
  
  let data: Array<Element>
  
  let content: (Array<Element>.Index, Element) -> Content
  
  public init(data: Array<Element>, @ViewBuilder content: @escaping (Array<Element>.Index, Element) -> Content) {
    self.data = data
    self.content = content
  }
  
  public var body: some View {
    ForEach(IndexedArray.init(base: data), id: \.0) { e in
      content(e.0, e.1)
    }
  }
  
}

struct IndexedArray<SourceElement>: RandomAccessCollection {
  
  typealias Iterator = IndexingIterator<Self>
  
  typealias Element = (Index, Array<SourceElement>.Element)
  
  typealias Index = Array<SourceElement>.Index
  
  typealias SubSequence = ArraySlice<Element>
  
  typealias Indices = Array<SourceElement>.Indices
  
  var base: [SourceElement]
  
  var indices: Array<SourceElement>.Indices { base.indices }
  
  var startIndex: Array<SourceElement>.Index { base.startIndex }
  
  var endIndex: Array<SourceElement>.Index { base.endIndex }
  
  init(base: consuming [SourceElement]) {
    self.base = base
  }
  
  func index(before i: Index) -> Index {
    base.index(before: i)
  }
  
  func index(after i: Index) -> Index {
    base.index(after: i)
  }
  
  subscript(bounds: Range<Index>) -> SubSequence {
    
    // TODO: This is not efficient
    
    var slice: [Element] = []
    
    for index in bounds {
      slice.append((index, base[index]))
    }
    
    return .init(slice)
  }
  
  subscript(position: Index) -> Element {
    return (position, base[position])
  }
  
}

#Preview {
  VStack {
    IndexedForEach(data: [1, 2, 3]) { index, element in
      Text("\(index): \(element)")
    }
  }
}
