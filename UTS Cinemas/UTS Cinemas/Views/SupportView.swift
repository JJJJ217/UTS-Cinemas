struct SupportView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding(.top, 40)
            
            Text("Contact Support")
                .font(.title)
                .bold()
            
            Text("If you have any questions or need assistance, please feel free to email our customer support team at:")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Text("support@utscinemas.com")
                .font(.headline)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            if let url = URL(string: "mailto:support@utscinemas.com") {
                Link("Open Mail App", destination: url)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .navigationTitle("Support")
        .navigationBarTitleDisplayMode(.inline)
    }