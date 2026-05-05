//
//  MyBookingsView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct MyBookingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Bookings")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("My Bookings")
        }
    }
}

#Preview {
    MyBookingsView()
}
