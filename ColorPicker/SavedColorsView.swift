//import SwiftUI
//
//class ListedColors: ObservableObject {
//	@Published var colors: [ColorInfo] = [ColorInfo(index: 0, hex: "000000"), ColorInfo(index: 1, hex: "111111")]
//}
//
//struct SavedColorsListView: View {
//	@EnvironmentObject var listedColors: ListedColors
//
//	var count = self.listedColors.colors.count
//    var body: some View {
//		List(listedColors.colors) { i in
//			Text("\(i): \(listedColors.colors[i].hex)")
//		}
//    }
//}
