ZenTV
ZenTV is a tvOS meditation app designed for the big screen. It combines ambient 3D scenes, a guided breathing visual, soft background sounds, and a simple timer to help you relax in your living room.

Features
•	Home screen
•	Title section with tagline and rotating calm quote.
•	Primary actions:
•	Start Meditation – opens the main meditation session.
•	Choose Scene – select a visual meditation scene.
•	History – view the last 5 completed sessions.
•	tvOS focus support using  FocusState  and custom FocusButtonStyle so the default button and navigation feel natural with the Siri Remote.
•	Meditation session
•	Scenes rendered via SceneKitMeditationView and overlaid with a soft animated gradient based on the chosen MeditationScene.
•	Breathing circle (BreathingCircleView) to visually guide inhale/exhale.
•	Timer
•	Preset durations: 5, 10, 15 minutes.
•	Start / pause, reset, and formatted countdown (MM:SS).
•	Uses MeditationTimer (Combine + Timer.publish) to tick once per second.
•	Ambient sounds
•	Ocean, Rainfall, Fireplace, Binaural Deep Focus, Calm Mind, Sleep Mode.
•	Implemented with AVAudioPlayer via SoundManager.
•	Tapping a sound toggles looping playback; switching sounds cross‑changes the current sound.
•	Session completion
•	When the timer finishes:
•	Plays a short chime.
•	Shows a “Session Complete” overlay.
•	Records the session into history through SessionHistoryManager.
•	Scene selection
•	ScenePickerView shows all MeditationScene cases in a horizontal scrollable list.
•	Each scene has:
•	Title and description.
•	A dedicated gradient background (AppTheme + AppColors).
•	Selecting a scene updates the binding and dismisses the picker.
•	Session history
•	HistoryView shows the 5 most recent sessions:
•	Date & time.
•	Duration (minutes).
•	Scene title.
•	Sound used (or “Silent”).
•	Backed by SessionHistoryManager with UserDefaults persistence so sessions survive app restarts.
•	Theming
•	AppTheme and AppColors provide light/dark background, accent and secondary colors.
•	Gradients and typography are optimized for a TV screen (large fonts, high contrast).

Architecture
•	Entry point
•	ZenTVApp ( main ) creates a WindowGroup and loads HomeView.
•	Main SwiftUI views
•	HomeView – landing screen, navigation hub.
•	MeditationView – core session screen (timer, breathing, sounds, completion overlay).
•	ScenePickerView – scene selection sheet.
•	HistoryView – read‑only list of recent sessions.
•	SceneCard, BreathingCircleView – reusable UI components.
•	State & managers
•	MeditationTimer – observable timer with duration, remaining seconds, running state and completion flag.
•	SoundManager – wraps AVAudioPlayer to play/loop ambient sounds and chimes.
•	SessionHistoryManager – singleton that manages SessionEntry list, saves/loads via UserDefaults.
•	MeditationScene – enum describing available scenes with title, description and gradient.
•	Platform / frameworks
•	Swift 5+
•	SwiftUI for UI and navigation.
•	Combine for timer and observable objects.
•	AVFoundation for audio playback.
•	Target platform: tvOS (Apple TV).

Requirements
•	Xcode (version matching your current campus/tooling requirements, e.g. Xcode 15+).
•	tvOS SDK.
•	Apple TV simulator or physical Apple TV for testing.

Getting Started
•	Open the project
•	Open ZenTV.xcodeproj or ZenTV.xcworkspace in Xcode.
•	Select the target
•	Choose the ZenTV tvOS target.
•	Select an Apple TV Simulator device (e.g. “Apple TV 4K”).
•	Build & run
•	Press Run (⌘R).
•	The app will launch into HomeView on the simulator or device.

Using the App
•	Home
•	Use the Siri Remote / simulator remote to move focus between:
•	Start Meditation
•	Choose Scene
•	History
•	Start a session
•	On Start Meditation, press Select to open MeditationView.
•	Choose a duration (5 / 10 / 15 minutes).
•	Press Start to begin the timer and breathing animation.
•	Optionally enable a sound (Ocean, Rain, Fireplace, Deep Focus, etc.).
•	Complete / end
•	When the timer finishes:
•	A chime sound plays.
•	A completion overlay appears.
•	The session is automatically saved to history.
•	You can also:
•	Pause / Start to control the timer.
•	Reset to restart the countdown.
•	Back to Home to stop sound and return.
•	Change scenes
•	From Home, choose Choose Scene to open the scene picker.
•	Scroll through the cards and select a scene to use as the session backdrop.
•	View history
•	From Home, choose History.
•	See up to the last 5 sessions with date, duration, selected scene and sound.

Code Structure (High Level)
•	ZenTVApp.swift App entry point; loads HomeView.
•	Views/
•	HomeView.swift – main menu UI and navigation.
•	MeditationView.swift – session UI, timer, sounds, completion overlay.
•	ScenePickerView.swift – scene selection.
•	HistoryView.swift – recent sessions list.
•	BreathingCircleView.swift – breathing animation.
•	SceneCard.swift – card UI for scenes.
•	SceneKitMeditationView.swift – wrapper for 3D scenes (SceneKit).
•	Managers/
•	MeditationTimer.swift – timer logic with Combine.
•	SoundManager.swift – audio handling with AVAudioPlayer.
•	SessionHistoryManager.swift – persistent session history.
•	Colors/
•	AppTheme.swift – scene model (MeditationScene) and theme helpers.
•	AppColors.swift – color palette definitions.
•	Assets/
•	App icons, scene textures, and sound files (.mp3) referenced by SoundManager.

Possible Future Enhancements
•	Add more scenes and ambient sound types.
•	Support fully custom session durations.
•	Add basic statistics (total time meditated, streaks).
•	Localize text for multiple languages.
