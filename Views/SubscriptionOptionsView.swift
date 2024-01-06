import SwiftUI
import StoreKit

struct SubscriptionOptionsViewLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        VStack{
            Text("")
                .font(.title)
                .padding()
        }
    }
}

struct SubscriptionOptionsViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @ObservedObject var storeKitManager = StoreKitManager.shared

    var body: some View {
        VStack {
            Image("subscription_dark")
                .resizable()
                .aspectRatio(contentMode: .fit)

            // Display buttons for each available subscription product
            ForEach(storeKitManager.availableProducts, id: \.productIdentifier) { product in
                Button(action: {
                    storeKitManager.purchaseSubscription(product: product)
                }) {
                    Text("Subscribe to \(product.localizedTitle)")
                }
                .padding()
            }

            // Debugging information
            Text("Subscription Status: \(storeKitManager.subscriptionStatus.map { "\($0)" } ?? "notSubscribed")")
            Text("Available Products: \(storeKitManager.availableProducts.map { $0.localizedTitle }.joined(separator: ", "))")
        }
        .onAppear {
            // Fetch products when the view appears
            storeKitManager.fetchProducts(productIdentifiers: ["com.yourapp.subscription1", "com.yourapp.subscription2"])
        }
    }
}
