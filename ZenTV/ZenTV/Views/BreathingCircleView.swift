import SwiftUI

struct BreathingCircleView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isExpanded: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [AppTheme.accent(for: colorScheme), AppTheme.secondary(for: colorScheme)],
                        center: .center,
                        startRadius: 40,
                        endRadius: 260
                    )
                )
                .frame(width: 260, height: 260)
                .scaleEffect(isExpanded ? 1.15 : 0.85)
                .shadow(color: AppTheme.secondary(for: colorScheme).opacity(0.6), radius: 36, x: 0, y: 0)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 4)
                )
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: isExpanded)

            VStack {
                Text(isExpanded ? "Exhale" : "Inhale")
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 8)
                Text("Breathe with the circle")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .onAppear {
            isExpanded = true
        }
    }
}

struct BreathingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingCircleView()
            .frame(width: 800, height: 600)
            .background(AppColors.lightBackground)
    }
}
