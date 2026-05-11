import SwiftUI

struct SeatRowView: View {
    let row: String
    let cols: ClosedRange<Int>
    @Binding var selectedSeats: Set<String>
    let bookedSeats: Set<String>
    let maxSeats: Int
    
    var body: some View {
        HStack {
            Text(row)
                .frame(width: 20)
                .font(.headline)
            Spacer()
            ForEach(cols, id: \.self) { col in
                let seatId = "\(row)\(col)"
                let isBooked = bookedSeats.contains(seatId)
                let isSelected = selectedSeats.contains(seatId)
                
                Button(action: {
                    if isSelected {
                        selectedSeats.remove(seatId)
                    } else if selectedSeats.count < maxSeats {
                        selectedSeats.insert(seatId)
                    }
                }) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isBooked ? Color.gray : (isSelected ? Color.blue : Color.gray.opacity(0.3)))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(col)")
                                .foregroundColor(isBooked ? .white : (isSelected ? .white : .primary))
                                .font(.caption)
                        )
                }
                .disabled(isBooked)
            }
            Spacer()
            Text(row)
                .frame(width: 20)
                .font(.headline)
        }
    }
}
