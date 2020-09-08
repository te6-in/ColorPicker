//
//  AppDelegate.swift
//  ColorPicker
//
//  Created by 찬휘 on 9. 3..
//  Copyright © 2020 주찬휘. All rights reserved.
//

import SwiftUI
import HotKey

//config

let alwaysListenToMouseMovements = false

let getHotKey = HotKey(key: .g, modifiers: [.command, .option])
let copyHotKey = HotKey(key: .c, modifiers: [.command, .option])

//

let pasteboard = NSPasteboard.general
let colorCode = PickedColor()
let saved9Colors = Saved9Colors()

var savedColors: [NSColor] = []
var colorChart: [colorInfo] = []

//json
struct colorInfo: Codable {
	var index: UInt
	var hex: String
//	var memo: String
}

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

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
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
				
				//색상 추출하여 저장
				let color = getColor()
				colorCode.color = color
				savedColors.append(color)
				colorChart.append(colorInfo(index: UInt(savedColors.count - 1), hex: convertNSColorToHex(color: color)))
				
				//저장한 colorchart json으로 encode
				let jsonData = try? encoder.encode(colorChart)
				let jsonString = String(data: jsonData!, encoding: .utf8)
				
				//SavedColors 표시
				
				//채우는중
				if savedColors.count <= 9 {
					//isAvailable
					saved9Colors.isAvailable[savedColors.count-1] = true
					
					//color
					saved9Colors.colors = savedColors.reversed()
					if savedColors.count == 9 {
					} else {
						for _ in 1...(9-savedColors.count) {
							saved9Colors.colors.append(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
						}
					}
				}
					
				//채움
				else {
					//isAvailable
					//이미 [true, true, true, true, true, true, true, true, true]
					
					//color
					saved9Colors.colors = Array(savedColors.reversed()[0...8])
				}
			}
		}
		
		copyHotKey.keyDownHandler = {
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(convertNSColorToHex(color: colorCode.color), forType: .string)
		}
	}


	func applicationWillTerminate(_ aNotification: Notification) {
		
	}
	
}

func getColor() -> NSColor {
	var mouseLocation: NSPoint { NSEvent.mouseLocation }
	
	var color: NSColor
	
	let x: CGFloat = floor(mouseLocation.x)
	let y: CGFloat = (NSScreen.main!.frame.size.height) - floor(mouseLocation.y)
	
	let pixel: CGImage = CGWindowListCreateImage(CGRect(x: x, y: y, width: 1, height: 1), .optionAll, kCGNullWindowID, .nominalResolution)!
	
	let bitmap = NSBitmapImageRep(cgImage: pixel)
	bitmap.colorSpaceName = NSColorSpaceName.deviceRGB
	color = bitmap.colorAt(x: 0, y: 0)!
	
	return color
}

func closeApp() {
	exit(0)
}

func copySavedColor(num: Int) {
	pasteboard.declareTypes([.string], owner: nil)
	pasteboard.setString(convertNSColorToHex(color: saved9Colors.colors[num]), forType: .string)
}

func showMoreColors() {
	
}

// NSColor to Hex String
func convertNSColorToHex(color: NSColor) -> String {
	var r: CGFloat = 0
	var g: CGFloat = 0
	var b: CGFloat = 0
	var a: CGFloat = 0
	
	color.getRed(&r, green: &g, blue: &b, alpha: &a)
	
	let hexString = String(format: "%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
	
	return hexString
}
