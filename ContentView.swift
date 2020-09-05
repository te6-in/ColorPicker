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

class ColorCode: ObservableObject {
	@Published var string = "123456"
}

struct MainView: View {
	
	@EnvironmentObject var colorCode: ColorCode
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			ZStack(alignment: .topLeading) {
				Rectangle()
					.frame(width: 258, height: 188)
					.opacity(0)
					.zIndex(0)
				ZStack(alignment: .topLeading) {
					Text(self.colorCode.string)
						.font(.largeTitle)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.frame(width: 250, height: 180)
						.foregroundColor(.white)
						.zIndex(2)
						.environmentObject(colorCode)
					Image(nsImage: #imageLiteral(resourceName: "Shape"))
						.zIndex(3)
					ZStack(alignment: .topTrailing) {
						ZStack(alignment: .bottomLeading) {
							RoundedRectangle(cornerRadius: 10)
								.frame(width: 250, height: 180)
								.foregroundColor(Color(hex: self.colorCode.string))
								.zIndex(1)
								.environmentObject(colorCode)
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
				pasteboard.setString(self.colorCode.string, forType: .string)
			}) {
				ZStack {
					RoundedRectangle(cornerRadius: 29)
						.foregroundColor(.white)
						.frame(width:58, height:58)
					//.shadow 추가할 것
					Image(nsImage: #imageLiteral(resourceName: "icn_copy"))
				}
			}
			.buttonStyle(PlainButtonStyle())
			.zIndex(999)
		}
	}
}

func getColor() -> String {
	var mouseLocation: NSPoint { NSEvent.mouseLocation }
	
	var color: NSColor?
	
	let x: CGFloat = floor(mouseLocation.x)
	let y: CGFloat = (NSScreen.main!.frame.size.height) - floor(mouseLocation.y)
	
	let pixel: CGImage = CGWindowListCreateImage(CGRect(x: x, y: y, width: 1, height: 1),
												 .optionAll,
												 kCGNullWindowID,
												 .nominalResolution)!
	
	
	let bitmap = NSBitmapImageRep(cgImage: pixel)
	bitmap.colorSpaceName = NSColorSpaceName.deviceRGB
	color = bitmap.colorAt(x: 0, y: 0)
	
	var r: CGFloat = 0
	var g: CGFloat = 0
	var b: CGFloat = 0
	var a: CGFloat = 0
	
	color?.getRed(&r, green: &g, blue: &b, alpha: &a)
	
	let hexColor = String(format: "%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
	
	return hexColor
}

func closeApp() {
	exit(0)
}

func showMoreMenu() {
	
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView().environmentObject(ColorCode())
	}
}
