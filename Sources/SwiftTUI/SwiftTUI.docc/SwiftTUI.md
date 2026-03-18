# ``SwiftTUI``

SwiftUI for terminal applications, also embeddable in iOS apps.

## Documentation

This generated documentation can serve as a reference for the currently supported functionality. Also check out `README.md` and the included example projects.

## Getting started

### Terminal (macOS / Linux)

Create an executable type Swift package and add SwiftTUI as a dependency. Use the `main` branch to use the latest functions. Import SwiftTUI in your files, and write your views like you're used to in SwiftUI, using the supported views and modifiers. On macOS, backward-compatible typealiases (e.g. `View`, `Text`, `VStack`) are available.

```swift
import SwiftTUI

struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!")
  }
}
```

Add the following to `main.swift` to start the terminal application using one of your views as the root view.

```swift
Application(
  rootView: MyTerminalView()
)
.start()
```

To run the app, open a terminal emulator such as macOS's Terminal app, change to your package's directory and run

```bash
swift run
```

### iOS

On iOS, use the `ST`-prefixed type names (e.g. `STView`, `STText`, `STVStack`) to avoid conflicts with SwiftUI. Import `SwiftTUIiOS` and use `TerminalView` to embed a terminal-style character grid in your SwiftUI app:

```swift
import SwiftUI
import SwiftTUIiOS

struct ContentView: SwiftUI.View {
    var body: some SwiftUI.View {
        TerminalView {
            STVStack {
                STText("Hello from TUI!")
                    .foregroundColor(.green)
            }
        }
    }
}
```

## Topics

### Application

- ``Application``

### View

- ``STView``
- ``STViewBuilder``
- ``STGroup``
- ``STForEach``
- ``STEmptyView``

### Layout

- ``STVStack``
- ``STHStack``
- ``STZStack``
- ``STSpacer``
- ``STDivider``
- ``STView/frame(width:height:alignment:)``
- ``STView/frame(minWidth:maxWidth:minHeight:maxHeight:alignment:)``
- ``STView/padding(_:)``
- ``STView/padding(_:_:)``
- ``STGeometryReader``
- ``STAlignment``
- ``STHorizontalAlignment``
- ``STVerticalAlignment``
- ``Edges``
- ``Extended``
- ``Size``

### Style

- ``STColor``
- ``STView/foregroundColor(_:)``
- ``STView/background(_:)``
- ``STView/border(_:style:)``
- ``BorderStyle``
- ``DividerStyle``

### Text

- ``STText``
- ``STView/bold(_:)``
- ``STView/italic(_:)``
- ``STView/strikethrough(_:)``
- ``STView/underline(_:)``

### Controls

- ``STScrollView``
- ``STButton``
- ``STTextField``
- ``STEnvironmentValues/placeholderColor``

### View lifecycle

- ``STView/onAppear(_:)``

### Property wrappers

- ``STState``
- ``STBinding``
- ``STObservedObject``
- ``STEnvironment``
- ``STView/environment(_:_:)``
- ``STEnvironmentKey``
- ``STEnvironmentValues``

### Debugging

- ``log(_:terminator:)``
