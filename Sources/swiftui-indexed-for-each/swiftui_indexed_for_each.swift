import SwiftUI

public struct IndexedForEach<Element, ID: Hashable, Content: View>: View {
  
  private let data: [Element]
  
  private let content: (Array<Element>.Index, Element) -> Content
  
  private let id: KeyPath<IndexedArray<Element>.Element, ID>
  
  public init(
    _ data: [Element],
    @ViewBuilder content: @escaping (Array<Element>.Index, Element) -> Content
  ) where Element: Identifiable, ID == Element.ID {
    
    self.data = data
    self.content = content
    self.id = \.1.id
  }
  
  public init(
    _ data: [Element],
    id: KeyPath<Element, ID>,
    @ViewBuilder content: @escaping (Array<Element>.Index, Element) -> Content
  ) where Data: RandomAccessCollection, ID: Hashable {
    self.data = data
    self.id = (\IndexedArray<Element>.Element.1).appending(path: id)
    self.content = content
  }
  
  public var body: some View {
    ForEach(IndexedArray.init(base: data), id: id) { e in
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

#if DEBUG

struct Item: Identifiable {
  let id: Int
}

#Preview {
  VStack {
    IndexedForEach([1, 2, 3], id: \.self) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#Preview { 
  VStack {
    IndexedForEach.init([Item(id: 0)]) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#endif
