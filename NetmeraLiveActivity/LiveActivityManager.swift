import NetmeraLiveActivity
import NetmeraCore
import ActivityKit
import BackgroundTasks

class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var matchActivity: Activity<MatchScoreAttributes>?
    private var deliveryActivity: Activity<DeliveryTrackingAttributes>?
    private var transportActivity: Activity<PublicTransportAttributes>?
    private var flightActivity: Activity<FlightTrackingAttributes>?
    private var fintechActivity: Activity<FintechAttributes>?
    private var shakeAndWinActivity: Activity<ShakeAndWinAttributes>?
    
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

    @available(iOS 17.2, *)
    func registerForShakeAndWinActivity() {
        Netmera.register(forType: Activity<ShakeAndWinAttributes>.self,
                         name: ShakeAndWinAttributes.activityIdentifier)
    }
    
    // MARK: - Match Score Activity
  
    func startMatchActivity() throws {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            throw LiveActivityError.activitiesNotEnabled
        }

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

    // MARK: - Shake And Win Activity
    //
    // Lifecycle: the backend STARTS the activity (push-to-start, handled by Netmera via
    // register(forType:) / resumeObservingActivities) and may END it. No update pushes.
    //
    // Display ladder (see ShakeAndWinStage): fixed "1 sa 1 dk" snapshot (dark) → "30 dk" in
    // orange from -30 min → live mm:ss timer for the last 15 min (red) → dismissed at endDate.
    //
    // How the steps happen on-device:
    //  * The widget derives the stage (label, colour) from the clock whenever it is rendered.
    //  * Every update arms `staleDate` at the NEXT stage boundary; iOS re-renders there on its
    //    own, so the first boundary after any update is always on time.
    //  * iOS grants only that one timed re-render per update, so `refreshShakeAndWinActivityIfNeeded()`
    //    re-arms the chain whenever it gets to run: app foreground, and a BGAppRefreshTask
    //    requested for each boundary (best effort — iOS decides if/when it runs).
    //  * Once in the final 15 min, we `end(…, dismissalPolicy: .after(endDate))`: the timer keeps
    //    ticking and iOS removes the activity at exactly endDate with no code running.

    static let shakeAndWinRefreshTaskId = "com.netmera.liveActivity.shakeAndWinRefresh"

    /// Guarantees dismissal at endDate by ending the activity early (display continues until then).
    /// Trade-off: a backend end push can no longer remove it during the last 15 minutes.
    /// Set to false if the backend's early end must win even in that window.
    var shakeAndWinAutoDismissesAtEnd = true

    private var shakeAndWinObserver: Task<Void, Never>?

    /// An activity we can still update. `.stale` is a LIVE state — it is exactly what the
    /// activity becomes when our `staleDate` fires — so it must be treated like `.active`.
    /// Only `.ended` / `.dismissed` are terminal.
    private static func isLive(_ state: ActivityState) -> Bool {
        state == .active || state == .stale
    }

    /// The in-memory reference is lost on relaunch; fall back to the system's list so
    /// update/end keep working after the app was killed while the activity was still shown.
    private var currentShakeAndWinActivity: Activity<ShakeAndWinAttributes>? {
        if let shakeAndWinActivity, Self.isLive(shakeAndWinActivity.activityState) {
            return shakeAndWinActivity
        }
        let recovered = Activity<ShakeAndWinAttributes>.activities.first { Self.isLive($0.activityState) }
        shakeAndWinActivity = recovered
        return recovered
    }

    // MARK: Observation (backend-started activities)

    /// Call once at launch. Adopts activities the backend started via push-to-start
    /// (and any already running), arms their local schedule, and drops the reference
    /// when the backend ends one.
    func startObservingShakeAndWinActivities() {
        guard shakeAndWinObserver == nil else { return }

        for activity in Activity<ShakeAndWinAttributes>.activities {
            adoptShakeAndWinActivity(activity)
        }

        // Push-to-start launches the app in the background, so this fires for new ones.
        shakeAndWinObserver = Task {
            for await activity in Activity<ShakeAndWinAttributes>.activityUpdates {
                adoptShakeAndWinActivity(activity)
            }
        }
    }

    private func adoptShakeAndWinActivity(_ activity: Activity<ShakeAndWinAttributes>) {
        guard Self.isLive(activity.activityState) else { return }
        shakeAndWinActivity = activity

        Task {
            // The push-to-start payload normally carries no stale-date; arm our schedule now.
            await refreshShakeAndWinActivityIfNeeded(force: true)
        }

        Task {
            // Only a terminal state drops the activity. `.stale` arrives at every staleDate
            // boundary and must NOT stop the chain.
            for await state in activity.activityStateUpdates where !Self.isLive(state) {
                if shakeAndWinActivity?.id == activity.id {
                    shakeAndWinActivity = nil
                    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.shakeAndWinRefreshTaskId)
                }
                break
            }
        }
    }

    // MARK: Local schedule

    /// Content with `staleDate` armed at the next stage boundary.
    private func shakeAndWinContent(_ state: ShakeAndWinAttributes.ContentState)
        -> ActivityContent<ShakeAndWinAttributes.ContentState> {
        let end = Date(timeIntervalSince1970: state.endDate)
        let stage = ShakeAndWinStage.at(endDate: end)
        return .init(state: state, staleDate: stage.nextTransition(endDate: end))
    }

    /// Single local entry point (foreground, BG refresh, adoption).
    /// Re-arms `staleDate` when the armed boundary has passed (or `force`), hands the final
    /// 15 minutes to iOS for timed dismissal, and ends anything already expired.
    func refreshShakeAndWinActivityIfNeeded(force: Bool = false) async {
        guard let activity = currentShakeAndWinActivity else {
            print("[ShakeAndWin] refresh: no active activity")
            return
        }

        let state = activity.content.state
        let end = Date(timeIntervalSince1970: state.endDate)
        let stage = ShakeAndWinStage.at(endDate: end)
        print("[ShakeAndWin] refresh: stage=\(stage) remaining=\(Int(end.timeIntervalSinceNow))s force=\(force)")

        switch stage {
        case .ended:
            await activity.end(nil, dismissalPolicy: .immediate)
            shakeAndWinActivity = nil
            return

        case .countdown where shakeAndWinAutoDismissesAtEnd:
            // Timer keeps running; iOS dismisses at endDate without us.
            var final = state
            final.lastUpdatedText = "Az önce güncellendi"
            await activity.end(shakeAndWinContent(final), dismissalPolicy: .after(end))
            shakeAndWinActivity = nil
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.shakeAndWinRefreshTaskId)
            return

        default:
            break
        }

        let armed = activity.content.staleDate
        if force || armed == nil || armed! <= Date() {
            var refreshed = state
            refreshed.lastUpdatedText = "Az önce güncellendi"
            await activity.update(shakeAndWinContent(refreshed))
        }
        scheduleShakeAndWinBackgroundRefresh(for: activity)
    }

    // MARK: Background refresh (best effort — iOS decides if/when it runs)

    /// Register once in AppDelegate.didFinishLaunching, before the app finishes launching.
    func registerShakeAndWinBackgroundRefresh() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.shakeAndWinRefreshTaskId,
                                        using: nil) { [weak self] task in
            guard let self, let task = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            print("[ShakeAndWin] BG refresh task launched")
            let work = Task {
                await self.refreshShakeAndWinActivityIfNeeded()
                task.setTaskCompleted(success: true)
            }
            task.expirationHandler = { work.cancel() }
        }
    }

    /// Asks iOS for a wake-up just after the next stage boundary so the chain can be re-armed.
    private func scheduleShakeAndWinBackgroundRefresh(for activity: Activity<ShakeAndWinAttributes>) {
        let end = Date(timeIntervalSince1970: activity.content.state.endDate)
        guard let next = ShakeAndWinStage.at(endDate: end).nextTransition(endDate: end) else { return }

        let request = BGAppRefreshTaskRequest(identifier: Self.shakeAndWinRefreshTaskId)
        request.earliestBeginDate = max(next.addingTimeInterval(5), Date())
        do {
            try BGTaskScheduler.shared.submit(request)
            print("[ShakeAndWin] BG refresh requested for \(request.earliestBeginDate!)")
        } catch {
            print("[ShakeAndWin] BG refresh not scheduled: \(error)")
        }
    }

    // MARK: Manual (sample / testing only — production activities are started by the backend)

    func startShakeAndWinActivity() throws {
        let attributes = ShakeAndWinAttributes(
            netmeraGroupId: "shakeWinGroup01",
            campaignName: "Salla Kazan",
            groupId: "shakeWinGroup01",
            deeplink: "myapp://shakeandwin"
        )
        let contentState = ShakeAndWinAttributes.ContentState(
            title: "Bu haftaki Salla Kazan'ını kaçırma!",
            endDate: Date().addingTimeInterval(8 * 3600).timeIntervalSince1970,
            displayLabel: "Bu Hafta",
            statusText: "Hakkın bu hafta sona eriyor",
            lastUpdatedText: "Az önce güncellendi"
        )

        // .token so the backend can still END this one; observeActivity reports the token.
        let activity = try Activity.request(
            attributes: attributes,
            content: shakeAndWinContent(contentState),
            pushType: .token
        )
        Netmera.observeActivity(activity)
        adoptShakeAndWinActivity(activity)
    }

    func updateShakeAndWinStatus() async throws {
        guard let activity = currentShakeAndWinActivity else {
            throw LiveActivityError.noActiveActivity
        }

        let updatedContentState = ShakeAndWinAttributes.ContentState(
            title: "Bu haftaki Salla Kazan'ını kaçırma!",
            endDate: Date().addingTimeInterval(Double.random(in: 600...3300)).timeIntervalSince1970,
            displayLabel: "Son Şans",
            statusText: "Hakkın bu hafta sona eriyor",
            lastUpdatedText: "Az önce güncellendi"
        )

        await activity.update(shakeAndWinContent(updatedContentState))
        scheduleShakeAndWinBackgroundRefresh(for: activity)
    }

    func endShakeAndWinActivity() async throws {
        guard let activity = currentShakeAndWinActivity else {
            throw LiveActivityError.noActiveActivity
        }

        await activity.end(nil, dismissalPolicy: .immediate)
        shakeAndWinActivity = nil
    }
}

// MARK: - LiveActivityError
enum LiveActivityError: Error {
    case activitiesNotEnabled
    case noActiveActivity
}
