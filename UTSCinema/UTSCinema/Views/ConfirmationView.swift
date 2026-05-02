import SwiftUI

struct ConfirmationView: View {
    
    let movie: Movie
    let time: String
    let seats: [Seat]
    let ticketBreakdown: [String: Int]
    
    @ObservedObject var viewModel: BookingViewModel
    @Binding var filmPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text("🎉 Booking Confirmed")
                .font(.largeTitle)
                .bold()
            
            Text("Enjoy your film!")
                .font(.headline)
            
            Text(movie.title)
                .font(.title2)
            
            Text("Time: \(time)")
            
            Text("Seats: \(seats.map { "R\($0.row)S\($0.number)" }.joined(separator: ", "))")
            
            Divider()
            
            // 🎟 View Ticket
            NavigationLink("View Ticket") {
                if let last = viewModel.bookings.last {
                    TicketView(booking: last)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // 📚 View Bookings
            NavigationLink("View My Bookings") {
                MyBookingView(viewModel: viewModel)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // 🔥 DONE BUTTON (RESETS APP)
            Button("Done") {
                filmPath = NavigationPath()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true) // 🚫 no going back
    }
}
