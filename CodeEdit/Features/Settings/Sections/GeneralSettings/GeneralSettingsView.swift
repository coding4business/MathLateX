//
//  GeneralSettingsView.swift
//  CodeEditModules/Settings
//
//  Created by Lukas Pistrol on 30.03.22.
//

import SwiftUI

/// A view that implements the `General` preference section
struct GeneralSettingsView: View {
    // MARK: - View

    var body: some View {
        SettingsContent {
            appearanceSection
            showIssuesSection
            fileExtensionsSection
            fileIconStyleSection
            tabBarStyleSection
            Group {
                reopenBehaviorSection
                reopenAfterWindowCloseBehaviourSection
            }
            projectNavigatorSizeSection
            findNavigatorDetailSection
            Group {
                issueNavigatorDetailSection
                dialogWarningsSection
            }
            Group {
                openInCodeEditToggle
                revealFileOnFocusChangeToggle
                shellCommandSection
                autoSaveSection
                updaterSection
            }
        }
            .frame(width: 715)
    }

    private let inputWidth: Double = 160
    private let textEditorWidth: Double = 220
    private let textEditorHeight: Double = 30

    @EnvironmentObject
    var updater: SoftwareUpdater

    @StateObject
    private var prefs: SettingsModel = .shared

    @State
    private var openInCodeEdit: Bool = true

    init() {
        guard let defaults = UserDefaults.init(
            suiteName: "austincondiff.CodeEdit.shared"
        ) else {
            print("Failed to get/init shared defaults")
            return
        }

        self.openInCodeEdit = defaults.bool(forKey: "enableOpenInCE")
    }
}

/// The extension of the view with all the settings
private extension GeneralSettingsView {
    // MARK: - Sections

    var appearanceSection: some View {
        SettingsSection("Appearance") {
            Picker("Appearance", selection: $prefs.settings.general.appAppearance) {
                Text("System")
                    .tag(Settings.Appearances.system)
                Divider()
                Text("Light")
                    .tag(Settings.Appearances.light)
                Text("Dark")
                    .tag(Settings.Appearances.dark)
            }
            .onChange(of: prefs.settings.general.appAppearance) { tag in
                tag.applyAppearance()
            }
            .frame(width: inputWidth)
        }
    }

    // TODO: Implement reflecting Show Issues preference and remove disabled modifier
    var showIssuesSection: some View {
        SettingsSection("Show Issues", hideLabels: false) {
            Picker("Show Issues", selection: $prefs.settings.general.showIssues) {
                Text("Show Inline")
                    .tag(Settings.Issues.inline)
                Text("Show Minimized")
                    .tag(Settings.Issues.minimized)
            }
            .labelsHidden()
            .frame(width: inputWidth)

            Toggle("Show Live Issues", isOn: $prefs.settings.general.showLiveIssues)
                .toggleStyle(.checkbox)
        }
        .disabled(true)
    }

    var fileExtensionsSection: some View {
        SettingsSection("File Extensions") {
            Picker("File Extensions:", selection: $prefs.settings.general.fileExtensionsVisibility) {
                Text("Hide all")
                    .tag(Settings.FileExtensionsVisibility.hideAll)
                Text("Show all")
                    .tag(Settings.FileExtensionsVisibility.showAll)
                Divider()
                Text("Show only")
                    .tag(Settings.FileExtensionsVisibility.showOnly)
                Text("Hide only")
                    .tag(Settings.FileExtensionsVisibility.hideOnly)
            }
            .frame(width: inputWidth)
            if case .showOnly = prefs.settings.general.fileExtensionsVisibility {
                SettingsTextEditor(text: $prefs.settings.general.shownFileExtensions.string)
                    .frame(width: textEditorWidth)
                    .frame(height: textEditorHeight)
            }
            if case .hideOnly = prefs.settings.general.fileExtensionsVisibility {
                SettingsTextEditor(text: $prefs.settings.general.hiddenFileExtensions.string)
                .frame(width: textEditorWidth)
                .frame(height: textEditorHeight)
            }
        }
    }

    var fileIconStyleSection: some View {
        SettingsSection("File Icon Style") {
            Picker("File Icon Style:", selection: $prefs.settings.general.fileIconStyle) {
                Text("Color")
                    .tag(Settings.FileIconStyle.color)
                Text("Monochrome")
                    .tag(Settings.FileIconStyle.monochrome)
            }
            .pickerStyle(.radioGroup)
        }
    }

    var tabBarStyleSection: some View {
        SettingsSection("Tab Bar Style") {
            Picker("Tab Bar Style:", selection: $prefs.settings.general.tabBarStyle) {
                Text("Xcode")
                    .tag(Settings.TabBarStyle.xcode)
                Text("Native")
                    .tag(Settings.TabBarStyle.native)
            }
            .pickerStyle(.radioGroup)
        }
    }

    var reopenBehaviorSection: some View {
        SettingsSection("Reopen Behavior") {
            Picker("Reopen Behavior:", selection: $prefs.settings.general.reopenBehavior) {
                Text("Welcome Screen")
                    .tag(Settings.ReopenBehavior.welcome)
                Divider()
                Text("Open Panel")
                    .tag(Settings.ReopenBehavior.openPanel)
                Text("New Document")
                    .tag(Settings.ReopenBehavior.newDocument)
            }
            .frame(width: inputWidth)
        }
    }

    var reopenAfterWindowCloseBehaviourSection: some View {
        SettingsSection("After last window closed") {
            Picker(
                "After last window closed:",
                selection: $prefs.settings.general.reopenWindowAfterClose
            ) {
                Text("Do nothing")
                    .tag(Settings.ReopenWindowBehavior.doNothing)
                Divider()
                Text("Show Welcome Window")
                    .tag(Settings.ReopenWindowBehavior.showWelcomeWindow)
                Text("Quit")
                    .tag(Settings.ReopenWindowBehavior.quit)
            }
            .frame(width: inputWidth)
        }
    }

    var projectNavigatorSizeSection: some View {
        SettingsSection("Project Navigator Size") {
            Picker("Project Navigator Size", selection: $prefs.settings.general.projectNavigatorSize) {
                Text("Small")
                    .tag(Settings.ProjectNavigatorSize.small)
                Text("Medium")
                    .tag(Settings.ProjectNavigatorSize.medium)
                Text("Large")
                    .tag(Settings.ProjectNavigatorSize.large)
            }
            .frame(width: inputWidth)
        }
    }

    var findNavigatorDetailSection: some View {
        SettingsSection("Find Navigator Detail") {
            Picker("Find Navigator Detail", selection: $prefs.settings.general.findNavigatorDetail) {
                ForEach(Settings.NavigatorDetail.allCases, id: \.self) { tag in
                    Text(tag.label).tag(tag)
                }
            }
            .frame(width: inputWidth)
        }
    }

    // TODO: Implement reflecting Issue Navigator Detail preference and remove disabled modifier
    var issueNavigatorDetailSection: some View {
        SettingsSection("Issue Navigator Detail") {
            Picker("Issue Navigator Detail", selection: $prefs.settings.general.issueNavigatorDetail) {
                ForEach(Settings.NavigatorDetail.allCases, id: \.self) { tag in
                    Text(tag.label).tag(tag)
                }
            }
            .frame(width: inputWidth)
        }
        .disabled(true)
    }

    // TODO: Implement reset for Don't Ask Me warnings Button and remove disabled modifier
    var dialogWarningsSection: some View {
        SettingsSection("Dialog Warnings", align: .center) {
            Button(action: {
            }, label: {
                Text("Reset \"Don't Ask Me\" Warnings")
                    .padding(.horizontal, 10)
            })
            .buttonStyle(.bordered)
        }
        .disabled(true)
    }

    var shellCommandSection: some View {
        SettingsSection("Shell Command", align: .center) {
            Button(action: {
                do {
                    let url = Bundle.main.url(forResource: "codeedit", withExtension: nil, subdirectory: "Resources")
                    let destination = "/usr/local/bin/codeedit"

                    if FileManager.default.fileExists(atPath: destination) {
                        try FileManager.default.removeItem(atPath: destination)
                    }

                    guard let shellUrl = url?.path else {
                        print("Failed to get URL to shell command")
                        return
                    }

                    NSWorkspace.shared.requestAuthorization(to: .createSymbolicLink) { auth, error in
                        guard let auth, error == nil else {
                            fallbackShellInstallation(commandPath: shellUrl, destinationPath: destination)
                            return
                        }

                        do {
                            try FileManager(authorization: auth).createSymbolicLink(
                                atPath: destination, withDestinationPath: shellUrl
                            )
                        } catch {
                            fallbackShellInstallation(commandPath: shellUrl, destinationPath: destination)
                        }
                    }
                } catch {
                    print(error)
                }
            }, label: {
                Text("Install 'codeedit' command")
                    .padding(.horizontal, 10)
            })
            .disabled(true)
            .buttonStyle(.bordered)
        }
    }

    var updaterSection: some View {
        SettingsSection("Software Updates", hideLabels: false) {
            VStack(alignment: .leading) {
                Toggle("Automatically check for app updates", isOn: $updater.automaticallyChecksForUpdates)

                Toggle("Include pre-release versions", isOn: $updater.includePrereleaseVersions)

                Button("Check Now") {
                    updater.checkForUpdates()
                }

                Text("Last checked: \(lastUpdatedString)")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var autoSaveSection: some View {
        SettingsSection("Auto Save Behavior", hideLabels: false) {
            Toggle(
                "Automatically save changes to disk",
                isOn: $prefs.settings.general.isAutoSaveOn
            )
            .toggleStyle(.checkbox)
        }
    }

    // MARK: - Preference Views

    private var lastUpdatedString: String {
        if let lastUpdatedDate = updater.lastUpdateCheckDate {
            return Self.formatter.string(from: lastUpdatedDate)
        } else {
            return "Never"
        }
    }

    private static func configure<Subject>(_ subject: Subject, configuration: (inout Subject) -> Void) -> Subject {
        var copy = subject
        configuration(&copy)
        return copy
    }

    func fallbackShellInstallation(commandPath: String, destinationPath: String) {
        let cmd = [
            "osascript",
            "-e",
            "\"do shell script \\\"mkdir -p /usr/local/bin && ln -sf \'\(commandPath)\' \'\(destinationPath)\'\\\"\"",
            "with administrator privileges"
        ]

        let cmdStr = cmd.joined(separator: " ")

        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", cmdStr]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        do {
            try task.run()
        } catch {
            print(error)
        }
    }

    var openInCodeEditToggle: some View {
        SettingsSection("Finder Context Menu", hideLabels: false) {
            Toggle("Show “Open With CodeEdit” option", isOn: $openInCodeEdit)
                .toggleStyle(.checkbox)
                .onChange(of: openInCodeEdit) { newValue in
                    guard let defaults = UserDefaults.init(
                        suiteName: "austincondiff.CodeEdit.shared"
                    ) else {
                        print("Failed to get/init shared defaults")
                        return
                    }

                    defaults.set(newValue, forKey: "enableOpenInCE")
                }
        }
    }

    var revealFileOnFocusChangeToggle: some View {
        SettingsSection("Project Navigator Behavior", hideLabels: false) {
            Toggle("Automatically Show Active File", isOn: $prefs.settings.general.revealFileOnFocusChange)
                .toggleStyle(.checkbox)
        }
    }

    // MARK: - Formatters

    private static let formatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .medium
    }
}