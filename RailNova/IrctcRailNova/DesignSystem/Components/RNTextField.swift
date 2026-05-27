import SwiftUI

// MARK: - Station Search Field

struct RNStationField: View {
    let label: String
    let placeholder: String
    @Binding var station: Station?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(RNTypography.labelSmall)
                    .foregroundColor(.railNovaTextMuted)
                if let station {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(station.code)
                            .font(RNTypography.stationCode)
                            .foregroundColor(.railNovaTextPrimary)
                        Text(station.name)
                            .font(RNTypography.bodySmall)
                            .foregroundColor(.railNovaTextSecondary)
                    }
                } else {
                    Text(placeholder)
                        .font(RNTypography.bodyMedium)
                        .foregroundColor(.railNovaTextMuted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.railNovaSurface)
            .cornerRadius(10)
        }
    }
}

// MARK: - PNR Input Field

struct RNPNRTextField: View {
    @Binding var text: String
    var placeholder: String = "Enter 10-digit PNR"
    
    var body: some View {
        HStack {
            Image(systemName: "ticket")
                .foregroundColor(.railNovaSecondary)
            TextField(placeholder, text: $text)
                .keyboardType(.numberPad)
                .font(RNTypography.bodyLarge)
                .onChange(of: text) { _, newValue in
                    text = String(newValue.filter { $0.isNumber }.prefix(10))
                }
        }
        .padding(14)
        .background(Color.railNovaSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(text.count == 10 ? Color.railNovaSecondary : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
