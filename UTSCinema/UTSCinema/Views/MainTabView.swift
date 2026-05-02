import SwiftUI

struct MainTabView: View {
    
    @StateObject var viewModel = BookingViewModel()
    @State private var filmPath = NavigationPath()
    
    var body: some View {
        TabView {
            
            NavigationStack(path: $filmPath) {
                FilmView(viewModel: viewModel, filmPath: $filmPath)
            }
            .tabItem {
                Label("Films", systemImage: "film")
            }
            
            NavigationStack {
                MyBookingView(viewModel: viewModel)
            }
            .tabItem {
                Label("Bookings", systemImage: "ticket")
            }
        }
    }
}
