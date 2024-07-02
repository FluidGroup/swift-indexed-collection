import SwiftUI

public struct IndexedForEach<Base: RandomAccessCollection, ID: Hashable, Content: View>: View {

  public typealias Index = Base.Index

  private let data: Base
  private let content: (Index, Base.Element) -> Content
  private let id: KeyPath<IndexedArray<Base>.Element, ID>

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
    self.id = (\IndexedArray<Base>.Element.value).appending(path: id)
    self.content = content
  }
  
  public var body: some View {
    ForEach(IndexedArray(data), id: id) {
      content($0.index, $0.value)
    }
  }
}


public struct IndexedArray<Base: RandomAccessCollection>: RandomAccessCollection {

  @usableFromInline
  let base: Base

  @inlinable
  init(_ base: Base) {
    self.base = base
    self.indices = base.indices
  }

  // MARK: Collection

  public struct Element {

    public let index: Base.Index

    public let value: Base.Element

    @inlinable
    init(index: Base.Index, value: Base.Element) {
      self.index = index
      self.value = value
    }
  }

  @inlinable
  public func index(before i: Base.Index) -> Base.Index {
    indices.index(before: i)
  }

  @inlinable
  public func index(after i: Base.Index) -> Base.Index {
    indices.index(after: i)
  }

  // MARK: RandomAccessCollection

  public var startIndex: Base.Index {
    indices.startIndex
  }

  public var endIndex: Base.Index {
    indices.endIndex
  }

  public let indices: Base.Indices

  @inlinable
  public subscript(bounds: Range<Base.Index>) -> Slice<Self> {
    .init(base: self, bounds: bounds)
  }

  @inlinable
  public subscript(position: Base.Index) -> Element {
    return .init(
      index: indices[position],
      value: base[position]
    )
  }
}

extension IndexedArray.Element: Identifiable where Base.Element: Identifiable {

  public var id: Base.Element.ID {
    self.value.id
  }
}


#if DEBUG

struct Item: Identifiable {
  let id: String
  let value: UUID = .init()
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
    IndexedForEach.init(["a", "b", "c", "d", "e"].map(Item.init(id:))) { index, element in
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
    IndexedForEach(
      ["a", "b", "c", "d", "e"].map(Item.init(id:))[2...3]
    ) { index, element in
      Text("\(index): \(element)")
    }
  }
}

#Preview {
  let _ = print(
    IndexedArray(
      ["a", "b", "c", "d", "d", "e"].map(Item.init(id:))[2...4]
    )
  )
  VStack {
    IndexedForEach(
      IndexedArray(
        ["a", "b", "c", "d", "d", "e"].map(Item.init(id:))[2...4]
      )
    ) { (index, element) in
      Text("index: \(index), id: \(element.id), value: \(element.value)")
    }
  }
}

#endif
