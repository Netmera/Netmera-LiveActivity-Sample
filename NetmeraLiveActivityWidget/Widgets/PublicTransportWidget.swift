import WidgetKit
import SwiftUI

struct PublicTransportWidget: Widget {
    let kind: String = "PublicTransportWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PublicTransportAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.2))
                    Text("Public Transport")
                        .font(.headline)
                }
                
                Text("Vehicle: \(context.state.vehicleNumber)")
                    .font(.subheadline)
                
                Text("Stop: \(context.state.stopName)")
                    .font(.subheadline)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.2))
                    Text("Match Status \(context.state.remainingTime) ")
                        .font(.caption)
                }
            }
            .colorScheme(.light)
            .padding()
            .background(Color(red: 1.0, green: 0.97, blue: 0.95))
            .cornerRadius(16)
            .activityBackgroundTint(Color(red: 1.0, green: 0.97, blue: 0.95))
            .activitySystemActionForegroundColor(Color(red: 0.8, green: 0.4, blue: 0.2))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.state.vehicleNumber)
                            .font(.headline)
                        Text(context.state.stopName)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("Arriving in")
                            .font(.caption)
                        Text("\(context.state.remainingTime) min")
                            .font(.subheadline)
                            .bold()
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                        .foregroundColor(.green)
                }
            } compactLeading: {
                Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("\(context.state.remainingTime)m")
                    .font(.caption2)
            } minimal: {
                Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                    .foregroundColor(.green)
            }
        }
    }
} 
