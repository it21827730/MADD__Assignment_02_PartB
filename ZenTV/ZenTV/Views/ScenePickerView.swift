import SwiftUI

struct ScenePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @Binding var selectedScene: MeditationScene
    var onSceneChosen: (() -> Void)? = nil

    @FocusState private var focusOnBack: Bool
    @FocusState private var focusedScene: MeditationScene?

    var body: some View {
        ZStack {
            AppTheme.softBackgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 40) {
                Text("Choose Scene")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.secondary(for: colorScheme))
                    .padding(.top, 80)

                Text("Select a calming backdrop for your meditation.")
                    .font(.system(size: 30, weight: .regular, design: .rounded))
                    .foregroundColor(.primary.opacity(0.8))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        ForEach(MeditationScene.allCases) { scene in
                            Button(action: {
                                selectedScene = scene
                                onSceneChosen?()
                                dismiss()
                            }) {
                                SceneCard(scene: scene, isSelected: selectedScene == scene)
                            }
                            .buttonStyle(FocusButtonStyle())
                            .focusable(true)
                            .focused($focusedScene, equals: scene)
                        }
                    }
                    .padding(.horizontal, 60)
                    .focusSection()
                }

                Spacer()

                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(AppTheme.secondary(for: colorScheme))
                    .cornerRadius(28)
                    .buttonStyle(FocusButtonStyle())
                    .focusable(true)
                    .focused($focusOnBack)

                    Spacer()
                }
                .padding(.bottom, 80)
            }
            .padding(.horizontal, 80)
        }
        .onAppear {
            focusedScene = selectedScene
        }
        .onMoveCommand(perform: { direction in
            if direction == .right {
                if focusOnBack {
                    dismiss()
                } else if let scene = focusedScene {
                    selectedScene = scene
                    onSceneChosen?()
                    dismiss()
                }
            }
        })
    }
}

struct ScenePickerView_Previews: PreviewProvider {
    @State static var scene: MeditationScene = .lavender

    static var previews: some View {
        ScenePickerView(selectedScene: $scene)
            .previewLayout(.sizeThatFits)
    }
}
