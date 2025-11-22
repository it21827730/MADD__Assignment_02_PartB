import Foundation
import Combine

final class MeditationTimer: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var selectedDuration: Int = 300 // default 5 minutes
    @Published var didCompleteSession: Bool = false

    private var timer: AnyCancellable?

    func setDuration(minutes: Int) {
        guard !isRunning else { return }
        selectedDuration = minutes * 60
        remainingSeconds = selectedDuration
    }

    func start() {
        guard !isRunning else { return }
        didCompleteSession = false
        if remainingSeconds == 0 {
            remainingSeconds = selectedDuration
        }
        isRunning = true

        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.didCompleteSession = true
                    self.stop()
                }
            }
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }

    func reset() {
        stop()
        remainingSeconds = selectedDuration
        didCompleteSession = false
    }

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
