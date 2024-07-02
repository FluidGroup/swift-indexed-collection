# IndexedCollection

A wrapper collection that provides items with its index using underlying collection without allocation.

## Motivation

In SwiftUI, we might use these following technique for using index in `ForEach`.

```swift
ForEach(Array(array.enumerated()), id: \.offset) { ... }
```

```swift
ForEach(zip(array.indices, array), id: \.0) { ... } 
```

There is downside like followings:
- Creating new buffer by making new collection
- `enumerated` provides index from 0 so that makes wrong access on using slice.

## Usage

```swift
#Preview {
  VStack {
    ForEach.init(IndexedCollection([1, 2, 3, 4, 5]), id: \.index, content: { e in
      Text("\(e.index): \(e.value)")
    })
  }
}
```

```swift
struct IdentifiableItem: Identifiable {
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
```
