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

//메인뷰에 보여주기 위함
class NewColor: ObservableObject {
	@Published var color: NSColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	@Published var hex: String = "000000"
}
//SavedColorsView에 보여주기 위함
class Saved9Colors: ObservableObject {
	@Published var colors: [NSColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
	@Published var isAvailable: [Bool] = [false, false, false, false, false, false, false, false, false]
}

struct SavedSingleColor: View {
	var id: Int
	var color: NSColor
	var body: some View {
		Button(action: { copySavedColor(num: self.id) }) {
			ZStack {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.frame(width: 32, height: 32)
					.foregroundColor(Color(color).opacity(0.6))
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

struct ShowMoreColorButton: View {
	var body: some View {
		Button(action: showMoreColors) {
			ZStack {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.frame(width: 32, height: 32)
					.foregroundColor(Color(.black))
					.zIndex(1)
					.opacity(0.65)
				Image(nsImage: #imageLiteral(resourceName: "icn_more"))
					.opacity(0.9)
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
			HStack(alignment: .top, spacing: 0) {
				Rectangle()
					.frame(width: 9, height: 72)
					.opacity(0)
				VStack(alignment: .leading) {
					HStack(alignment: .top, spacing: 8) {
						if self.saved9Colors.isAvailable[0] == true {
							SavedSingleColor(id: 0, color: self.saved9Colors.colors[0])
						}
						if self.saved9Colors.isAvailable[1] == true {
							SavedSingleColor(id: 1, color: self.saved9Colors.colors[1])
						}
						if self.saved9Colors.isAvailable[2] == true {
							SavedSingleColor(id: 2, color: self.saved9Colors.colors[2])
						}
						if self.saved9Colors.isAvailable[3] == true {
							SavedSingleColor(id: 3, color: self.saved9Colors.colors[3])
						}
						if self.saved9Colors.isAvailable[4] == true {
							SavedSingleColor(id: 4, color: self.saved9Colors.colors[4])
						}
						if self.saved9Colors.isAvailable[4] == false {
							ShowMoreColorButton()
						}
					}
					HStack(alignment: .top, spacing: 8) {
						if self.saved9Colors.isAvailable[5] == true {
							SavedSingleColor(id: 5, color: self.saved9Colors.colors[5])
						}
						if self.saved9Colors.isAvailable[6] == true {
							SavedSingleColor(id: 6, color: self.saved9Colors.colors[6])
						}
						if self.saved9Colors.isAvailable[7] == true {
							SavedSingleColor(id: 7, color: self.saved9Colors.colors[7])
						}
						if self.saved9Colors.isAvailable[8] == true {
							SavedSingleColor(id: 8, color: self.saved9Colors.colors[8])
						}
						if self.saved9Colors.isAvailable[4] == true {
							ShowMoreColorButton()
						}
					}
				}
			}
		}
	}
}

struct CopyButtonView: View {
	@EnvironmentObject var newColor: NewColor
	var body: some View {
		Button(action: {
			clipBoard.declareTypes([.string], owner: nil)
			clipBoard.setString(newColor.hex, forType: .string)
		}) {
			ZStack {
				RoundedRectangle(cornerRadius: 29)
					.foregroundColor(.white)
					.frame(width:58, height:58)
					//.shadow 추가할 것
				Image(nsImage: #imageLiteral(resourceName: "icn_copy").tint(with: self.newColor.color))
			}
		}
		.buttonStyle(PlainButtonStyle())
		.zIndex(999)
	}
}

struct MainView: View {
	
	@EnvironmentObject var newColor: NewColor
	@State var showMore: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			ZStack(alignment: .bottomTrailing) {
				ZStack(alignment: .topLeading) {
					Rectangle()
						.frame(width: 258, height: 188)
						.opacity(0)
						.zIndex(0)
					ZStack(alignment: .topLeading) {
						Text(newColor.hex)
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
									.foregroundColor(Color(newColor.color))
									.zIndex(1)
								Button(action: { self.showMore.toggle() }) {
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
			if showMore == true {
				SavedColorsView().environmentObject(saved9Colors)
			}
		}
	}
}
