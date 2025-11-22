import SwiftUI

struct MeditationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var timer = MeditationTimer()
    @StateObject private var soundManager = SoundManager()

    @Binding var selectedScene: MeditationScene
    @State private var isSoundOn: Bool = false
    @State private var currentSound: SoundManager.SoundType? = nil
    @State private var showCompletionOverlay: Bool = false

    @FocusState private var focusOnStart: Bool
    @FocusState private var focusOnReset: Bool
    @FocusState private var focusOnBackToHome: Bool

    private let durations = [5, 10, 15]

    var body: some View {
        ZStack {
            SceneKitMeditationView(selectedScene: selectedScene)
                .ignoresSafeArea()

            selectedScene.gradient
                .scaleEffect(timer.isRunning ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 30).repeatForever(autoreverses: true), value: timer.isRunning)
                .ignoresSafeArea()
                .opacity(timer.isRunning ? 0.4 : 0.5)

            VStack(spacing: 50) {
                Text("ZenTV Session")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                HStack(alignment: .center, spacing: 60) {
                    BreathingCircleView()

                    VStack(alignment: .leading, spacing: 36) {
                        Text("Duration")
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))

                        HStack(spacing: 24) {
                            ForEach(durations, id: \.self) { minutes in
                                Button(action: {
                                    timer.setDuration(minutes: minutes)
                                }) {
                                    Text("\(minutes) min")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 18)
                                        .background(
                                            RoundedRectangle(cornerRadius: 24)
                                                .fill(timer.selectedDuration == minutes * 60 ? Color.white.opacity(0.25) : Color.black.opacity(0.2))
                                        )
                                }
                                .buttonStyle(FocusButtonStyle())
                                .focusable(true)
                            }
                        }
                        .focusSection()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Timer")
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))

                            Text(timer.formattedTime)
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }

                        VStack(alignment: .leading, spacing: 18) {
                            Text("Ambient Sound & Beats")
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))

                            HStack(spacing: 24) {
                                soundButton(label: "Ocean", type: .ocean)
                                soundButton(label: "Rain", type: .rainfall)
                                soundButton(label: "Fireplace", type: .fireplace)
                            }

                            HStack(spacing: 24) {
                                soundButton(label: "Deep Focus", type: .deepFocus)
                                soundButton(label: "Calm Mind", type: .calmMind)
                                soundButton(label: "Sleep Mode", type: .sleepMode)
                            }
                        }
                    }
                }

                HStack(spacing: 30) {
                    Button(action: {
                        timer.isRunning ? timer.stop() : timer.start()
                    }) {
                        Text(timer.isRunning ? "Pause" : "Start")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.secondary(for: colorScheme))
                            .padding(.horizontal, 60)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                    .buttonStyle(FocusButtonStyle())
                    .focusable(true)
                    .focused($focusOnStart)

                    Button(action: {
                        timer.reset()
                    }) {
                        Text("Reset")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(26)
                    }
                    .buttonStyle(FocusButtonStyle())
                    .focusable(true)
                    .focused($focusOnReset)

                    Button(action: {
                        soundManager.stop()
                        dismiss()
                    }) {
                        Text("Back to Home")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(26)
                    }
                    .buttonStyle(FocusButtonStyle())
                    .focusable(true)
                    .focused($focusOnBackToHome)
                }
                .padding(.bottom, 60)
                .focusSection()
            }
            .padding(.horizontal, 80)

            if showCompletionOverlay {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 24) {
                    Text("Session Complete")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Take a moment to notice how you feel.")
                        .font(.system(size: 28, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .onAppear {
            timer.setDuration(minutes: 5)
            withAnimation {
                showCompletionOverlay = false
            }
            focusOnStart = true
        }
        .onDisappear {
            timer.stop()
            soundManager.stop()
        }
        .onMoveCommand(perform: { direction in
            switch direction {
            case .right:
                if focusOnStart {
                    timer.isRunning ? timer.stop() : timer.start()
                }
            case .left:
                if focusOnReset {
                    timer.reset()
                }
            case .down:
                if focusOnBackToHome {
                    soundManager.stop()
                    dismiss()
                }
            default:
                break
            }
        })
        .onChange(of: timer.didCompleteSession) { completed in
            guard completed else { return }
            isSoundOn = false
            soundManager.play(.chime, loop: false)
            SessionHistoryManager.shared.recordSession(
                durationSeconds: timer.selectedDuration,
                scene: selectedScene,
                sound: currentSound
            )
            withAnimation(.easeOut(duration: 0.5)) {
                showCompletionOverlay = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showCompletionOverlay = false
                }
            }
        }
    }

    private func toggleSound(type: SoundManager.SoundType) {
        if isSoundOn, currentSound == type {
            soundManager.stop()
            isSoundOn = false
            currentSound = nil
        } else {
            let loop = true
            soundManager.play(type, loop: loop)
            isSoundOn = true
            currentSound = type
        }
    }

    private func soundButton(label: String, type: SoundManager.SoundType) -> some View {
        Button(action: {
            toggleSound(type: type)
        }) {
            Text(label)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 26)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(currentSound == type ? Color.white.opacity(0.35) : Color.black.opacity(0.25))
                )
        }
        .buttonStyle(FocusButtonStyle())
        .focusable(true)
    }
}

struct MeditationView_Previews: PreviewProvider {
    @State static var scene: MeditationScene = .lavender

    static var previews: some View {
        MeditationView(selectedScene: $scene)
            .previewLayout(.sizeThatFits)
    }
}
