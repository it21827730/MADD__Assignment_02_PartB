import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var selectedScene: MeditationScene = .lavender
    @State private var showScenePicker: Bool = false
    @State private var showHistory: Bool = false
    @State private var backgroundDrift: Bool = false
    @State private var navigateToMeditation: Bool = false
    @State private var navigateToHistory: Bool = false

    // Focus management for tvOS to ensure a default focused control.
    @FocusState private var focusOnStart: Bool
    @FocusState private var focusOnChooseScene: Bool
    @FocusState private var focusOnHistory: Bool

    private let quotes: [String] = [
        "Breathe in calm, breathe out tension.",
        "Stillness is where clarity lives.",
        "You are exactly where you need to be.",
        "Inhale peace, exhale worry.",
        "Let your mind settle like snow in a globe."
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                animatedBackground

                VStack(spacing: 60) {
                    NavigationLink(
                        destination: MeditationView(selectedScene: $selectedScene),
                        isActive: $navigateToMeditation
                    ) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()

                    NavigationLink(
                        destination: HistoryView(),
                        isActive: $navigateToHistory
                    ) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()

                    VStack(spacing: 20) {
                        Text("ZenTV – Big Screen Meditation")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.secondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .shadow(color: .white.opacity(0.6), radius: 12, x: 0, y: 0)

                        Text("Gentle breathing, ambient scenes, and soft sound for your living room.")
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .foregroundColor(.primary.opacity(0.8))

                        if let quote = quotes.randomElement() {
                            Text("\"\(quote)\"")
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                                .foregroundColor(.primary.opacity(0.7))
                                .padding(.top, 8)
                        }
                    }
                    .padding(.top, 80)

                    HStack(spacing: 40) {
                        NavigationLink {
                            MeditationView(selectedScene: $selectedScene)
                        } label: {
                            VStack(spacing: 12) {
                                Text("Start Meditation")
                                    .font(.system(size: 38, weight: .bold, design: .rounded))
                                Text("Begin a guided breathing session")
                                    .font(.system(size: 22, weight: .regular, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(width: 420, height: 140)
                            .background(AppTheme.secondary(for: colorScheme))
                            .cornerRadius(40)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(FocusButtonStyle())
                        .focusable(true)
                        // Make this the default focused control when the view appears / regains focus.
                        .focused($focusOnStart)

                        Button(action: {
                            showScenePicker = true
                        }) {
                            VStack(spacing: 12) {
                                Text("Choose Scene")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                Text(selectedScene.title)
                                    .font(.system(size: 22, weight: .regular, design: .rounded))
                            }
                            .foregroundColor(AppTheme.secondary(for: colorScheme))
                            .frame(width: 420, height: 140)
                            .background(Color.white)
                            .cornerRadius(40)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(FocusButtonStyle())
                        .focusable(true)
                        .focused($focusOnChooseScene)

                        NavigationLink {
                            HistoryView()
                        } label: {
                            VStack(spacing: 12) {
                                Text("History")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                Text("Last 5 sessions")
                                    .font(.system(size: 22, weight: .regular, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(width: 360, height: 140)
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(40)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(FocusButtonStyle())
                        .focusable(true)
                        .focused($focusOnHistory)
                    }
                    .focusSection()

                    Spacer()
                }
                .padding(.horizontal, 80)
            }
            .onMoveCommand(perform: { direction in
                switch direction {
                case .right:
                    navigateToMeditation = true
                case .left:
                    showScenePicker = true
                case .down:
                    navigateToHistory = true
                default:
                    break
                }
            })
            .sheet(isPresented: $showScenePicker, onDismiss: {
                // After dismissing the sheet, restore focus to a sensible default.
                focusOnStart = true
            }) {
                ScenePickerView(selectedScene: $selectedScene) {
                    // When a scene is chosen from the sheet, navigate to meditation.
                    // We do this by presenting MeditationView on top of HomeView using NavigationLink,
                    // so here we simply dismiss the sheet; the user can press Start Meditation.
                }
            }
            .onAppear {
                backgroundDrift = true
                // Ensure a default focused element when the view first appears.
                focusOnStart = true
            }
        }
    }

    private var animatedBackground: some View {
        GeometryReader { proxy in
            let size = proxy.size

            LinearGradient(
                colors: [AppTheme.background(for: colorScheme), AppTheme.secondary(for: colorScheme).opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                RadialGradient(
                    colors: [AppTheme.accent(for: colorScheme).opacity(0.25), .clear],
                    center: .topTrailing,
                    startRadius: 80,
                    endRadius: max(size.width, size.height)
                )
                .blur(radius: 40)
                .offset(x: backgroundDrift ? 40 : -40, y: backgroundDrift ? 20 : -20)
                .animation(
                    .easeInOut(duration: 20)
                    .repeatForever(autoreverses: true),
                    value: backgroundDrift
                )
            )
            .ignoresSafeArea()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
