
/**
 A wrapper collection that provides items with its index using underlying collection.
 */
public struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {

  @usableFromInline
  let base: Base

  @inlinable
  public init(_ base: Base) {
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

extension IndexedCollection.Element: Identifiable where Base.Element: Identifiable {

  public var id: Base.Element.ID {
    self.value.id
  }
}

#if canImport(SwiftUI)
import SwiftUI

#Preview {
  VStack {
    ForEach.init(IndexedCollection([1, 2, 3, 4, 5]), id: \.index, content: { e in
      Text("\(e.index): \(e.value)")
    })
  }
}

private struct IdentifiableItem: Identifiable {
  let id: String
  let value: UUID = .init()
}

#Preview {
  VStack {
    ForEach.init(IndexedCollection(["a", "b", "c", "d", "e"].map(IdentifiableItem.init(id:))), content: { e in
      Text("\(e.index): \(e.value)")
    })
  }
}

#endif
