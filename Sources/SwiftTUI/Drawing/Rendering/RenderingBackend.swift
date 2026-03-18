import Foundation

protocol RenderingBackend: AnyObject {
    func setup()
    func stop()
    func drawCell(_ cell: Cell, at position: Position)
    func flush()
}
