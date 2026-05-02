import SwiftUI

struct TicketView: View {
    
    let booking: Booking
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("🎟 Your Ticket")
                .font(.largeTitle)
                .bold()
            
            Text(booking.movie.title)
                .font(.title2)
            
            Text("Time: \(booking.time)")
            
            Text("Seats: \(booking.seats.map { "R\($0.row)S\($0.number)" }.joined(separator: ", "))")
            
            Divider()
            
            // Fake QR Code
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: 150, height: 150)
                .padding()
            
            Text("Scan at entry")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
    }
}
