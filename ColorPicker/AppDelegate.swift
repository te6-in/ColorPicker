import SwiftUI
import HotKey

//config
let alwaysListenToMouseMovements = false

let getHotKey = HotKey(key: .g, modifiers: [.command, .option])
let copyHotKey = HotKey(key: .c, modifiers: [.command, .option])
//

let clipBoard = NSPasteboard.general
let newColor = NewColor()
let saved9Colors = Saved9Colors()

struct ColorInfo {
	var hex: String
	var color: NSColor
}

struct JSONColorInfo: Codable, Identifiable {
	var id = UUID()
	var index: Int
	var hex: String
//	var memo: String
}

var colorInfoChart: [ColorInfo] = []

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

	var mainWindow: NSWindow!
//	var savedColorsListWindow: NSWindow!
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		newColor.color = getColor()
		newColor.hex = convertNSColorToHex(color: newColor.color)
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		//메인뷰
		let mainView = MainView()

		mainWindow = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
			styleMask: [.closable, .miniaturizable, .fullSizeContentView],
			backing: .buffered, defer: false)
		mainWindow.center()
		
		mainWindow.contentView = NSHostingView(rootView: mainView.environmentObject(newColor))
		
		mainWindow.makeKeyAndOrderFront(nil)
		
		mainWindow.isMovableByWindowBackground = true
		mainWindow.backgroundColor = .clear
		mainWindow.appearance = NSAppearance(named: .aqua)

		//SCL뷰
//		let savedColorsListView = SavedColorsListView()
//
//		savedColorsListWindow = NSWindow(
//			contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
//			styleMask: [.titled, .closable, .miniaturizable],
//			backing: .buffered, defer: false)
//
//		savedColorsListWindow.contentView = NSHostingView(rootView: savedColorsListView.environmentObject(colorChart))
//
//		savedColorsListWindow.makeKeyAndOrderFront(nil)
//
//
		//json
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
		if alwaysListenToMouseMovements == true {
			NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
				newColor.color = getColor()
				return $0
			}
			NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
				newColor.color = getColor()
			}
		}
		
		if alwaysListenToMouseMovements == false {
			getHotKey.keyDownHandler = {
				
				//색상 추출하여 저장
				newColor.color = getColor()
				newColor.hex = convertNSColorToHex(color: newColor.color)
				
				let newColorInfo: ColorInfo = ColorInfo(hex: newColor.hex, color: newColor.color)
				colorInfoChart.append(newColorInfo)
				
				//저장한 colorInfoChart json으로 encode
//				let jsonData = try? encoder.encode(JSONColorInfo)
//				let jsonString = String(data: jsonData!, encoding: .utf8)
				
//				print(jsonString!)
				
				
				//SavedColors 표시
				
				//채우는중
				if colorInfoChart.count <= 9 {
					//isAvailable
					saved9Colors.isAvailable[colorInfoChart.count-1] = true
					let reversedColorInfoChart: Array = colorInfoChart.reversed()
					for i in 0...reversedColorInfoChart.count-1 {
						saved9Colors.colors[i] = reversedColorInfoChart[i].color
					}
					
					if colorInfoChart.count < 9 {
						for _ in 1...(9-colorInfoChart.count) {
							saved9Colors.colors.append(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
						}
					}
					
				}
				
				//채움
				else {
					//isAvailable
					//이미 [true, true, true, true, true, true, true, true, true]
					
					//color
					let reversedColorInfoChart: Array = colorInfoChart.reversed()
					for i in 0...8 {
						saved9Colors.colors[i] = reversedColorInfoChart[i].color
					}
				}
			}
		}
		
		copyHotKey.keyDownHandler = {
			clipBoard.declareTypes([.string], owner: nil)
			clipBoard.setString(convertNSColorToHex(color: newColor.color), forType: .string)
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
	clipBoard.declareTypes([.string], owner: nil)
	clipBoard.setString(convertNSColorToHex(color: saved9Colors.colors[num]), forType: .string)
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
