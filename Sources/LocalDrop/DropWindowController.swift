import AppKit
import UniformTypeIdentifiers

final class DropWindowController: NSWindowController {
    convenience init() {
        let dropView = DropView(frame: NSRect(x: 0, y: 0, width: 620, height: 430))
        let window = NSWindow(
            contentRect: dropView.frame,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "LocalDrop"
        window.center()
        window.minSize = NSSize(width: 480, height: 340)
        window.contentView = dropView
        self.init(window: window)
    }
}

final class DropView: NSView {
    private let converter = ConversionService()
    private var draggedURL: URL?
    private var formats: [String] = []
    private var highlightedIndex: Int?
    private var message = "Drop an image anywhere in this window"
    private var detail = "Choose an output by moving around the wheel"

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([.fileURL])
        wantsLayer = true
    }

    required init?(coder: NSCoder) { nil }

    override var isFlipped: Bool { true }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.windowBackgroundColor.setFill()
        bounds.fill()

        let center = CGPoint(x: bounds.midX, y: bounds.midY + 20)
        if formats.isEmpty {
            drawLanding(center: center)
        } else {
            drawWheel(center: center)
        }
        drawText(message, size: 24, weight: .semibold, y: 58)
        drawText(detail, size: 14, weight: .regular, y: 94, color: .secondaryLabelColor)
    }

    private func drawLanding(center: CGPoint) {
        let rect = NSRect(x: center.x - 105, y: center.y - 105, width: 210, height: 210)
        let path = NSBezierPath(roundedRect: rect, xRadius: 52, yRadius: 52)
        NSColor.controlAccentColor.withAlphaComponent(0.12).setFill()
        path.fill()
        NSColor.controlAccentColor.withAlphaComponent(0.55).setStroke()
        path.lineWidth = 2
        path.setLineDash([8, 7], count: 2, phase: 0)
        path.stroke()

        let icon = NSImage(systemSymbolName: "arrow.down.doc", accessibilityDescription: "Drop a file")
        icon?.size = NSSize(width: 58, height: 58)
        icon?.draw(in: NSRect(x: center.x - 29, y: center.y - 29, width: 58, height: 58))
    }

    private func drawWheel(center: CGPoint) {
        let outer: CGFloat = 128
        let inner: CGFloat = 48
        for index in formats.indices {
            let start = -CGFloat.pi / 2 + CGFloat(index) * 2 * .pi / CGFloat(formats.count)
            let end = -CGFloat.pi / 2 + CGFloat(index + 1) * 2 * .pi / CGFloat(formats.count)
            let path = NSBezierPath()
            path.appendArc(withCenter: center, radius: outer, startAngle: start * 180 / .pi, endAngle: end * 180 / .pi)
            path.appendArc(withCenter: center, radius: inner, startAngle: end * 180 / .pi, endAngle: start * 180 / .pi, clockwise: true)
            path.close()
            (index == highlightedIndex ? NSColor.controlAccentColor : NSColor.controlColor).setFill()
            path.fill()
            NSColor.windowBackgroundColor.setStroke()
            path.lineWidth = 3
            path.stroke()

            let angle = (start + end) / 2
            let labelCenter = CGPoint(x: center.x + cos(angle) * 87, y: center.y + sin(angle) * 87)
            let text = formats[index].uppercased() as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor: index == highlightedIndex ? NSColor.white : NSColor.labelColor
            ]
            let size = text.size(withAttributes: attrs)
            text.draw(at: CGPoint(x: labelCenter.x - size.width / 2, y: labelCenter.y - size.height / 2), withAttributes: attrs)
        }
    }

    private func drawText(_ value: String, size: CGFloat, weight: NSFont.Weight, y: CGFloat, color: NSColor = .labelColor) {
        let text = value as NSString
        let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color]
        let textSize = text.size(withAttributes: attrs)
        text.draw(at: CGPoint(x: bounds.midX - textSize.width / 2, y: y), withAttributes: attrs)
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let url = fileURL(from: sender), !ConversionService.suggestedExtensions(for: url).isEmpty else {
            message = "That format is not supported yet"
            detail = "Try JPG, PNG, HEIC, TIFF, BMP, or GIF"
            needsDisplay = true
            return []
        }
        draggedURL = url
        formats = ConversionService.suggestedExtensions(for: url)
        message = "Convert \(url.lastPathComponent)"
        detail = "Move toward a format, then release"
        updateHighlight(sender)
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        updateHighlight(sender)
        return draggedURL == nil ? [] : .copy
    }

    override func draggingExited(_ sender: NSDraggingInfo?) { reset() }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let source = draggedURL, let index = highlightedIndex else { reset(); return false }
        do {
            let output = try converter.convert(source, to: formats[index])
            reset(message: "Created \(output.lastPathComponent)", detail: "Saved beside the original")
            NSSound(named: "Glass")?.play()
            return true
        } catch {
            reset(message: "Conversion failed", detail: error.localizedDescription)
            NSSound.beep()
            return false
        }
    }

    private func fileURL(from sender: NSDraggingInfo) -> URL? {
        let options: [NSPasteboard.ReadingOptionKey: Any] = [.urlReadingFileURLsOnly: true]
        return (sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: options) as? [URL])?.first
    }

    private func updateHighlight(_ sender: NSDraggingInfo) {
        guard !formats.isEmpty else { return }
        let point = convert(sender.draggingLocation, from: nil)
        let dx = point.x - bounds.midX
        let dy = point.y - (bounds.midY + 20)
        var angle = atan2(dy, dx) + .pi / 2
        if angle < 0 { angle += 2 * .pi }
        highlightedIndex = min(formats.count - 1, Int(angle / (2 * .pi) * CGFloat(formats.count)))
        needsDisplay = true
    }

    private func reset(message: String = "Drop an image anywhere in this window", detail: String = "Choose an output by moving around the wheel") {
        draggedURL = nil
        formats = []
        highlightedIndex = nil
        self.message = message
        self.detail = detail
        needsDisplay = true
    }
}
