import Foundation
import Combine
import AVFoundation

final class SoundManager: ObservableObject {
    enum SoundType {
        case ocean
        case chime
        case rainfall
        case fireplace
        case mountainWind
        case jungle
        case deepFocus
        case calmMind
        case sleepMode

        var fileName: String {
            switch self {
            case .ocean: return "ocean"
            case .chime: return "chime"
            case .rainfall: return "rainfall"
            case .fireplace: return "fireplace"
            case .mountainWind: return "mountain_wind"
            case .jungle: return "jungle"
            case .deepFocus: return "binaural_deep_focus"
            case .calmMind: return "binaural_calm_mind"
            case .sleepMode: return "binaural_sleep_mode"
            }
        }

        var fileExtension: String { "mp3" }

        var displayName: String {
            switch self {
            case .ocean: return "Ocean"
            case .chime: return "Chime"
            case .rainfall: return "Rainfall"
            case .fireplace: return "Fireplace"
            case .mountainWind: return "Mountain Wind"
            case .jungle: return "Jungle Ambience"
            case .deepFocus: return "Deep Focus"
            case .calmMind: return "Calm Mind"
            case .sleepMode: return "Sleep Mode"
            }
        }
    }

    private var player: AVAudioPlayer?

    func play(_ sound: SoundType, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: sound.fileExtension) else {
            print("[SoundManager] Missing sound asset: \(sound.fileName).\(sound.fileExtension)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            if loop {
                player?.numberOfLoops = -1
            }
            player?.volume = 0.6
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("[SoundManager] Failed to play sound: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
