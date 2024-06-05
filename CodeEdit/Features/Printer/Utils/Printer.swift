//
//  Printer.swift
//  MathLateX
//
//  Created by christian on 03/06/24.
//

import Foundation
import SwiftUI

open class Printer<Content>: NSView where Content : View {

    func startPrinting() {
        let printView = NSHostingView(rootView: Text("I want to print"))
        printView.frame.size = CGSize(width: 200, height: 200)

        let printInfo = NSPrintInfo()
        printInfo.topMargin = 0
        printInfo.leftMargin = 0
        printInfo.bottomMargin = 0
        printInfo.rightMargin = 0

        let printOperation = NSPrintOperation(view: printView, printInfo: printInfo)
        printOperation.run()
    }
}
