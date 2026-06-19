import WidgetKit
import SwiftUI

struct ShakeAndWinWidget: Widget {
    let kind: String = "ShakeAndWinWidget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShakeAndWinAttributes.self) { context in
            let remaining = context.state.endDate - Date().timeIntervalSince1970
            let isUrgent  = remaining > 0 && remaining < 3600

            VStack(alignment: .leading, spacing: 8) {
                // Top row: icon + campaign name + displayLabel + countdown
                HStack(alignment: .center) {
                    Image(systemName: "iphone.radiowaves.left.and.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isUrgent ? Color(red: 0.85, green: 0.15, blue: 0.1) : Color(red: 1.0, green: 0.55, blue: 0.0))
                    Text(context.attributes.campaignName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.08, blue: 0.04))
                    Spacer()
                    Text(context.state.displayLabel)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(isUrgent ? Color(red: 0.85, green: 0.15, blue: 0.1) : Color(red: 1.0, green: 0.55, blue: 0.0))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            (isUrgent ? Color(red: 0.85, green: 0.15, blue: 0.1) : Color(red: 1.0, green: 0.55, blue: 0.0))
                                .opacity(0.12)
                        )
                        .cornerRadius(12)
                }

                // Title: main message
                Text(context.state.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.12, green: 0.08, blue: 0.04))
                    .lineLimit(2)

                // Bottom row: statusText + countdown + lastUpdatedText
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.statusText)
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                        Text(context.state.lastUpdatedText)
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.35))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(countdownText(from: context.state.endDate))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(isUrgent ? Color(red: 0.85, green: 0.15, blue: 0.1) : Color(red: 0.12, green: 0.08, blue: 0.04))
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        Text("kaldı")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                    }
                }
            }
            .colorScheme(.light)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isUrgent ? Color(red: 1.0, green: 0.94, blue: 0.93) : Color(red: 1.0, green: 0.96, blue: 0.88))
            .cornerRadius(16)
            .activityBackgroundTint(isUrgent ? Color(red: 1.0, green: 0.94, blue: 0.93) : Color(red: 1.0, green: 0.96, blue: 0.88))
            .activitySystemActionForegroundColor(isUrgent ? Color(red: 0.85, green: 0.15, blue: 0.1) : Color(red: 1.0, green: 0.55, blue: 0.0))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.attributes.campaignName)
                                .font(.caption)
                                .bold()
                            Text(context.state.statusText)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(countdownText(from: context.state.endDate))
                            .font(.title3)
                            .bold()
                        Text("kaldı")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.displayLabel)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            } compactLeading: {
                Image(systemName: "iphone.radiowaves.left.and.right")
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            } compactTrailing: {
                Text(countdownText(from: context.state.endDate))
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            } minimal: {
                Image(systemName: "iphone.radiowaves.left.and.right")
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            }
        }
    }

    private func countdownText(from endDate: Double) -> String {
        let remaining = endDate - Date().timeIntervalSince1970
        guard remaining > 0 else { return "Süre doldu" }

        let total   = Int(remaining)
        let hours   = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60

        if hours > 0 {
            return "\(hours)s \(minutes)dk"
        } else if minutes > 0 {
            return "\(minutes)dk \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}
