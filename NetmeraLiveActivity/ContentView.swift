import SwiftUI
import ActivityKit
import NetmeraLiveActivity

struct ContentView: View {
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showUserIdentify = false
    @State private var userIdInput = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Match Score") {
                    Button("Start Match Activity") {
                        startMatchActivity()
                    }
                    Button("Update Score") {
                        updateMatchScore()
                    }
                    Button("End Match Activity") {
                        endMatchActivity()
                    }
                }
                
                Section("Delivery Tracking") {
                    Button("Start Delivery Activity") {
                        startDeliveryActivity()
                    }
                    Button("Update Delivery Status") {
                        updateDeliveryStatus()
                    }
                    Button("End Delivery Activity") {
                        endDeliveryActivity()
                    }
                }
                
                Section("Public Transport") {
                    Button("Start Transport Activity") {
                        startTransportActivity()
                    }
                    Button("Update Transport Status") {
                        updateTransportStatus()
                    }
                    Button("End Transport Activity") {
                        endTransportActivity()
                    }
                }
                
                Section("Flight Tracking") {
                    Button("Start Flight Activity") {
                        startFlightActivity()
                    }
                    Button("Update Flight Status") {
                        updateFlightStatus()
                    }
                    Button("End Flight Activity") {
                        endFlightActivity()
                    }
                }
                
                Section("Fintech Tracking") {
                    Button("Start Fintech Activity") {
                        startFintechActivity()
                    }
                    Button("Update Fintech Activity") {
                        updateFintechStatus()
                    }
                    Button("End Fintech Activity") {
                        endFintechActivity()
                    }
                }

                Section("Shake And Win") {
                    Button("Start Shake And Win Activity") {
                        startShakeAndWinActivity()
                    }
                    Button("Update Shake And Win Activity") {
                        updateShakeAndWinStatus()
                    }
                    Button("End Shake And Win Activity") {
                        endShakeAndWinActivity()
                    }
                }
            }
            .navigationTitle("Live Activities Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("User Identify") {
                            userIdInput = ""
                            showUserIdentify = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .alert("User Identify", isPresented: $showUserIdentify) {
                TextField("User ID", text: $userIdInput)
                Button("Set") { identifyUser() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter your user ID")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
    
    private func identifyUser() {
        let user = NetmeraUserIdentify()
        user.userId = userIdInput
        Netmera.identifyUser(user)
    }

    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Match Score Activity
    private func startMatchActivity() {
        do {
            try LiveActivityManager.shared.startMatchActivity()
        } catch {
            showError("Error starting match activity: \(error.localizedDescription)")
        }
    }
    
    private func updateMatchScore() {
        Task {
            do {
                try await LiveActivityManager.shared.updateMatchScore()
            } catch {
                showError("Error updating match score: \(error.localizedDescription)")
            }
        }
    }
    
    private func endMatchActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endMatchActivity()
            } catch {
                showError("Error ending match activity: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delivery Tracking Activity
    private func startDeliveryActivity() {
        do {
            try LiveActivityManager.shared.startDeliveryActivity()
        } catch {
            showError("Error starting delivery activity: \(error.localizedDescription)")
        }
    }
    
    private func updateDeliveryStatus() {
        Task {
            do {
                try await LiveActivityManager.shared.updateDeliveryStatus()
            } catch {
                showError("Error updating delivery status: \(error.localizedDescription)")
            }
        }
    }
    
    private func endDeliveryActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endDeliveryActivity()
            } catch {
                showError("Error ending delivery activity: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Public Transport Activity
    private func startTransportActivity() {
        do {
            try LiveActivityManager.shared.startTransportActivity()
        } catch {
            showError("Error starting transport activity: \(error.localizedDescription)")
        }
    }
    
    private func updateTransportStatus() {
        Task {
            do {
                try await LiveActivityManager.shared.updateTransportStatus()
            } catch {
                showError("Error updating transport status: \(error.localizedDescription)")
            }
        }
    }
    
    private func endTransportActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endTransportActivity()
            } catch {
                showError("Error ending transport activity: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Flight Tracking Activity
    private func startFlightActivity() {
        do {
            try LiveActivityManager.shared.startFlightActivity()
        } catch {
            showError("Error starting flight activity: \(error.localizedDescription)")
        }
    }
    
    private func updateFlightStatus() {
        Task {
            do {
                try await LiveActivityManager.shared.updateFlightStatus()
            } catch {
                showError("Error updating flight status: \(error.localizedDescription)")
            }
        }
    }
    
    private func endFlightActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endFlightActivity()
            } catch {
                showError("Error ending flight activity: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Shake And Win Activity
    private func startShakeAndWinActivity() {
        do {
            try LiveActivityManager.shared.startShakeAndWinActivity()
        } catch {
            showError("Error starting shake and win activity: \(error.localizedDescription)")
        }
    }

    private func updateShakeAndWinStatus() {
        Task {
            do {
                try await LiveActivityManager.shared.updateShakeAndWinStatus()
            } catch {
                showError("Error updating shake and win activity: \(error.localizedDescription)")
            }
        }
    }

    private func endShakeAndWinActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endShakeAndWinActivity()
            } catch {
                showError("Error ending shake and win activity: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fintech Activity
    private func startFintechActivity() {
        do {
            try LiveActivityManager.shared.startFintechActivity()
        } catch {
            showError("Error starting fintech activity: \(error.localizedDescription)")
        }
    }
    
    private func updateFintechStatus() {
        Task {
            do {
                try await LiveActivityManager.shared.updateFintechStatus()
            } catch {
                showError("Error updating fintech status: \(error.localizedDescription)")
            }
        }
    }
    
    private func endFintechActivity() {
        Task {
            do {
                try await LiveActivityManager.shared.endFintechActivity()
            } catch {
                showError("Error ending fintech activity: \(error.localizedDescription)")
            }
        }
    }
} 
