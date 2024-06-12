//
//  MathLateXAppMenuBar.swift
//  MathLateX
//
//  Created by christian on 06/06/24.
//

import SwiftUI

struct MathLateXAppMenuBar: Scene {

    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

    var body: some Scene {
        MenuBarExtra(
            "App Menu Bar Extra",
            systemImage: "star",
            isInserted: $showMenuBarExtra
        ) {
        }
    }
}
