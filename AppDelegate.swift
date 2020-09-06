//
//  AppDelegate.swift
//  ColorPicker2
//
//  Created by 찬휘 on 9. 3..
//  Copyright © 2020 주찬휘. All rights reserved.
//

import SwiftUI
import HotKey

// Hex String to Color
extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        if string.count > 8 {
            string = String(string.prefix(8))
        }

        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}

let getHotKey = HotKey(key: .g, modifiers: [.command, .option])
let copyHotKey = HotKey(key: .c, modifiers: [.command, .option])
let closeHotKey = HotKey(key: .w, modifiers: .command)

let pasteboard = NSPasteboard.general
let colorCode = PickedColor()

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		colorCode.color = getColor()
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = MainView()

		// Create the window and set the content view.
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
			styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
			backing: .buffered, defer: false)
		window.center()
		
		window.contentView = NSHostingView(rootView: contentView.environmentObject(colorCode))
		
		window.makeKeyAndOrderFront(nil)
		
		window.styleMask.remove(.titled)
		window.isMovableByWindowBackground = true
		window.backgroundColor = .clear
		window.appearance = NSAppearance(named: .aqua)
		
		getHotKey.keyDownHandler = {
			colorCode.color = getColor()
		}
		copyHotKey.keyDownHandler = {
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(convertNSColorToHex(color: colorCode.color), forType: .string)
		}
		closeHotKey.keyDownHandler = {
			closeApp()
		}
	}


	func applicationWillTerminate(_ aNotification: Notification) {
		
	}
	
}
