//
//  UserProfile.swift
//  MathLateX
//
//  Created by christian on 03/06/24.
//

import Foundation
import SwiftUI

class UserProfile {

    @State var isPresented = false
    @State var isDarkMode = true

    init(isPresented: Bool = false, isDarkMode: Bool = true) {
        self.isPresented = isPresented
        self.isDarkMode = isDarkMode
    }

     func changeTheme() -> some View {
        Button("Show Sheet") { [self] in
            isPresented.toggle()
        }
        .sheet(isPresented: self.$isPresented) {
            List {
                Toggle("Dark Mode", isOn: self.$isDarkMode)
            }
            .preferredColorScheme(self.$isDarkMode.wrappedValue ? .dark : .light)
        }
    }
}
