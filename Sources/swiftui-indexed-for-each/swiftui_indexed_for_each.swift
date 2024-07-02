import SwiftUI

public struct IndexedForEach<Base: RandomAccessCollection, ID: Hashable, Content: View>: View {

//  public struct Index {
//    public let value: Int
//
//    public var isFirst: Bool {
//      value == 0
//    }
//
//    public var isLast: Bool {
//      value + 1 == count
//    }
//
//    internal let count: Int
//
//    internal init(value: Int, count: Int) {
//      self.value = value
//      self.count = count
//    }
//  }

  public typealias Index = Int

  private let data: Base
  private let content: (Index, Base.Element) -> Content
  private let id: KeyPath<IndexedArray.Element, ID>

  public init(
    _ data: Base,
    @ViewBuilder content: @escaping (Index, Base.Element) -> Content
  ) where Base.Element: Identifiable, ID == Base.Element.ID {

    self.data = data
    self.content = content
    self.id = \.value.id
  }

  public init(
    _ data: Base,
    id: KeyPath<Base.Element, ID>,
    @ViewBuilder content: @escaping (Index, Base.Element) -> Content
  ) where ID: Hashable {
    self.data = data
    self.id = (\IndexedArray.Element.value).appending(path: id)
    self.content = content
  }
  
  public var body: some View {
//    let count = data.count
    ForEach(IndexedArray(data), id: id) {
      content($0.index, $0.value)
//      content(.init(value: $0.index, count: count), $0.value)
    }
  }


  @usableFromInline
  struct IndexedArray: RandomAccessCollection {

    @usableFromInline
    let base: Base

    @usableFromInline
    let _indices: [Base.Index]

    @inlinable
    init(_ base: Base) {
      self.base = base
      self._indices = .init(base.indices)
    }

    // MARK: Collection

    @usableFromInline
    typealias Iterator = IndexingIterator<Self>

    @usableFromInline
    struct Element {

      @usableFromInline
      let index: Int

      @usableFromInline
      let value: Base.Element

      @inlinable
      init(index: Int, value: Base.Element) {
        self.index = index
        self.value = value
      }
    }

    @inlinable
    func index(before i: Int) -> Int {
      _indices.index(before: i)
    }

    @inlinable
    func index(after i: Int) -> Int {
      _indices.index(after: i)
    }

    // MARK: RandomAccessCollection

    @usableFromInline
    var startIndex: Int {
      _indices.startIndex
    }

    @usableFromInline
    var endIndex: Int {
      _indices.endIndex
    }

    @inlinable
    var indices: Range<Int> {
      _indices.indices
    }

    @inlinable
    subscript(bounds: Range<Int>) -> Slice<Self> {
      .init(base: self, bounds: bounds)
    }

    @inlinable
    subscript(position: Int) -> Element {
      .init(
        index: position,
        value: base[_indices[position]]
      )
    }
  }
}

#if DEBUG

struct Item: Identifiable {
  let id: String
}

#Preview {
  VStack {
    IndexedForEach([1, 2, 3, 4, 5], id: \.self) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#Preview {
  VStack {
    IndexedForEach([1, 2, 3, 4, 5][2...3], id: \.self) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#Preview { 
  VStack {
    IndexedForEach.init(["a", "b", "c", "d", "e"].map(Item.init(id:))) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#Preview {
  VStack {
    IndexedForEach.init(["a", "b", "c", "d", "e"].map(Item.init(id:))[2...3]) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#endif
