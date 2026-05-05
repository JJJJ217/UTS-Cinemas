//
//  MainTabView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            BrowseMoviesView()
                .tabItem {
                    Label("Browse", systemImage: "popcorn")
                }
            
            MyBookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "ticket")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainTabView()
}
