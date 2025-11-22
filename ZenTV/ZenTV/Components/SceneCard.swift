import SwiftUI

struct SceneCard: View {
    let scene: MeditationScene
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            scene.gradient
                .frame(width: 420, height: 260)
                .cornerRadius(32)

            VStack(alignment: .leading, spacing: 8) {
                Text(scene.title)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text(scene.description)
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .opacity(0.85)
            }
            .foregroundColor(.white)
            .padding(24)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(isSelected ? Color.white.opacity(0.9) : Color.white.opacity(0.2), lineWidth: 3)
        )
    }
}

struct SceneCard_Previews: PreviewProvider {
    static var previews: some View {
        SceneCard(scene: .lavender, isSelected: true)
            .previewLayout(.sizeThatFits)
    }
}
