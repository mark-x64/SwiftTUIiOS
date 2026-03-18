# SwiftTUI

> **Fork notice:** This is a fork of [rensbreur/SwiftTUI](https://github.com/rensbreur/SwiftTUI) with added iOS support. The original project is created by [Rens Breur](https://github.com/rensbreur) and licensed under the [MIT License](LICENSE).

![swift 5.6](https://user-images.githubusercontent.com/13484323/184016525-cb42a72c-1e2e-4d8d-8777-e7481386377c.svg)
![platform ios](https://img.shields.io/badge/platform-iOS%2015%2B-blue.svg)

An innovative, exceptionally simple way to build text-based SwiftUI View.

SwiftTUI brings SwiftUI to the terminal. It provides an API similar to SwiftUI to build terminal applications with a text-based user interface.

![](screenshot.png)

### Getting started

#### Terminal (macOS / Linux) -> Use original repository

#### iOS (Embedded TUI View)

SwiftTUI can also be used on iOS to embed a terminal-style character grid inside a SwiftUI app. All SwiftTUI types use the `ST` prefix (e.g. `STView`, `STText`, `STVStack`) to avoid conflicts with SwiftUI.

Add both `SwiftTUI` and `SwiftTUIiOS` as dependencies. Use `TerminalView` to embed SwiftTUI content:

```swift
import SwiftUI
import SwiftTUIiOS

struct ContentView: SwiftUI.View {
    var body: some SwiftUI.View {
        VStack {
            Text("My iOS App")

            TerminalView(backgroundColor: .black) {
                STVStack {
                    STText("Hello from TUI!")
                        .foregroundColor(.green)
                        .bold()
                    STButton("Tap me") {
                        print("Tapped!")
                    }
                }
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
```

For more, and to see the supported functionality, check out the [documentation](https://rensbreur.github.io/SwiftTUI/documentation/swifttui/).

### Type naming

All public types use an `ST` prefix as their canonical name (e.g. `STView`, `STVStack`, `STText`, `STColor`). On macOS/Linux, backward-compatible typealiases without the prefix (e.g. `View`, `VStack`, `Text`) are also provided. On iOS/tvOS, these typealiases are internal to avoid conflicts with SwiftUI.

| ST-prefixed (canonical) | macOS typealias | iOS |
|---|---|---|
| `STView` | `View` | Use `STView` |
| `STVStack` | `VStack` | Use `STVStack` |
| `STText` | `Text` | Use `STText` |
| `STColor` | `Color` | Use `STColor` |
| `STState` | `State` | Use `STState` |
| ... | ... | ... |

### Documentation

You can find generated documentation [here](https://rensbreur.github.io/SwiftTUI/documentation/swifttui/).

### Acknowledgements

This project is a fork of [SwiftTUI](https://github.com/rensbreur/SwiftTUI) by [Rens Breur](https://github.com/rensbreur). The iOS adaptation adds a rendering backend (CoreText), an iOS application lifecycle manager, and a `TerminalView` SwiftUI wrapper, while keeping the original view graph, layout engine, and state management intact.

### License

This project is licensed under the [MIT License](LICENSE), the same license as the original SwiftTUI project.
