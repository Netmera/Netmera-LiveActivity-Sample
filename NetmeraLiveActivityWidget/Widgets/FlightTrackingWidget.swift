import WidgetKit
import SwiftUI

struct FlightTrackingWidget: Widget {
    let kind: String = "FlightTrackingWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlightTrackingAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "airplane")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    Text("Flight Tracking")
                        .font(.headline)
                }
                
                HStack {
                    Text(context.attributes.flightNumber)
                        .font(.subheadline)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(context.attributes.departureCity)
                            .font(.caption)
                        Text(context.state.departureTime, style: .time)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(context.attributes.arrivalCity)
                            .font(.caption)
                        Text(context.state.arrivalTime, style: .time)
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    Text("Gate \(context.state.gateNumber)")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(red: 0.98, green: 0.97, blue: 1.0))
            .cornerRadius(16)
            .activityBackgroundTint(Color(red: 0.98, green: 0.97, blue: 1.0))
            .activitySystemActionForegroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.flightNumber)
                            .font(.headline)
                        Text("Gate \(context.state.gateNumber)")
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(context.state.departureTime, style: .time)
                            .font(.subheadline)
                        Text(context.state.arrivalTime, style: .time)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text(context.attributes.departureCity)
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        Text(context.attributes.arrivalCity)
                    }
                    .font(.caption)
                }
            } compactLeading: {
                Text(context.attributes.flightNumber)
                    .font(.caption2)
            } compactTrailing: {
                Text(context.state.departureTime, style: .time)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "airplane")
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
        }
    }
} 
