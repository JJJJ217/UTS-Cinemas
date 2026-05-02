import SwiftUI

struct SeatSelectionView: View {
    
    let movie: Movie
    let selectedTime: String
    let maxSeats: Int
    let ticketBreakdown: [String: Int]
    
    @ObservedObject var viewModel: BookingViewModel
    @Binding var filmPath: NavigationPath
    
    @State private var seats: [[Seat]] = []
    @State private var showLimitAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text(movie.title)
                    .font(.title)
                    .bold()
                
                Text("Time: \(selectedTime)")
                    .foregroundColor(.gray)
                
                Text("Select \(maxSeats) seats")
                    .font(.caption)
                
                Text("Screen This Way ↑")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // 🎬 GRID
                VStack(spacing: 10) {
                    ForEach(seats, id: \.self) { row in
                        HStack(spacing: 8) {
                            
                            Spacer().frame(width: 20)
                            
                            ForEach(row) { seat in
                                
                                if seat.number == 6 {
                                    Spacer().frame(width: 20)
                                }
                                
                                ZStack {
                                    Circle()
                                        .fill(color(for: seat))
                                        .frame(width: 28, height: 28)
                                    
                                    if seat.isPremium {
                                        Text("P")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                }
                                .onTapGesture {
                                    handle(seat)
                                }
                            }
                            
                            Spacer().frame(width: 20)
                        }
                    }
                }
                
                // 🎨 LEGEND
                HStack(spacing: 15) {
                    legend(.purple, "Available")
                    legend(.blue, "Selected")
                    legend(.gray, "Taken")
                    legend(.orange, "Premium")
                }
                .font(.caption)
                
                Text("Selected: \(viewModel.selectedSeats.count)/\(maxSeats)")
                    .font(.caption)
                
                // 🔘 FIXED BUTTON
                NavigationLink("Continue") {
                    BookingSummaryView(
                        movie: movie,
                        time: selectedTime,
                        ticketBreakdown: ticketBreakdown,
                        viewModel: viewModel,
                        filmPath: $filmPath
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.selectedSeats.count >= maxSeats ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(viewModel.selectedSeats.count < maxSeats)
                
            }
            .padding()
        }
        .onAppear {
            if seats.isEmpty { generate() }
        }
        .alert("Seat Limit", isPresented: $showLimitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can only select \(maxSeats) seats.")
        }
    }
    
    func handle(_ seat: Seat) {
        if seat.isBooked { return }
        
        if viewModel.selectedSeats.contains(seat) {
            viewModel.toggleSeat(seat)
        } else if viewModel.selectedSeats.count < maxSeats {
            viewModel.toggleSeat(seat)
        } else {
            showLimitAlert = true
        }
    }
    
    func generate() {
        seats = (1...8).map { row in
            (1...10).map { num in
                Seat(
                    row: row,
                    number: num,
                    isPremium: row >= 7,
                    isBooked: Double.random(in: 0...1) < 0.25
                )
            }
        }
    }
    
    func color(for seat: Seat) -> Color {
        if seat.isBooked { return .gray }
        if viewModel.selectedSeats.contains(seat) { return .blue }
        if seat.isPremium { return .orange }
        return .purple
    }
    
    func legend(_ color: Color, _ text: String) -> some View {
        HStack {
            Circle().fill(color).frame(width: 12, height: 12)
            Text(text)
        }
    }
}
