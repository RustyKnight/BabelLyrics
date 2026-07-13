//
//  Reporting.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

func print(error: String) {
    print("🔴 " + error.red.bold)
}

func print(warning: String) {
    print("🟡 " + warning.yellow.bold)
}

func print(info: String) {
    print("🔵 " + info.lightWhite)
}

func print(debug: String) {
    if Babel.isDebug {
        print("🟤 " + debug.lightBlack)
    }
}
