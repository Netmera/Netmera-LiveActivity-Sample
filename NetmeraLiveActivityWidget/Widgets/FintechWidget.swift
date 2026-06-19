import WidgetKit
import SwiftUI

struct FintechWidget: Widget {
    let kind: String = "FintechWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FintechAttributes.self) { context in
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                    Text("Portfolio Status")
                        .font(.headline)
                }
                
                Text("$\(String(format: "%.2f", context.state.balance))")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                
                HStack {
                    Image(systemName: context.state.isPositive ? "arrow.up.right" : "arrow.down.right")
                    Text("\(String(format: "%.1f", context.state.changePercentage))%")
                }
                .foregroundColor(context.state.isPositive ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color(red: 0.9, green: 0.3, blue: 0.3))
                
                ProgressView(value: context.state.investmentProgress, total: 100)
                    .tint(Color(red: 0.2, green: 0.8, blue: 0.4))
            }
            .colorScheme(.light)
            .padding()
            .background(Color(red: 0.95, green: 0.98, blue: 0.95))
            .cornerRadius(16)
            .activityBackgroundTint(Color(red: 0.95, green: 0.98, blue: 0.95))
            .activitySystemActionForegroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text("Portfolio")
                            .font(.headline)
                        Text("$\(String(format: "%.2f", context.state.balance))")
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(String(format: "%.1f", context.state.changePercentage))%")
                            .font(.title2)
                            .bold()
                            .foregroundColor(context.state.isPositive ? .green : .red)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: context.state.investmentProgress, total: 100)
                        .tint(.green)
                }
            } compactLeading: {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("$\(String(format: "%.1f", context.state.balance))")
                    .font(.caption2)
            } minimal: {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
} 
