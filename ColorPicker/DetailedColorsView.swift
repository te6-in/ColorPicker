import SwiftUI

class ColorList: ObservableObject {
	@Published var listColors: [JSONColorInfo] = []
}

struct ColorRow: View {
	var id: Int
	var body: some View {
		HStack(alignment: .center, spacing: 20) {
			Text(String(id))
				.frame(width: 30, height: 20)
			ZStack(alignment: .center) {
				RoundedRectangle(cornerRadius: 12, style: .continuous)
					.frame(width: 150, height: 40)
					.zIndex(0)
					.foregroundColor(Color(colorInfoChart[id]))
				Text(colorList.listColors[id].hex)
					.zIndex(1)
			}
		}
	}
}

struct DetailedColorsMainView: View {
	@EnvironmentObject var colorList: ColorList

    var body: some View {
		List(colorList.listColors) { JSONColorInfo in
			ColorRow(id: Int(JSONColorInfo.id))
		}
    }
}
