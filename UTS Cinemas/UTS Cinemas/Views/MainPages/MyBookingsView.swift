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
                        Button {
                            bookingToEdit = booking
                            showingBookingEdit = true
                        } label: {
                            HStack {
                                if let movie = movieManager.movies.first(where: { $0.id == booking.movieId }) {
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .font(.headline)
                                        Text("Seats: \(booking.seats.joined(separator: ", "))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(movie.location)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        
                                        Text(movie.showtime, format: .dateTime.month().day().hour().minute())
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                } else {
                                    Text("Unknown Movie")
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            bookingManager.deleteBooking(bookings[index])
                        }
                    }
                }
            }
            .navigationTitle("My Bookings")
            .sheet(isPresented: $showingBookingEdit) {
                BookingEditView(bookingToEdit: bookingToEdit)
            }
        }
    }
}

#Preview {
    MyBookingsView()
}
