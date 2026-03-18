import Foundation

public struct STGroup<Content: STView>: STView, PrimitiveView {
    public let content: Content

    public init(@STViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

}
