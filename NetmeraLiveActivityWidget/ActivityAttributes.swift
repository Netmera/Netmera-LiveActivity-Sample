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
        let lastUpdatedText: String
    }
}
