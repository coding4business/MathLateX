//
//  TerminalThemeView.swift
//  CodeEditModules/Settings
//
//  Created by Lukas Pistrol on 31.03.22.
//

import SwiftUI

/// A view that implements the `Terminal theme` preference section
struct TerminalThemeView: View {

    // MARK: - View

    var body: some View {
        terminalThemeView
    }

    @StateObject
    private var prefs: SettingsModel = .shared

    @StateObject
    private var themeModel: ThemeModel = .shared
}

private extension TerminalThemeView {

    // MARK: - Sections

    private var terminalThemeView: some View {
        ZStack(alignment: .topLeading) {
            EffectView(.contentBackground)
            if themeModel.selectedTheme == nil {
                selectTheme
            } else {
                VStack(alignment: .leading, spacing: 15) {
                    topToggles
                    colorSelector
                    ansiColorSelector
                }
                .padding(20)
            }
        }
    }

    // MARK: - Preference Views

    private var selectTheme: some View {
        Text("Select a Theme")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var topToggles: some View {
        VStack(alignment: .leading) {
            Toggle("Always use dark terminal appearance", isOn: $prefs.settings.terminal.darkAppearance)
            Toggle("Use theme background ", isOn: $prefs.settings.terminal.useThemeBackground)
        }
    }

    private var colorSelector: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Background & Text")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            HStack(alignment: .top, spacing: 0) {
                if let selectedTheme = themeModel.selectedTheme,
                   let index = themeModel.themes.firstIndex(of: selectedTheme) {
                    VStack(alignment: .leading, spacing: 10) {
                        SettingsColorPicker(
                            $themeModel.themes[index].terminal.text.swiftColor,
                            label: "Text"
                        )
                        SettingsColorPicker(
                            $themeModel.themes[index].terminal.boldText.swiftColor,
                            label: "Bold Text"
                        )
                        SettingsColorPicker(
                            $themeModel.themes[index].terminal.cursor.swiftColor,
                            label: "Cursor"
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(alignment: .leading, spacing: 10) {
                        SettingsColorPicker(
                            $themeModel.themes[index].terminal.background.swiftColor,
                            label: "Background"
                        )
                        SettingsColorPicker(
                            $themeModel.themes[index].terminal.selection.swiftColor,
                            label: "Selection"
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var ansiColorSelector: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let selectedTheme = themeModel.selectedTheme,
               let index = themeModel.themes.firstIndex(of: selectedTheme) {
                Text("ANSI Colors")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 5)
                HStack(spacing: 5) {
                    SettingsColorPicker($themeModel.themes[index].terminal.black.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.red.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.green.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.yellow.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.blue.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.magenta.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.cyan.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.white.swiftColor)
                    Text("Normal").padding(.leading, 4)
                }
                HStack(spacing: 5) {
                    SettingsColorPicker($themeModel.themes[index].terminal.brightBlack.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightRed.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightGreen.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightYellow.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightBlue.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightMagenta.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightCyan.swiftColor)
                    SettingsColorPicker($themeModel.themes[index].terminal.brightWhite.swiftColor)
                    Text("Bright").padding(.leading, 4)
                }
                .padding(.top, 5)
            }
        }
    }
}