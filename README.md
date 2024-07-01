# IndexedForEach

## Motivation
The purpose of using IndexedForEach is to read array's element and its index in safe way.  
As using `.enumerated()` is unsafe way because of the index does not always start from 0.

## Usage

```
import SwiftUI

struct ContentView: View {
    let numbers = [1, 2, 3]
    
    var body: some View {
        VStack {
            IndexedForEach(numbers) { index, element in
                Text("\(index): \(element)")
            }
        }
    }
}
```
