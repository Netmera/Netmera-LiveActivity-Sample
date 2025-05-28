import WidgetKit
import SwiftUI

@main
struct NetmeraLiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        MatchScoreWidget()
        DeliveryTrackingWidget()
        PublicTransportWidget()
        FlightTrackingWidget()
        FintechWidget()
    }
}
