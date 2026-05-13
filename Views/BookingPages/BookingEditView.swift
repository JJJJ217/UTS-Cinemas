import SwiftUI

struct BookingEditView: View {
    @ObservedObject var bookingManager = BookingManager.shared
    @ObservedObject var movieManager = MovieManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    var bookingToEdit: Booking? = nil
    
    @State private var selectedMovieId: UUID
    @State private var selectedSeats: Set<String>
    @State private var selectedBookingId: UUID
    @State private var bookingCancel = false
    
    @Environment(\.dismiss) private var dismiss
    
    private let rows = ["A", "B", "C", "D", "E"]
    private let cols = 1...6
    
    init(bookingToEdit: Booking? = nil) {
        self.bookingToEdit = bookingToEdit
        _selectedMovieId = State(initialValue: bookingToEdit?.movieId ?? UUID())
        _selectedSeats = State(initialValue: Set(bookingToEdit?.seats ?? []))
        _selectedBookingId = State(initialValue: bookingToEdit?.bookedSeatId ?? UUID())
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                movieHeaderSection
                
                seatSelectionSection
                
                selectedSeatsSummary
                
                cancelButtonSection
                
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
        }
    }
    
    private var movieHeaderSection: some View {
        Group {
            if let movie = movieManager.movies.first(where: { $0.id == selectedMovieId }) {
                VStack(spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(movie.location)
                        Spacer()
                        Image(systemName: "clock")
                        Text(movie.showtime, format: .dateTime.hour().minute().day().month())
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var seatSelectionSection: some View {
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
    }
    
    private var selectedSeatsSummary: some View {
        Group {
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
        }
    }
    
    private var cancelButtonSection: some View {
        Group {
            if let booking = bookingToEdit {
                Button(role: .destructive) {
                    bookingCancel = true
                } label: {
                    VStack(spacing: 4) {
                        Text("Cancel Booking")
                            .font(.headline)
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .alert("Confirm Cancellation", isPresented: $bookingCancel) {
                    Button("Keep Booking", role: .cancel) { }
                    Button("Cancel & Refund", role: .destructive) {
                        bookingManager.cancelBooking(booking)
                        dismiss()
                    }
                } message: {
                    Text("Your seats will be released and $\(booking.price, specifier: "%.2f") will be refunded to your account.")
                }
            }
        }
    }
    
    private var bookedSeats: Set<String> {
        let otherBookings = bookingManager.bookings.filter {
            $0.movieId == selectedMovieId &&
            $0.id != bookingToEdit?.id
        }
        return Set(otherBookings.flatMap { $0.seats })
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
