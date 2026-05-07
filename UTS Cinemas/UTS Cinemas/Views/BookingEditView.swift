//
//  BookingEditView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct BookingEditView: View {
    @ObservedObject var bookingManager = BookingManager.shared
    @ObservedObject var movieManager = MovieManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    var bookingToEdit: Booking? = nil
    
    @State private var selectedMovieId: UUID = UUID()
    @State private var selectedSeats: Set<String> = []
    
    private let rows = ["A", "B", "C", "D", "E"]
    private let cols = 1...6
    
    @State private var bookedSeats: Set<String> = []
    @State private var selectedBookingId: UUID = UUID()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Title Display
                if let movie = movieManager.movies.first(where: { $0.id == selectedMovieId }) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                }
                
                // Seat Selection
                VStack(spacing: 16) {
                    Text("SCREEN")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    ForEach(rows, id: \.self) { row in
                        SeatRowView(row: row, cols: cols, selectedSeats: $selectedSeats, bookedSeats: bookedSeats, maxSeats: bookingToEdit?.seats.count ?? Int.max)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                // Selected Seats Summary
                if !selectedSeats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Seats")
                            .font(.headline)
                        Text(selectedSeats.sorted().joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                // Delete Button for Existing Booking
                if let booking = bookingToEdit {
                    Button(role: .destructive) {
                        bookingManager.deleteBooking(booking)
                        dismiss()
                    } label: {
                        Text("Delete Booking")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Edit Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(selectedSeats.isEmpty || movieManager.movies.isEmpty || (bookingToEdit != nil && selectedSeats.count != bookingToEdit!.seats.count))
                }
            }
            .onAppear {
                if let booking = bookingToEdit {
                    selectedMovieId = booking.movieId
                    selectedBookingId = booking.bookedSeatId
                    selectedSeats = Set(booking.seats)
                }
                updateBookedSeats()
            }
        }
    }
    
    
    private func updateBookedSeats() {
        // Fetch all bookings for the currently selected movie, excluding the one we are editing
        let otherBookings = bookingManager.bookings.filter {
            $0.movieId == selectedMovieId && $0.id != bookingToEdit?.id
        }
        bookedSeats = Set(otherBookings.flatMap { $0.seats })
    }
    
    private func save() {
        let seatsArray = Array(selectedSeats).sorted()
        
        if var booking = bookingToEdit {
            booking.movieId = selectedMovieId
            booking.seats = seatsArray
            booking.bookedSeatId = selectedBookingId
            bookingManager.updateBooking(booking)
        }
    }
}

struct SeatRowView: View {
    let row: String
    let cols: ClosedRange<Int>
    @Binding var selectedSeats: Set<String>
    let bookedSeats: Set<String>
    let maxSeats: Int
    
    var body: some View {
        HStack() {
            ForEach(cols, id: \.self) { col in
                let seat = "\(row)\(col)"
                let isSelected = selectedSeats.contains(seat)
                let isBooked = bookedSeats.contains(seat)
                
                Text(seat)
                    .font(.subheadline)
                    .frame(width: 36, height: 36)
                    .background(isBooked ? Color.gray.opacity(0.5) : (isSelected ? Color.blue : Color.gray.opacity(0.3)))
                    .foregroundColor(isBooked ? .white.opacity(0.5) : (isSelected ? .white : .primary))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        if !isBooked {
                            if isSelected {
                                selectedSeats.remove(seat)
                            } else if selectedSeats.count < maxSeats {
                                selectedSeats.insert(seat)
                            }
                        }
                    }
            }
        }
    }
}
