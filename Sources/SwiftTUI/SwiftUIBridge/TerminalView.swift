#if canImport(UIKit)
import SwiftUI
import UIKit

/// A SwiftUI view that embeds a SwiftTUI terminal-style view.
///
/// Use ST-prefixed types inside the closure to avoid conflicts with SwiftUI:
///
/// ```swift
/// TerminalView {
///     STVStack {
///         STText("Hello from TUI!")
///             .foregroundColor(.green)
///             .bold()
///         STButton("Tap me") { print("Tapped!") }
///     }
/// }
/// ```
public struct TerminalView<Content: STView>: UIViewRepresentable {
    let content: Content
    let font: UIFont?
    let terminalBackgroundColor: UIColor

    public init(
        font: UIFont? = nil,
        backgroundColor: UIColor = .black,
        @STViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.font = font
        self.terminalBackgroundColor = backgroundColor
    }

    public func makeUIView(context: Context) -> TerminalContainerView {
        let container = TerminalContainerView()
        if let font = font {
            container.gridView.font = font
        }
        container.gridView.terminalBackgroundColor = terminalBackgroundColor
        container.setupApplication(content: content)
        return container
    }

    public func updateUIView(_ uiView: TerminalContainerView, context: Context) {
        // Content is built once; state changes are handled by SwiftTUI's own reactivity
    }
}

public class TerminalContainerView: UIView, UIKeyInput {

    let gridView = TerminalGridView(frame: .zero)
    var application: iOSApplication?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gridView)
        clipsToBounds = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupApplication<I: STView>(content: I) {
        application = iOSApplication(rootView: content, gridView: gridView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gridView.frame = bounds
        application?.updateSize(bounds.size)
    }

    // MARK: - Touch handling

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gridView)
        let col = Int(floor(point.x / gridView.cellWidth))
        let line = Int(floor(point.y / gridView.cellHeight))

        guard let app = application else { return }

        if let hitControl = app.hitTest(column: col, line: line) {
            // Change focus
            app.window.firstResponder?.resignFirstResponder()
            app.window.firstResponder = hitControl
            hitControl.becomeFirstResponder()

            // Activate (simulate Enter for buttons)
            hitControl.handleEvent("\n")
        }

        // Show keyboard if a text field is focused
        if !isFirstResponder {
            becomeFirstResponder()
        }
    }

    // MARK: - UIKeyInput

    public var hasText: Bool { true }

    public func insertText(_ text: String) {
        for char in text {
            application?.window.firstResponder?.handleEvent(char)
        }
    }

    public func deleteBackward() {
        application?.window.firstResponder?.handleEvent(ASCII.DEL)
    }

    public override var canBecomeFirstResponder: Bool { true }
}
#endif
