#if canImport(UIKit)
import UIKit

class iOSApplication: ViewGraphHost {
    let node: Node
    let window: Window
    let control: Control
    let renderer: Renderer
    let backend: iOSRenderingBackend

    private var invalidatedNodes: [Node] = []
    private var updateScheduled = false

    init<I: View>(rootView: I, gridView: TerminalGridView) {
        node = Node(view: VStack(content: rootView).view)
        node.build()

        control = node.control!

        window = Window()
        window.addControl(control)

        window.firstResponder = control.firstSelectableElement
        window.firstResponder?.becomeFirstResponder()

        backend = iOSRenderingBackend(gridView: gridView)
        renderer = Renderer(layer: window.layer, backend: backend)
        window.layer.renderer = renderer

        node.application = self
        renderer.application = self
    }

    func updateSize(_ cgSize: CGSize) {
        let gridView = backend.gridView
        let cellWidth = gridView.cellWidth
        let cellHeight = gridView.cellHeight

        guard cellWidth > 0, cellHeight > 0 else { return }

        let columns = max(1, Int(floor(cgSize.width / cellWidth)))
        let lines = max(1, Int(floor(cgSize.height / cellHeight)))

        window.layer.frame.size = Size(width: Extended(columns), height: Extended(lines))
        backend.updateGridSize(columns: columns, lines: lines)
        renderer.setCache()

        control.layout(size: window.layer.frame.size)
        renderer.draw()
    }

    func invalidateNode(_ node: Node) {
        invalidatedNodes.append(node)
        scheduleUpdate()
    }

    func scheduleUpdate() {
        if !updateScheduled {
            DispatchQueue.main.async { self.update() }
            updateScheduled = true
        }
    }

    private func update() {
        updateScheduled = false

        for node in invalidatedNodes {
            node.update(using: node.view)
        }
        invalidatedNodes = []

        control.layout(size: window.layer.frame.size)
        renderer.update()
    }

    // MARK: - Hit testing

    func hitTest(column: Int, line: Int) -> Control? {
        let position = Position(column: Extended(column), line: Extended(line))
        return hitTestControl(control, at: position, offset: .zero)
    }

    private func hitTestControl(_ control: Control, at position: Position, offset: Position) -> Control? {
        let frame = Rect(
            position: offset + control.layer.frame.position,
            size: control.layer.frame.size
        )
        guard frame.contains(position) else { return nil }

        let localOffset = offset + control.layer.frame.position
        for child in control.children.reversed() {
            if let hit = hitTestControl(child, at: position, offset: localOffset) {
                return hit
            }
        }

        if control.selectable {
            return control
        }
        return nil
    }
}
#endif
