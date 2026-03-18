# SwiftTUI

> **Fork notice:** This is a fork of [rensbreur/SwiftTUI](https://github.com/rensbreur/SwiftTUI) with added iOS support. The original project is created by [Rens Breur](https://github.com/rensbreur) and licensed under the [MIT License](LICENSE).

![swift 5.6](https://user-images.githubusercontent.com/13484323/184016525-cb42a72c-1e2e-4d8d-8777-e7481386377c.svg)
![platform macos](https://user-images.githubusercontent.com/13484323/184016156-817e14dc-24b5-4b46-a4d4-0de9391a37a4.svg)
![platform linux](https://user-images.githubusercontent.com/13484323/184016263-afa5dd0c-8d9a-4fba-91fe-23e892d64cca.svg)
![platform ios](https://img.shields.io/badge/platform-iOS%2015%2B-blue.svg)

An innovative, exceptionally simple way to build text-based user interfaces.

SwiftTUI brings SwiftUI to the terminal. It provides an API similar to SwiftUI to build terminal applications with a text-based user interface.

![](screenshot.png)

### What is working

Many features from SwiftUI are already working:

✓ Property wrappers `@STState`, `@STBinding`, `@STEnvironment` and `@STObservedObject`<br>
✓ Stacks, `.frame()`, `.padding()`, `STGeometryReader`, `@STViewBuilder`, `STForEach`, `STGroup`<br>
✓ Structural identity like in SwiftUI<br>
✓ Scrollable lists with `STScrollView`<br>
✓ `STButton`, `STTextField` and moving focus with the arrow keys<br>
✓ `STColor` with ANSI, xterm and TrueColor support<br>
✓ `STText` with bold, italic, underscore and strikethrough variants<br>
✓ `.onAppear()`, `.border()`, `.foregroundColor()`, `.background()`<br>
✓ Modifiers applied to all views in a collection like in SwiftUI

### Getting started

#### Terminal (macOS / Linux)

To use SwiftTUI in a terminal application, add the SwiftTUI package dependency. Import SwiftTUI in your files, and write your views like SwiftUI views with the supported features. On macOS, the original SwiftUI-style names (e.g. `View`, `Text`, `VStack`) are available as public typealiases. Then, start the terminal application using one of your views as the root view. This is the simplest SwiftTUI app you can write:

```swift
import SwiftTUI

struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!")
  }
}

Application(rootView: MyTerminalView()).start()
```

To run your app, change to your package's directory and run it from the terminal:

```
swift run
```

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

### Examples

These example projects are included in the repository.

#### ToDoList ([Examples/ToDoList](Examples/ToDoList))

![](Examples/ToDoList/screenshot.png)

This is a very simple to-do list application. Use the arrow keys to move around. To complete a to-do item, select it, and then press the enter key or space bar. To add a new to-do item, move to the text field, enter a description, and press the enter key to add it to the list. Completed items are automatically removed from the list after half a second.

#### Flags ([Examples/Flags](Examples/Flags))

![](Examples/Flags/screenshot.png)

This is a flag editor, which you will agree to if you come from a country which has a simple flag consisting of colors stacked horizontally or vertically. Select one of the colors of the flag to change it. Use the options on the right to change the number of colors or the flag orientation.

### Showcase

Are you working on a project that's using SwiftTUI? Get in touch with me if you'd like to have it featured here.

#### soundcld

![](https://github.com/rensbreur/SwiftTUI/assets/13484323/b585708c-3606-495e-a96e-3eba92f39916)

This is a TUI application for SoundCloud. It's not (yet) available publicly.

### More

See a screen recording of SwiftTUI [in action](https://www.reddit.com/r/SwiftUI/comments/wlabyn/im_making_a_version_of_swiftui_for_terminal/) on Reddit.

Learn how [the diffing works](https://rensbr.eu/blog/swiftui-diffing/) on my blog.

### Documentation

You can find generated documentation [here](https://rensbreur.github.io/SwiftTUI/documentation/swifttui/).

### Contributing

This is an open-source project, contributions are welcome! The goal of SwiftTUI is to resemble SwiftUI when it comes to both API and   inner workings, unless those don't make sense for terminal applications. Features that SwiftUI lacks but that would be useful for terminal applications might better live in a seperate project.

### Acknowledgements

This project is a fork of [SwiftTUI](https://github.com/rensbreur/SwiftTUI) by [Rens Breur](https://github.com/rensbreur). The iOS adaptation adds a rendering backend (CoreText), an iOS application lifecycle manager, and a `TerminalView` SwiftUI wrapper, while keeping the original view graph, layout engine, and state management intact.

### License

This project is licensed under the [MIT License](LICENSE), the same license as the original SwiftTUI project.
