#if canImport(UIKit)
import UIKit
import CoreText

class iOSRenderingBackend: RenderingBackend {
    let gridView: TerminalGridView
    private var cells: [[Cell?]] = []
    private var columns: Int = 0
    private var lines: Int = 0

    init(gridView: TerminalGridView) {
        self.gridView = gridView
    }

    func updateGridSize(columns: Int, lines: Int) {
        self.columns = columns
        self.lines = lines
        cells = .init(repeating: .init(repeating: nil, count: columns), count: lines)
        gridView.cells = cells
        gridView.setNeedsDisplay()
    }

    func setup() {}

    func stop() {}

    func drawCell(_ cell: Cell, at position: Position) {
        let col = position.column.intValue
        let line = position.line.intValue
        guard line >= 0, line < lines, col >= 0, col < columns else { return }
        cells[line][col] = cell
        gridView.cells = cells

        let cellWidth = gridView.cellWidth
        let cellHeight = gridView.cellHeight
        let rect = CGRect(
            x: CGFloat(col) * cellWidth,
            y: CGFloat(line) * cellHeight,
            width: cellWidth,
            height: cellHeight
        )
        gridView.setNeedsDisplay(rect)
    }

    func flush() {
        // Partial invalidation was already done per-cell in drawCell
    }
}

class TerminalGridView: UIView {
    var cells: [[Cell?]] = []
    var font: UIFont = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)

    var cellWidth: CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = ("W" as NSString).size(withAttributes: attributes)
        return ceil(size.width)
    }

    var cellHeight: CGFloat {
        return ceil(font.lineHeight)
    }

    var terminalBackgroundColor: UIColor = .black {
        didSet {
            backgroundColor = terminalBackgroundColor
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        isOpaque = true
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        let cw = cellWidth
        let ch = cellHeight

        let minCol = max(0, Int(floor(rect.minX / cw)))
        let maxCol = min((cells.first?.count ?? 1) - 1, Int(floor(rect.maxX / cw)))
        let minLine = max(0, Int(floor(rect.minY / ch)))
        let maxLine = min(cells.count - 1, Int(floor(rect.maxY / ch)))

        guard minCol <= maxCol, minLine <= maxLine else { return }

        for line in minLine...maxLine {
            for col in minCol...maxCol {
                let cellRect = CGRect(x: CGFloat(col) * cw, y: CGFloat(line) * ch, width: cw, height: ch)

                guard let cell = cells[line][col] else {
                    // Draw terminal background for empty cells
                    ctx.setFillColor(terminalBackgroundColor.cgColor)
                    ctx.fill(cellRect)
                    continue
                }

                var fgColor = cell.foregroundColor.uiColor
                var bgColor: UIColor
                if let cellBg = cell.backgroundColor, cellBg != .default {
                    bgColor = cellBg.uiColor
                } else {
                    bgColor = terminalBackgroundColor
                }

                if cell.attributes.inverted {
                    swap(&fgColor, &bgColor)
                }

                // Draw background
                ctx.setFillColor(bgColor.cgColor)
                ctx.fill(cellRect)

                // Build font with traits
                var drawFont = font
                if cell.attributes.bold || cell.attributes.italic {
                    var traits: UIFontDescriptor.SymbolicTraits = []
                    if cell.attributes.bold { traits.insert(.traitBold) }
                    if cell.attributes.italic { traits.insert(.traitItalic) }
                    if let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                        drawFont = UIFont(descriptor: descriptor, size: font.pointSize)
                    }
                }

                // Build attributed string
                var attrs: [NSAttributedString.Key: Any] = [
                    .font: drawFont,
                    .foregroundColor: fgColor
                ]
                if cell.attributes.underline {
                    attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                if cell.attributes.strikethrough {
                    attrs[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
                }

                let charStr = String(cell.char)
                let attrString = CFAttributedStringCreate(
                    nil,
                    charStr as CFString,
                    attrs as CFDictionary
                )!
                let ctLine = CTLineCreateWithAttributedString(attrString)

                // Draw text
                ctx.saveGState()
                // CoreText uses a flipped coordinate system
                ctx.textMatrix = .identity
                ctx.translateBy(x: cellRect.minX, y: cellRect.maxY)
                ctx.scaleBy(x: 1.0, y: -1.0)

                let descent = CTFontGetDescent(drawFont as CTFont)
                ctx.textPosition = CGPoint(x: 0, y: descent)
                CTLineDraw(ctLine, ctx)
                ctx.restoreGState()
            }
        }
    }
}
#endif
