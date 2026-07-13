//
//  Reporting.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

/// Prints an error message with CLI styling.
func print(error: String) {
    print("🔴 " + error.red.bold)
}

/// Prints a warning message with CLI styling.
func print(warning: String) {
    print("🟡 " + warning.yellow.bold)
}

/// Prints an informational message with CLI styling.
func print(info: String) {
    print("🔵 " + info.lightWhite)
}

/// Prints a debug message when debug logging is enabled.
func print(debug: String) {
    if Babel.isDebug {
        print("🟤 " + debug.lightBlack)
    }
}
