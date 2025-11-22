import Foundation
import Combine

struct SessionEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let durationSeconds: Int
    let scene: String
    let sound: String?
}

final class SessionHistoryManager: ObservableObject {
    static let shared = SessionHistoryManager()

    @Published private(set) var entries: [SessionEntry] = []

    private let storageKey = "ZenTV_SessionHistory_Last5"

    private init() {
        load()
    }

    func recordSession(durationSeconds: Int, scene: MeditationScene, sound: SoundManager.SoundType?) {
        let entry = SessionEntry(
            id: UUID(),
            date: Date(),
            durationSeconds: durationSeconds,
            scene: scene.title,
            sound: sound?.displayName
        )

        entries.insert(entry, at: 0)
        if entries.count > 5 {
            entries = Array(entries.prefix(5))
        }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([SessionEntry].self, from: data)
            entries = decoded
        } catch {
            print("[SessionHistoryManager] Failed to load history: \(error)")
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("[SessionHistoryManager] Failed to save history: \(error)")
        }
    }
}
