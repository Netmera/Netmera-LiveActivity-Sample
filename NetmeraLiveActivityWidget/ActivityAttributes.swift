import Foundation
import ActivityKit
import NetmeraLiveActivity

// Make sure this file is added to both main app and widget extension targets via "Target Membership".
// Otherwise, app cannot access ActivityAttributes defined here which will cause build errors.

// MARK: - Match Score Activity

struct MatchScoreAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    // Required for Netmera integration
    // `netmeraGroupId` is mandatory and must be unique for each activity
    // Used by Netmera to group identical activities across users and update them with a single request
    var netmeraGroupId: String?

    var homeTeamName: String
    var awayTeamName: String
    var homeTeamLogo: String
    var awayTeamLogo: String
    
    public static var activityIdentifier: String = "MatchScoreAttributes"
    
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var matchStatus: String
       
    }
}

// MARK: - Delivery Tracking Activity

struct DeliveryTrackingAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    
    public static var activityIdentifier: String = "DeliveryTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        var deliveryStatus: String
        var remainingStops: Int
        var estimatedDeliveryTime: Date
        var courierName: String
    }
}

// MARK: - Public Transport Activity

struct PublicTransportAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    
    public static var activityIdentifier: String = "PublicTransportAttributes"
    
    public struct ContentState: Codable, Hashable {
        var vehicleNumber: String
        var remainingTime: Int // in minutes
        var stopName: String
        var vehicleType: String // "bus" or "train"
    }
}

// MARK: - Flight Tracking Activity

struct FlightTrackingAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    var flightNumber: String
    var arrivalCity: String
    var airlineLogo: String
    var departureCity: String
    
    public static var activityIdentifier: String = "FlightTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        
        var departureTime: Date
        var arrivalTime: Date
        var gateNumber: String
        
    }
}

// MARK: - FinTech Activity

struct FintechAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    
    public static var activityIdentifier: String = "FintechAttributes"
    
    public struct ContentState: Codable, Hashable {
        var balance: Double
        var changePercentage: Double
        var isPositive: Bool
        var investmentProgress: Double
    }
}

// MARK: - Shake And Win Activity

struct ShakeAndWinAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?

    let campaignName: String
    let groupId: String
    let deeplink: String

    public static var activityIdentifier: String = "ShakeAndWinAttributes"

    public struct ContentState: Codable, Hashable {
        let title: String
        let endDate: Double
        let displayLabel: String
        let statusText: String
        var lastUpdatedText: String
    }
}

/// Display ladder for the remaining time, derived from `endDate` at render time.
///
///   > 30 min  → fixed "1 sa 1 dk" snapshot of the remaining time, dark
///   15–30 min → snapshot again ("30 dk" at the step), orange
///   0–15 min  → live mm:ss countdown, red   — iOS ticks it every second
///   0         → "Süre doldu" (and the activity is dismissed)
///
/// Shared by the widget (what to draw) and the app (when the next re-render is needed).
public enum ShakeAndWinStage: Equatable {
    case remaining
    case halfHour
    case countdown
    case ended

    /// `tolerance` lets a render that fires a hair before a boundary land on the new stage.
    public static func at(endDate: Date, now: Date = Date(), tolerance: TimeInterval = 2) -> ShakeAndWinStage {
        let remaining = endDate.timeIntervalSince(now) - tolerance
        if remaining <= 0      { return .ended }
        if remaining <= 900    { return .countdown }
        if remaining <= 1800   { return .halfHour }
        return .remaining
    }

    /// Static label, or nil when the live timer should be shown instead.
    /// For `.remaining` and `.halfHour` it is a snapshot of the time left at render — e.g. "8 sa",
    /// "1 sa 1 dk", "32 dk" — which reads "30 dk" when the orange step fires at its boundary, and the
    /// true value (e.g. "20 dk") when an activity is started inside that window.
    public func label(endDate: Date, now: Date = Date()) -> String? {
        switch self {
        case .remaining, .halfHour:
            let minutes = max(1, Int((endDate.timeIntervalSince(now) / 60).rounded(.up)))
            let h = minutes / 60, m = minutes % 60
            switch (h, m) {
            case (0, _): return "\(m) dk"
            case (_, 0): return "\(h) sa"
            default:     return "\(h) sa \(m) dk"
            }
        case .countdown: return nil
        case .ended:     return "Süre doldu"
        }
    }

    /// The moment this stage ends and the next one should be drawn.
    public func nextTransition(endDate: Date) -> Date? {
        switch self {
        case .remaining: return endDate.addingTimeInterval(-1800)
        case .halfHour:  return endDate.addingTimeInterval(-900)
        case .countdown: return endDate
        case .ended:     return nil
        }
    }
}
