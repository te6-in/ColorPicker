//
//  AppDelegate.swift
//  ColorPicker2
//
//  Created by 찬휘 on 9. 3..
//  Copyright © 2020 주찬휘. All rights reserved.
//

import SwiftUI
import HotKey

let getHotKey = HotKey(key: .g, modifiers: [.command, .option])
let copyHotKey = HotKey(key: .c, modifiers: [.command, .option])
let closeHotKey = HotKey(key: .w, modifiers: .command)

let pasteboard = NSPasteboard.general
let colorCode = PickedColor()
let saved9Colors = Saved9Colors()
let alwaysListenToMouseMovements = false

var savedColors: [NSColor] = []

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
		
		if alwaysListenToMouseMovements == true {
			NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
				colorCode.color = getColor()
				return $0
			}
			NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
				colorCode.color = getColor()
			}
		}
		
		if alwaysListenToMouseMovements == false {
			getHotKey.keyDownHandler = {
				colorCode.color = getColor()
				savedColors.append(getColor())
				if savedColors.count <= 9 {
					saved9Colors.colors = savedColors.reversed()
					if savedColors.count == 9 {
					} else {
						for _ in 1...(9-savedColors.count) {
							saved9Colors.colors.append(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
						}
					}
				}
				else {
					saved9Colors.colors = Array(savedColors.reversed()[0...8])
				}
			}
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
