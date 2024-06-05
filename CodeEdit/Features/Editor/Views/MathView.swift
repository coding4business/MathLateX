//
//  MathView.swift
//  MathLateX
//
//  Created by christian on 06/06/24.
//

import SwiftUI
import SwiftMath

struct MathView: NSViewRepresentable {

    var equation: String
    var fontSize: CGFloat

    func makeNSView(context: Context) -> MTMathUILabel {
        let view = MTMathUILabel()
        return view
    }

    func updateNSView(_ view: MTMathUILabel, context: Context) {
        view.latex = equation
        view.fontSize = fontSize
        view.font = MTFontManager().termesFont(withSize: fontSize)
        view.textColor = .textColor
        view.textAlignment = .center
        view.labelMode = .display
    }
}
