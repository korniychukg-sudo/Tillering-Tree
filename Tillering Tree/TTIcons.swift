import SwiftUI

struct GlyphLamp: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.06))
        p.addLine(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.24))
        p.move(to: CGPoint(x: r.minX + w * 0.24, y: r.minY + h * 0.56))
        p.addLine(to: CGPoint(x: r.minX + w * 0.36, y: r.minY + h * 0.26))
        p.addLine(to: CGPoint(x: r.minX + w * 0.64, y: r.minY + h * 0.26))
        p.addLine(to: CGPoint(x: r.minX + w * 0.76, y: r.minY + h * 0.56))
        p.closeSubpath()
        p.move(to: CGPoint(x: r.minX + w * 0.36, y: r.minY + h * 0.56))
        p.addLine(to: CGPoint(x: r.minX + w * 0.64, y: r.minY + h * 0.56))
        p.move(to: CGPoint(x: r.minX + w * 0.16, y: r.minY + h * 0.94))
        p.addLine(to: CGPoint(x: r.minX + w * 0.84, y: r.minY + h * 0.94))
        p.move(to: CGPoint(x: r.minX + w * 0.30, y: r.minY + h * 0.78))
        p.addLine(to: CGPoint(x: r.minX + w * 0.44, y: r.minY + h * 0.66))
        p.move(to: CGPoint(x: r.minX + w * 0.70, y: r.minY + h * 0.78))
        p.addLine(to: CGPoint(x: r.minX + w * 0.56, y: r.minY + h * 0.66))
        return p
    }
}

struct GlyphKnife: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.08, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.40))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.40),
                       control: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.24))
        p.addLine(to: CGPoint(x: r.minX + w * 0.92, y: r.minY + h * 0.40))
        p.move(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.62))
        p.move(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.62))
        p.move(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.62))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.62),
                       control: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.46))
        p.move(to: CGPoint(x: r.minX + w * 0.08, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.08, y: r.minY + h * 0.68))
        p.move(to: CGPoint(x: r.minX + w * 0.92, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.92, y: r.minY + h * 0.68))
        return p
    }
}

struct GlyphBow: Shape {
    var bend: CGFloat = 0.30
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.06))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.94),
                   control1: CGPoint(x: r.minX + w * (0.28 + bend * 2.2), y: r.minY + h * 0.30),
                   control2: CGPoint(x: r.minX + w * (0.28 + bend * 2.2), y: r.minY + h * 0.70))
        p.move(to: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.06))
        p.addLine(to: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.94))
        return p
    }
}

struct GlyphTarget: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: r.midX, y: r.midY)
        for k in 1...3 {
            let rad = r.width * 0.14 * CGFloat(k)
            p.addEllipse(in: CGRect(x: c.x - rad, y: c.y - rad, width: rad * 2, height: rad * 2))
        }
        p.move(to: CGPoint(x: r.minX + r.width * 0.86, y: r.minY + r.height * 0.14))
        p.addLine(to: CGPoint(x: c.x + r.width * 0.06, y: c.y - r.height * 0.06))
        p.move(to: CGPoint(x: r.minX + r.width * 0.86, y: r.minY + r.height * 0.14))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.72, y: r.minY + r.height * 0.16))
        p.move(to: CGPoint(x: r.minX + r.width * 0.86, y: r.minY + r.height * 0.14))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.84, y: r.minY + r.height * 0.28))
        return p
    }
}

struct GlyphBook: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.24))
        p.addLine(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.86))
        p.move(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.24))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.08, y: r.minY + h * 0.18),
                   control1: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.12),
                   control2: CGPoint(x: r.minX + w * 0.18, y: r.minY + h * 0.12))
        p.addLine(to: CGPoint(x: r.minX + w * 0.08, y: r.minY + h * 0.80))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.86),
                   control1: CGPoint(x: r.minX + w * 0.18, y: r.minY + h * 0.74),
                   control2: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.74))
        p.move(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.24))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.92, y: r.minY + h * 0.18),
                   control1: CGPoint(x: r.minX + w * 0.66, y: r.minY + h * 0.12),
                   control2: CGPoint(x: r.minX + w * 0.82, y: r.minY + h * 0.12))
        p.addLine(to: CGPoint(x: r.minX + w * 0.92, y: r.minY + h * 0.80))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.86),
                   control1: CGPoint(x: r.minX + w * 0.82, y: r.minY + h * 0.74),
                   control2: CGPoint(x: r.minX + w * 0.66, y: r.minY + h * 0.74))
        return p
    }
}

struct GlyphPost: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.42, y: r.minY + h * 0.06))
        p.addLine(to: CGPoint(x: r.minX + w * 0.42, y: r.minY + h * 0.94))
        p.move(to: CGPoint(x: r.minX + w * 0.58, y: r.minY + h * 0.06))
        p.addLine(to: CGPoint(x: r.minX + w * 0.58, y: r.minY + h * 0.94))
        for k in 0..<4 {
            let y = r.minY + h * (0.36 + CGFloat(k) * 0.16)
            p.move(to: CGPoint(x: r.minX + w * 0.58, y: y))
            p.addLine(to: CGPoint(x: r.minX + w * 0.80, y: y - h * 0.05))
        }
        p.move(to: CGPoint(x: r.minX + w * 0.16, y: r.minY + h * 0.22))
        p.addLine(to: CGPoint(x: r.minX + w * 0.84, y: r.minY + h * 0.22))
        return p
    }
}

struct GlyphMark: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX + r.width * 0.16, y: r.minY + r.height * 0.54))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.40, y: r.minY + r.height * 0.78))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.86, y: r.minY + r.height * 0.22))
        return p
    }
}

struct GlyphCross: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX + r.width * 0.20, y: r.minY + r.height * 0.20))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.80, y: r.minY + r.height * 0.80))
        p.move(to: CGPoint(x: r.minX + r.width * 0.80, y: r.minY + r.height * 0.20))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.20, y: r.minY + r.height * 0.80))
        return p
    }
}

struct GlyphArrowRight: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX + r.width * 0.22, y: r.midY))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.78, y: r.midY))
        p.move(to: CGPoint(x: r.minX + r.width * 0.56, y: r.minY + r.height * 0.28))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.78, y: r.midY))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.56, y: r.minY + r.height * 0.72))
        return p
    }
}

struct GlyphRings: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: r.midX, y: r.midY)
        for k in 1...4 {
            let rad = r.width * 0.11 * CGFloat(k)
            p.addEllipse(in: CGRect(x: c.x - rad, y: c.y - rad, width: rad * 2, height: rad * 2))
        }
        return p
    }
}

struct GlyphScraper: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.18, y: r.minY + h * 0.24))
        p.addLine(to: CGPoint(x: r.minX + w * 0.82, y: r.minY + h * 0.24))
        p.addLine(to: CGPoint(x: r.minX + w * 0.82, y: r.minY + h * 0.66))
        p.addLine(to: CGPoint(x: r.minX + w * 0.18, y: r.minY + h * 0.66))
        p.closeSubpath()
        p.move(to: CGPoint(x: r.minX + w * 0.12, y: r.minY + h * 0.82))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.88, y: r.minY + h * 0.82),
                       control: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.94))
        return p
    }
}

struct StrokeGlyph<S: Shape>: View {
    let shape: S
    var tone: Color = Bark.ink
    var width: CGFloat = 1.6
    var body: some View {
        shape.stroke(tone, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
    }
}
