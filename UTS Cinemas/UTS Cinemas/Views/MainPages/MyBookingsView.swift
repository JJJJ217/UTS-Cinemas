//
//  MyBookingsView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct MyBookingsView: View {
    @ObservedObject var bookingManager = BookingManager.shared
    @ObservedObject var movieManager = MovieManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var showingBookingEdit = false
    @State private var bookingToEdit: Booking?
    
    var body: some View {
        NavigationStack {
            List {
                let currentUserId = authManager.currentUser?.id
                let bookings = bookingManager.userBookings(customerId: currentUserId)
                
                if bookings.isEmpty {
                    Text("No bookings found")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(bookings) { booking in
                        HStack {
                            if let movie = movieManager.movies.first(where: { $0.id == booking.movieId }) {
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                        .font(.headline)
                                    Text("Seats: \(booking.seats.joined(separator: ", "))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                        Text(movie.location)
                                        Spacer()
                                        Image(systemName: "clock")
                                        Text(movie.showtime, format: .dateTime.hour().minute().day().month())
                                    }
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }
                            } else {
                                Text("Unknown Movie")
                            }
                            
                            Spacer()
                            
                            Button("Edit") {
                                bookingToEdit = booking
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("My Bookings")
        .sheet(item: $bookingToEdit) { booking in
            BookingEditView(bookingToEdit: booking)
        }
    }
}


#Preview {
    MyBookingsView()
}
