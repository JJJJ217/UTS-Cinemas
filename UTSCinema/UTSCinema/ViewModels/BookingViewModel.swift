import SwiftUI
import Combine

class BookingViewModel: ObservableObject {
    
    @Published var selectedSeats: [Seat] = []
    @Published var bookings: [Booking] = []
    
    func toggleSeat(_ seat: Seat) {
        if selectedSeats.contains(seat) {
            selectedSeats.removeAll { $0 == seat }
        } else {
            selectedSeats.append(seat)
        }
    }
    
    func confirmBooking(movie: Movie, time: String) {
        let booking = Booking(
            movie: movie,
            time: time,
            seats: selectedSeats
        )
        
        bookings.append(booking)
        selectedSeats.removeAll()
    }
}
