import SwiftUI

struct HistoryView: View {
    @ObservedObject private var history = SessionHistoryManager.shared

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Recent Sessions")
                .font(.system(size: 50, weight: .bold, design: .rounded))

            if history.entries.isEmpty {
                Text("No sessions yet. Start a meditation to build your history.")
                    .font(.system(size: 28, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            } else {
                ForEach(history.entries) { entry in
                    HStack(spacing: 40) {
                        Text(dateFormatter.string(from: entry.date))
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .frame(width: 360, alignment: .leading)

                        Text("\(entry.durationSeconds / 60) min")
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                            .frame(width: 120, alignment: .leading)

                        Text(entry.scene)
                            .font(.system(size: 26, weight: .regular, design: .rounded))
                            .frame(width: 260, alignment: .leading)

                        Text(entry.sound ?? "Silent")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(60)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .previewLayout(.sizeThatFits)
    }
}
