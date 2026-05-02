import SwiftUI

struct MyBookingView: View {
    
    @ObservedObject var viewModel: BookingViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.bookings) { booking in
                NavigationLink {
                    TicketView(booking: booking)
                } label: {
                    VStack(alignment: .leading) {
                        Text(booking.movie.title)
                            .font(.headline)
                        
                        Text("Time: \(booking.time)")
                        
                        Text("Seats: \(booking.seats.map { "R\($0.row)S\($0.number)" }.joined(separator: ", "))")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("My Bookings")
        }
    }
}
