
import SwiftUI

public struct Text {
    let text: String
    public init(_ text: String) {
        self.text = text
    }
}

extension Text: BuiltinView, View {

    public typealias Body = Never

    var framesetter: CTFramesetter {
        let font = NSFont.systemFont(ofSize: 13)
        let attributes = [NSAttributedString.Key.font: font]
        let string = NSAttributedString(string: text, attributes: attributes)
        return CTFramesetterCreateWithAttributedString(string)
    }

    func size(proposed: CGSize) -> CGSize {
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, proposed, nil)
    }

    func render(context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        let path = CGPath(rect: rect, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), path, nil)
        context.saveGState()
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        CTFrameDraw(frame, context)
        context.restoreGState()
    }

    public var swiftUI: some SwiftUI.View {
        SwiftUI.Text(text)
    }
}