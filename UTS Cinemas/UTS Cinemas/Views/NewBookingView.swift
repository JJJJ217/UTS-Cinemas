//
//  NewBookingView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 6/5/2026.
//

import SwiftUI

struct NewBookingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var bookingManager = BookingManager.shared
    @ObservedObject var movieManager = MovieManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    var initialMovieId: UUID? = nil
    
    @State private var selectedMovieId: UUID = UUID()
    @State private var selectedSeats: Set<String> = []
    @State private var bookedSeats: Set<String> = []
    @State private var selectedBookingId: UUID = UUID()
    
    private let rows = ["A", "B", "C", "D", "E"]
    private let cols = 1...6
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Selection (Read-only if pre-selected, or just text)
                if let movie = movieManager.movies.first(where: { $0.id == selectedMovieId }) {
                    Text("Booking: \(movie.title)")
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
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                        .padding(.bottom, 8)
                    
                    ForEach(rows, id: \.self) { row in
                        SeatRowView(row: row, cols: cols, selectedSeats: $selectedSeats, bookedSeats: bookedSeats, maxSeats: Int.max)
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
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("New Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    // Navigate to payment view
                    NavigationLink(destination: PaymentView(
                        movieId: selectedMovieId,
                        seats: Array(selectedSeats).sorted(),
                        bookedSeatId: selectedBookingId,
                        customerId: authManager.currentUser?.id,
                        onPaymentSuccess: {
                            dismiss()
                        }
                    )) {
                        Text("Checkout")
                    }
                    .disabled(selectedSeats.isEmpty || movieManager.movies.isEmpty)
                }
            }
            .onAppear {
                if let preSelected = initialMovieId {
                    selectedMovieId = preSelected
                } else if let firstMovie = movieManager.movies.first {
                    selectedMovieId = firstMovie.id
                }
                updateBookedSeats()
            }
        }
    }
    
    private func updateBookedSeats() {
        let otherBookings = bookingManager.bookings.filter {
            $0.movieId == selectedMovieId
        }
        bookedSeats = Set(otherBookings.flatMap { $0.seats })
    }
}
