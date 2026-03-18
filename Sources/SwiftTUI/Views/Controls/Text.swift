import Foundation

public struct STText: STView, PrimitiveView {
    private var text: String?

    private var _attributedText: Any?

    @available(macOS 12, iOS 15, *)
    private var attributedText: AttributedString? { _attributedText as? AttributedString }

    @Environment(\.foregroundColor) private var foregroundColor: Color
    @Environment(\.bold) private var bold: Bool
    @Environment(\.italic) private var italic: Bool
    @Environment(\.underline) private var underline: Bool
    @Environment(\.strikethrough) private var strikethrough: Bool

    public init(_ text: String) {
        self.text = text
    }

    @available(macOS 12, iOS 15, *)
    public init(_ attributedText: AttributedString) {
        self._attributedText = attributedText
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.control = TextControl(
            text: text,
            attributedText: _attributedText,
            foregroundColor: foregroundColor,
            bold: bold,
            italic: italic,
            underline: underline,
            strikethrough: strikethrough
        )
    }

    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.view = self
        let control = node.control as! TextControl
        control.text = text
        control._attributedText = _attributedText
        control.foregroundColor = foregroundColor
        control.bold = bold
        control.italic = italic
        control.underline = underline
        control.strikethrough = strikethrough
        control.invalidateWrapping()
        control.layer.invalidate()
    }

    private class TextControl: Control {
        var text: String?

        var _attributedText: Any?

        @available(macOS 12, iOS 15, *)
        var attributedText: AttributedString? { _attributedText as? AttributedString }

        var foregroundColor: Color
        var bold: Bool
        var italic: Bool
        var underline: Bool
        var strikethrough: Bool

        // Cached wrapping state
        private var cachedLines: [WrappedLine] = []
        private var cachedWidth: Int?

        struct WrappedLine {
            let startOffset: Int  // character offset in original text
            let text: String      // rendered line content
        }

        init(
            text: String?,
            attributedText: Any?,
            foregroundColor: Color,
            bold: Bool,
            italic: Bool,
            underline: Bool,
            strikethrough: Bool
        ) {
            self.text = text
            self._attributedText = attributedText
            self.foregroundColor = foregroundColor
            self.bold = bold
            self.italic = italic
            self.underline = underline
            self.strikethrough = strikethrough
        }

        func invalidateWrapping() {
            cachedWidth = nil
            cachedLines = []
        }

        override func size(proposedSize: Size) -> Size {
            let width: Int
            if proposedSize.width == .infinity || proposedSize.width < 1 {
                width = max(characterCount, 1)
            } else {
                width = proposedSize.width.intValue
            }

            let lines = wrappedLines(forWidth: width)
            let maxLineWidth = lines.map(\.text.count).max() ?? 0
            return Size(width: Extended(maxLineWidth), height: Extended(lines.count))
        }

        override func layout(size: Size) {
            super.layout(size: size)
            let width: Int
            if size.width == .infinity || size.width < 1 {
                width = max(characterCount, 1)
            } else {
                width = size.width.intValue
            }
            _ = wrappedLines(forWidth: width)
        }

        override func cell(at position: Position) -> Cell? {
            let line = position.line.intValue
            guard line >= 0, line < cachedLines.count else { return nil }
            let wrappedLine = cachedLines[line]
            let col = position.column.intValue
            guard col >= 0, col < wrappedLine.text.count else { return nil }

            let originalIndex = wrappedLine.startOffset + col

            if #available(macOS 12, iOS 15, *), let attributedText {
                let characters = attributedText.characters
                guard originalIndex < characters.count else { return nil }
                let i = characters.index(characters.startIndex, offsetBy: originalIndex)
                let char = attributedText[i ..< characters.index(after: i)]
                let cellAttributes = CellAttributes(
                    bold: char.bold ?? bold,
                    italic: char.italic ?? italic,
                    underline: char.underline ?? underline,
                    strikethrough: char.strikethrough ?? strikethrough,
                    inverted: char.inverted ?? false
                )
                return Cell(
                    char: char.characters[char.startIndex],
                    foregroundColor: char.foregroundColor ?? foregroundColor,
                    backgroundColor: char.backgroundColor,
                    attributes: cellAttributes
                )
            }

            if let text {
                guard originalIndex < text.count else { return nil }
                let cellAttributes = CellAttributes(
                    bold: bold,
                    italic: italic,
                    underline: underline,
                    strikethrough: strikethrough
                )
                return Cell(
                    char: text[text.index(text.startIndex, offsetBy: originalIndex)],
                    foregroundColor: foregroundColor,
                    attributes: cellAttributes
                )
            }
            return nil
        }

        // MARK: - Word wrapping

        private func wrappedLines(forWidth width: Int) -> [WrappedLine] {
            if let cachedWidth, cachedWidth == width {
                return cachedLines
            }

            let allChars: [Character]
            if let text {
                allChars = Array(text)
            } else if #available(macOS 12, iOS 15, *), let attributedText {
                allChars = Array(attributedText.characters)
            } else {
                cachedLines = [WrappedLine(startOffset: 0, text: "")]
                cachedWidth = width
                return cachedLines
            }

            guard !allChars.isEmpty else {
                cachedLines = [WrappedLine(startOffset: 0, text: "")]
                cachedWidth = width
                return cachedLines
            }

            var result: [WrappedLine] = []

            // Split by explicit newlines, then word-wrap each paragraph
            let paragraphs = splitByNewlines(allChars)
            for para in paragraphs {
                let paraLines = wordWrap(chars: para.chars, startOffset: para.offset, width: width)
                result.append(contentsOf: paraLines)
            }

            if result.isEmpty {
                result = [WrappedLine(startOffset: 0, text: "")]
            }

            cachedLines = result
            cachedWidth = width
            return result
        }

        private struct Paragraph {
            let chars: [Character]
            let offset: Int
        }

        private func splitByNewlines(_ chars: [Character]) -> [Paragraph] {
            var paragraphs: [Paragraph] = []
            var start = 0
            for i in 0..<chars.count {
                if chars[i] == "\n" {
                    paragraphs.append(Paragraph(chars: Array(chars[start..<i]), offset: start))
                    start = i + 1
                }
            }
            paragraphs.append(Paragraph(chars: Array(chars[start..<chars.count]), offset: start))
            return paragraphs
        }

        private func wordWrap(chars: [Character], startOffset: Int, width: Int) -> [WrappedLine] {
            guard !chars.isEmpty else {
                return [WrappedLine(startOffset: startOffset, text: "")]
            }
            if chars.count <= width {
                return [WrappedLine(startOffset: startOffset, text: String(chars))]
            }

            var result: [WrappedLine] = []
            var lineStart = 0
            var lineLength = 0
            var i = 0

            while i < chars.count {
                // Find next word
                let wordStart = i
                while i < chars.count && chars[i] != " " {
                    i += 1
                }
                let wordLength = i - wordStart

                if lineLength == 0 {
                    if wordLength > width {
                        // Break long word across lines
                        var pos = wordStart
                        while pos - wordStart < wordLength - width {
                            let end = pos + width
                            result.append(WrappedLine(
                                startOffset: startOffset + pos,
                                text: String(chars[pos..<end])
                            ))
                            pos = end
                        }
                        lineStart = pos
                        lineLength = wordStart + wordLength - pos
                    } else {
                        lineStart = wordStart
                        lineLength = wordLength
                    }
                } else if lineLength + 1 + wordLength <= width {
                    lineLength += 1 + wordLength
                } else {
                    result.append(WrappedLine(
                        startOffset: startOffset + lineStart,
                        text: String(chars[lineStart..<(lineStart + lineLength)])
                    ))
                    if wordLength > width {
                        var pos = wordStart
                        while pos - wordStart < wordLength - width {
                            let end = pos + width
                            result.append(WrappedLine(
                                startOffset: startOffset + pos,
                                text: String(chars[pos..<end])
                            ))
                            pos = end
                        }
                        lineStart = pos
                        lineLength = wordStart + wordLength - pos
                    } else {
                        lineStart = wordStart
                        lineLength = wordLength
                    }
                }

                // Skip space
                if i < chars.count && chars[i] == " " {
                    i += 1
                }
            }

            if lineLength > 0 || result.isEmpty {
                result.append(WrappedLine(
                    startOffset: startOffset + lineStart,
                    text: String(chars[lineStart..<(lineStart + lineLength)])
                ))
            }

            return result
        }

        private var characterCount: Int {
            if #available(macOS 12, iOS 15, *), let attributedText {
                return attributedText.characters.count
            }
            return text?.count ?? 0
        }
    }
}
