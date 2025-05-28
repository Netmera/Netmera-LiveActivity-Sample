import WidgetKit
import SwiftUI

struct MatchScoreWidget: Widget {
    let kind: String = "MatchScoreWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchScoreAttributes.self) { context in
            HStack(spacing: 20) {
                // Home Team
                VStack {
                    Image(context.attributes.homeTeamName.lowercased() == "real madrid" ? "madrid_logo" : "barcelona_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text(context.attributes.homeTeamName)
                        .font(.caption)
                    Text("\(context.state.homeTeamScore)")
                        .font(.title)
                        .bold()
                }
                
                // Match Info
                VStack {
                    Text("\(context.state.matchStatus)'")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    Text("VS")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                }
                
                // Away Team
                VStack {
                    Image(context.attributes.awayTeamName.lowercased() == "real madrid" ? "madrid_logo" : "barcelona_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text(context.attributes.awayTeamName)
                        .font(.caption)
                    Text("\(context.state.awayTeamScore)")
                        .font(.title)
                        .bold()
                }
            }
            .padding()
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            .cornerRadius(16)
            .activityBackgroundTint(Color(red: 0.98, green: 0.98, blue: 0.98))
            .activitySystemActionForegroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(context.attributes.homeTeamName.lowercased() == "real madrid" ? "madrid_logo" : "barcelona_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text("\(context.state.homeTeamScore)")
                            .font(.title2)
                            .bold()
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.awayTeamScore)")
                            .font(.title2)
                            .bold()
                        Image(context.attributes.awayTeamName.lowercased() == "real madrid" ? "madrid_logo" : "barcelona_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.matchStatus)'")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } compactLeading: {
                Text("\(context.state.homeTeamScore)")
                    .font(.title3)
                    .bold()
            } compactTrailing: {
                Text("\(context.state.awayTeamScore)")
                    .font(.title3)
                    .bold()
            } minimal: {
                Text("\(context.state.homeTeamScore)-\(context.state.awayTeamScore)")
                    .font(.caption2)
            }
        }
    }
} 
