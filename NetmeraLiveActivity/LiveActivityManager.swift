import NetmeraLiveActivity
import NetmeraCore
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var matchActivity: Activity<MatchScoreAttributes>?
    private var deliveryActivity: Activity<DeliveryTrackingAttributes>?
    private var transportActivity: Activity<PublicTransportAttributes>?
    private var flightActivity: Activity<FlightTrackingAttributes>?
    private var fintechActivity: Activity<FintechAttributes>?
    
    init() {}
    
    // MARK: - Registration Methods
    @available(iOS 17.2, *)
    func registerForMatchScoreActivity() {
        Netmera.register(forType: Activity<MatchScoreAttributes>.self,
                         name: MatchScoreAttributes.activityIdentifier)
    }

    @available(iOS 17.2, *)
    func registerForDeliveryTrackingActivity() {
        Netmera.register(forType: Activity<DeliveryTrackingAttributes>.self,
                         name: DeliveryTrackingAttributes.activityIdentifier)
    }

    @available(iOS 17.2, *)
    func registerForFintechActivity() {
        Netmera.register(forType: Activity<FintechAttributes>.self,
                         name: FintechAttributes.activityIdentifier)
    }

    @available(iOS 17.2, *)
    func registerForFlightTrackingActivity() {
        Netmera.register(forType: Activity<FlightTrackingAttributes>.self,
                         name: FlightTrackingAttributes.activityIdentifier)
    }

    @available(iOS 17.2, *)
    func registerForPublicTransportActivity() {
        Netmera.register(forType: Activity<PublicTransportAttributes>.self,
                         name: PublicTransportAttributes.activityIdentifier)
    }
    
    // MARK: - Match Score Activity
  
    func startMatchActivity() throws {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            throw LiveActivityError.activitiesNotEnabled
        }

        guard matchActivity == nil else { return }

        let attributes = MatchScoreAttributes(netmeraGroupId: "testGroupId",
                                              homeTeamName: "Barcelona",
                                              awayTeamName: "Real Madrid",
                                              homeTeamLogo: "barcelona_logo",
                                              awayTeamLogo: "madrid_logo")
        let contentState = MatchScoreAttributes.ContentState(homeTeamScore: 0,
                                                             awayTeamScore: 0,
                                                             matchStatus: "1st half")

        matchActivity = try Activity.request(attributes: attributes,
                                             content: .init(state: contentState, staleDate: nil),
                                             pushType: .token)

        if let matchActivity {
            Netmera.observeActivity(matchActivity)
        }
    }
    
    func updateMatchScore() async throws {
        guard let activity = matchActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        let updatedContentState = MatchScoreAttributes.ContentState(
            homeTeamScore: Int.random(in: 0...5),
            awayTeamScore: Int.random(in: 0...5),
            matchStatus: "Second Half"
        )

        if #available(iOS 17.2, *) {
          await activity.update(.init(state: updatedContentState, staleDate: nil),
                                alertConfiguration: .init(title: "Match update",
                                                          body: "New goal",
                                                          sound: .default),
                                timestamp: .now)
        } else {
          await activity.update(.init(state: updatedContentState, staleDate: nil))
        }
    }
    
    func endMatchActivity() async throws {
        guard let activity = matchActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        matchActivity = nil
    }
    
    // MARK: - Delivery Tracking Activity
    func startDeliveryActivity() throws {
        let attributes = DeliveryTrackingAttributes()
        let contentState = DeliveryTrackingAttributes.ContentState(
            deliveryStatus: "In Transit",
            remainingStops: 5,
            estimatedDeliveryTime: Date().addingTimeInterval(3600),
            courierName: "John Doe"
        )
        
        deliveryActivity = try Activity.request(
            attributes: attributes,
            content: .init(state: contentState, staleDate: nil),
            pushType: nil
        )
    }
    
    func updateDeliveryStatus() async throws {
        guard let activity = deliveryActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        let updatedContentState = DeliveryTrackingAttributes.ContentState(
            deliveryStatus: "In Transit",
            remainingStops: Int.random(in: 0...5),
            estimatedDeliveryTime: Date().addingTimeInterval(Double.random(in: 1800...7200)),
            courierName: "John Doe"
        )
        
        await activity.update(.init(state: updatedContentState, staleDate: nil))
    }
    
    func endDeliveryActivity() async throws {
        guard let activity = deliveryActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        deliveryActivity = nil
    }
    
    // MARK: - Public Transport Activity
    func startTransportActivity() throws {
        let attributes = PublicTransportAttributes()
        let contentState = PublicTransportAttributes.ContentState(
            vehicleNumber: "34BZ",
            remainingTime: 5,
            stopName: "Mecidiyeköy",
            vehicleType: "bus"
        )
        
        transportActivity = try Activity.request(
            attributes: attributes,
            content: .init(state: contentState, staleDate: nil),
            pushType: nil
        )
    }
    
    func updateTransportStatus() async throws {
        guard let activity = transportActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        let updatedContentState = PublicTransportAttributes.ContentState(
            vehicleNumber: "34BZ",
            remainingTime: Int.random(in: 1...10),
            stopName: "Mecidiyeköy",
            vehicleType: "bus"
        )
        
        await activity.update(.init(state: updatedContentState, staleDate: nil))
    }
    
    func endTransportActivity() async throws {
        guard let activity = transportActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        transportActivity = nil
    }
    
    // MARK: - Flight Tracking Activity
    func startFlightActivity() throws {
        let attributes = FlightTrackingAttributes(
            netmeraGroupId: "testGroupIdForFlight",
            flightNumber: "THY123",
            arrivalCity: "London",
            airlineLogo: "thy_logo",
            departureCity: "Istanbul"
        )
        
        let contentState = FlightTrackingAttributes.ContentState(
            departureTime: Date().addingTimeInterval(3600),
            arrivalTime: Date().addingTimeInterval(7200),
            gateNumber: "210"
        )
        
        flightActivity = try Activity.request(
            attributes: attributes,
            content: .init(state: contentState, staleDate: nil),
            pushType: nil
        )
    }
    
    func updateFlightStatus() async throws {
        guard let activity = flightActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        let updatedContentState = FlightTrackingAttributes.ContentState(
            departureTime: Date().addingTimeInterval(3600),
            arrivalTime: Date().addingTimeInterval(7200),
            gateNumber: String(Int.random(in: 200...300))
        )
        
        await activity.update(.init(state: updatedContentState, staleDate: nil))
    }
    
    func endFlightActivity() async throws {
        guard let activity = flightActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        flightActivity = nil
    }
    
    // MARK: - Fintech Activity
    func startFintechActivity() throws {
        let attributes = FintechAttributes()
        let contentState = FintechAttributes.ContentState(
            balance: 1.2,
            changePercentage: 1.3,
            isPositive: true,
            investmentProgress: 2.4
        )
        
        fintechActivity = try Activity.request(
            attributes: attributes,
            content: .init(state: contentState, staleDate: nil),
            pushType: nil
        )
    }
    
    func updateFintechStatus() async throws {
        guard let activity = fintechActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        let updatedContentState = FintechAttributes.ContentState(
            balance: 2.2,
            changePercentage: 5.3,
            isPositive: false,
            investmentProgress: 4.4
        )
        
        await activity.update(.init(state: updatedContentState, staleDate: nil))
    }
    
    func endFintechActivity() async throws {
        guard let activity = fintechActivity else {
            throw LiveActivityError.noActiveActivity
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        fintechActivity = nil
    }
}

// MARK: - LiveActivityError
enum LiveActivityError: Error {
    case activitiesNotEnabled
    case noActiveActivity
}
