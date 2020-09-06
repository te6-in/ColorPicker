//
//  ContentView.swift
//  ColorPicker2
//
//  Created by 찬휘 on 9. 3..
//  Copyright © 2020 주찬휘. All rights reserved.
//

import SwiftUI
import AppKit
import CoreGraphics

extension NSImage {
    func tinting(with tintColor: NSColor) -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return self }
        
        return NSImage(size: size, flipped: false) { bounds in
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            tintColor.set()
            context.clip(to: bounds, mask: cgImage)
            context.fill(bounds)
            return true
        }
    }
}

class PickedColor: ObservableObject {
	@Published var color: NSColor = #colorLiteral(red: 0.317293094, green: 0.7423107362, blue: 0.8786026554, alpha: 1) //default
}

struct MainView: View {
	
	@EnvironmentObject var pickedColor: PickedColor
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			ZStack(alignment: .topLeading) {
				Rectangle()
					.frame(width: 258, height: 188)
					.opacity(0)
					.zIndex(0)
				ZStack(alignment: .topLeading) {
					Text(convertNSColorToHex(color: pickedColor.color))
						.font(.largeTitle)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.frame(width: 250, height: 180)
						.foregroundColor(.white)
						.zIndex(2)
					Image(nsImage: #imageLiteral(resourceName: "Shape"))
						.zIndex(3)
					ZStack(alignment: .topTrailing) {
						ZStack(alignment: .bottomLeading) {
							RoundedRectangle(cornerRadius: 10)
								.frame(width: 250, height: 180)
								.foregroundColor(Color(pickedColor.color))
								.zIndex(1)
							Button(action: showMoreMenu) {
								Image(nsImage: #imageLiteral(resourceName: "btn_more"))
							}
							.buttonStyle(PlainButtonStyle())
							.zIndex(4)
							.padding([.leading, .bottom], 8)
						}
						Button(action: closeApp) {
							Image(nsImage: #imageLiteral(resourceName: "btn_close"))
						}
						.buttonStyle(PlainButtonStyle())
						.zIndex(4)
						.padding([.top, .trailing], 8)
					}
				}
			}
			Button(action: {
				pasteboard.declareTypes([.string], owner: nil)
				pasteboard.setString(convertNSColorToHex(color: self.pickedColor.color), forType: .string)
			}) {
				ZStack {
					RoundedRectangle(cornerRadius: 29)
						.foregroundColor(.white)
						.frame(width:58, height:58)
						//.shadow 추가할 것
					Image(nsImage: #imageLiteral(resourceName: "icn_copy").tinting(with: self.pickedColor.color))
				}
			}
			.buttonStyle(PlainButtonStyle())
			.zIndex(999)
		}
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

func closeApp() {
	exit(0)
}

func showMoreMenu() {
	
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView().environmentObject(PickedColor())
	}
}
