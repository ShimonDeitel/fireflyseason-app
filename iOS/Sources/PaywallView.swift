import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                    Text("Firefly Season Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.textPrimary)
                    Text("Multi-year trend chart and intensity rating notes")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Unlimited entries", systemImage: "infinity")
                        Label("Multi-year trend chart and intensity rating notes", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.textPrimary)
                    .padding()
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                    .padding(.horizontal, 24)

                    Spacer()

                    Button(action: {
                        Task { await purchases.purchase() }
                    }) {
                        if let product = purchases.product {
                            Text("Unlock for \(product.displayPrice) one-time")
                                .font(Theme.headlineFont)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accent)
                                .foregroundStyle(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .accessibilityIdentifier("paywallPurchaseButton")
                    .padding(.horizontal, 24)

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.textSecondary)

                    Button("Not now") { dismiss() }
                        .accessibilityIdentifier("paywallDismissButton")
                        .font(Theme.captionFont)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.bottom, 12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: purchases.isPurchased) { _, newValue in
            if newValue { dismiss() }
        }
    }
}
