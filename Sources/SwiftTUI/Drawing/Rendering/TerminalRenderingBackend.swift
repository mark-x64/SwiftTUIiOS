#if !os(iOS)
import Foundation

class TerminalRenderingBackend: RenderingBackend {
    private var currentPosition: Position = .zero
    private var currentForegroundColor: Color? = nil
    private var currentBackgroundColor: Color? = nil
    private var currentAttributes = CellAttributes()

    func setup() {
        write(EscapeSequence.enableAlternateBuffer)
        write(EscapeSequence.clearScreen)
        write(EscapeSequence.moveTo(currentPosition))
        write(EscapeSequence.hideCursor)
    }

    func stop() {
        write(EscapeSequence.disableAlternateBuffer)
        write(EscapeSequence.showCursor)
    }

    func drawCell(_ cell: Cell, at position: Position) {
        if self.currentPosition != position {
            write(EscapeSequence.moveTo(position))
            self.currentPosition = position
        }
        if self.currentForegroundColor != cell.foregroundColor {
            write(cell.foregroundColor.foregroundEscapeSequence)
            self.currentForegroundColor = cell.foregroundColor
        }
        let backgroundColor = cell.backgroundColor ?? .default
        if self.currentBackgroundColor != backgroundColor {
            write(backgroundColor.backgroundEscapeSequence)
            self.currentBackgroundColor = backgroundColor
        }
        self.updateAttributes(cell.attributes)
        write(String(cell.char))
        self.currentPosition.column += 1
    }

    func flush() {
        // Terminal output is already flushed per write call
    }

    private func updateAttributes(_ attributes: CellAttributes) {
        if currentAttributes.bold != attributes.bold {
            if attributes.bold { write(EscapeSequence.enableBold) }
            else { write(EscapeSequence.disableBold) }
        }
        if currentAttributes.italic != attributes.italic {
            if attributes.italic { write(EscapeSequence.enableItalic) }
            else { write(EscapeSequence.disableItalic) }
        }
        if currentAttributes.underline != attributes.underline {
            if attributes.underline { write(EscapeSequence.enableUnderline) }
            else { write(EscapeSequence.disableUnderline) }
        }
        if currentAttributes.strikethrough != attributes.strikethrough {
            if attributes.strikethrough { write(EscapeSequence.enableStrikethrough) }
            else { write(EscapeSequence.disableStrikethrough) }
        }
        if currentAttributes.inverted != attributes.inverted {
            if attributes.inverted { write(EscapeSequence.enableInverted) }
            else { write(EscapeSequence.disableInverted) }
        }
        currentAttributes = attributes
    }

    private func write(_ str: String) {
        str.withCString { _ = Darwin.write(STDOUT_FILENO, $0, strlen($0)) }
    }
}
#endif
