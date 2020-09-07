//
//  MainView.swift
//  ColorPicker2
//
//  Created by 찬휘 on 9. 3..
//  Copyright © 2020 주찬휘. All rights reserved.
//

import SwiftUI

extension NSImage {
    func tint(with tintColor: NSColor) -> NSImage {
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
	@Published var color: NSColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

class Saved9Colors: ObservableObject {
	@Published var colors: [NSColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
}

struct SavedSingleColor: View {
	var num: Int
	var color: NSColor
	var body: some View {
		Button(action: { copySavedColor(num: self.num) }) {
			ZStack {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.frame(width: 32, height: 32)
					.foregroundColor(Color(color).opacity(0.35))
					.zIndex(1)
				RoundedRectangle(cornerRadius: 7, style: .continuous)
					.frame(width: 26, height: 26)
					.foregroundColor(Color(color))
					.zIndex(2)
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct SavedColorsView: View {
	
	@EnvironmentObject var saved9Colors: Saved9Colors
	
	var body: some View {
		ZStack {
			HStack(spacing: 0) {
				Rectangle()
					.frame(width: 9, height: 72)
					.opacity(0)
				VStack(spacing: 8) {
					HStack(spacing: 8) {
						SavedSingleColor(num: 1, color: saved9Colors.colors[0])
						SavedSingleColor(num: 2, color: saved9Colors.colors[1])
						SavedSingleColor(num: 3, color: saved9Colors.colors[2])
						SavedSingleColor(num: 4, color: saved9Colors.colors[3])
						SavedSingleColor(num: 5, color: saved9Colors.colors[4])
					}
					HStack(spacing: 8) {
						SavedSingleColor(num: 6, color: saved9Colors.colors[5])
						SavedSingleColor(num: 7, color: saved9Colors.colors[6])
						SavedSingleColor(num: 8, color: saved9Colors.colors[7])
						SavedSingleColor(num: 9, color: saved9Colors.colors[8])
						Button(action: showMoreColors) {
							ZStack {
								RoundedRectangle(cornerRadius: 10, style: .continuous)
									.frame(width: 32, height: 32)
									.foregroundColor(Color(.black))
									.zIndex(1)
									.opacity(0.65)
								Image(nsImage: #imageLiteral(resourceName: "icn_more"))
									.opacity(0.9)
							}
						}
					.buttonStyle(PlainButtonStyle())
					}
				}
			}
		}
	}
}

struct CopyButtonView: View {
	@EnvironmentObject var pickedColor: PickedColor
	var body: some View {
		Button(action: {
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(convertNSColorToHex(color: self.pickedColor.color), forType: .string)
		}) {
			ZStack {
				RoundedRectangle(cornerRadius: 29)
					.foregroundColor(.white)
					.frame(width:58, height:58)
					//.shadow 추가할 것
				Image(nsImage: #imageLiteral(resourceName: "icn_copy").tint(with: self.pickedColor.color))
			}
		}
		.buttonStyle(PlainButtonStyle())
		.zIndex(999)
	}
}

struct MainView: View {
	
	@EnvironmentObject var pickedColor: PickedColor
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
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
							.zIndex(3)
						Image(nsImage: #imageLiteral(resourceName: "Shape"))
							.zIndex(2)
						ZStack(alignment: .topTrailing) {
							ZStack(alignment: .bottomLeading) {
								RoundedRectangle(cornerRadius: 12, style: .continuous)
									.frame(width: 250, height: 180)
									.foregroundColor(Color(pickedColor.color))
									.zIndex(1)
								Button(action: showMoreMenu) {
									Image(nsImage: #imageLiteral(resourceName: "btn_plus"))
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
				CopyButtonView()
			}
			SavedColorsView().environmentObject(saved9Colors)
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

func copySavedColor(num: Int) {
	pasteboard.declareTypes([.string], owner: nil)
	pasteboard.setString(convertNSColorToHex(color: saved9Colors.colors[num-1]), forType: .string)
}

func showMoreColors() {
	
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		SavedColorsView()
	}
}
