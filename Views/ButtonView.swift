import SwiftUI

struct NavButton {
    var text: String
}

struct ButtonView: View {
    
    let text: String
    
    var body: some View {
        Text("\(text)")
            .font(.system(size: 24))
            .fontWeight(.bold)
            .frame(width: 100, height: 50, alignment: .center)
            .foregroundStyle(.primary)
            .background(.regularMaterial)
    }
}
