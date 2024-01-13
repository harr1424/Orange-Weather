import SwiftUI
import RevenueCat

struct SubscriptionOptionsViewLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Image("subscription_light")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                ForEach(Purchases.shared.cachedOfferings?.current?.availablePackages ?? [], id: \.id) { package in
                    Button(action: {
                        subscribe(package: package)
                    }, label: {
                        Text(getPackageDescription(package: package))
                    })
                    .padding()
                    .foregroundColor(.primary)
                    .background(accentColorManager.accentColor.opacity(0.8))
                    .clipShape(Capsule())
                }
                Button(action: {
                    restore()
                }) {
                    Text("Restore Subscription")
                }
                .padding()
                .foregroundColor(.primary)
                .background(accentColorManager.accentColor.opacity(0.8))
                .clipShape(Capsule())
            }
        }
        .navigationTitle(Text("Subscribers Only"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }

    }
    
    
    func getPackageDescription(package: Package) -> String {
        switch package.identifier {
        case "$rc_monthly":
            return "3 days free then \(package.localizedPriceString) per month"
        case "$rc_annual":
            return "3 days free then \(package.localizedPriceString) per year"
        default:
            return "Invalid Subscription Option"
        }
    }
    
    func subscribe(package: Package) {
        Purchases.shared.getOfferings { offerings, error in
            if (offerings?.current?.availablePackages) != nil {
                Purchases.shared.purchase(package: package) { transaction, customer, error, userCancelled in
                    if error != nil {
                        print("Error subscribing: \(String(describing: error))")
                        
                        alertTitle = "Error Subscribing"
                        alertMessage = "Error: \(String(describing: error?.localizedDescription))"
                        showAlert = true
                    } else {
                        
                        if customer?.entitlements["AddLocation"]?.isActive == true {
                            print("Purchase succeeded")
                            
                            alertTitle = "Thank You!"
                            alertMessage = "You are now subscribed"
                            showAlert = true
                            
                        }
                        else {
                            print("Purchase completed without error, but user does not have entitlement")
                            
                            alertTitle = "Attention"
                            alertMessage = "Your purchase completed succesfully, but you don't yet have permission to access subscriber content. Try to access locations again in a moment."
                            showAlert = true
                        }
                    }
                }
            }
        }
    }
    
    func restore() {
        Purchases.shared.restorePurchases { customer, error in
            if error != nil {
                print("Error restoring: \(String(describing: error))")
                
                alertTitle = "Error Subscribing"
                alertMessage = "Error: \(String(describing: error?.localizedDescription))"
                showAlert = true
                
            } else {
                
                if customer?.entitlements["AddLocation"]?.isActive == true {
                    print("Restore succeeded")
                    
                    alertTitle = "Restore Successful"
                    alertMessage = "You now have access to your subscription"
                    showAlert = true
                    
                }
                
                else {
                    print("No purchases available to restore")
                    
                    alertTitle = "Nothing to Restore"
                    alertMessage = "It doesn't look like you have ever purchased a subscription to Orange Weather"
                    showAlert = true
                }
            }
        }
    }
}

struct SubscriptionOptionsViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Image("subscription_dark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                ForEach(Purchases.shared.cachedOfferings?.current?.availablePackages ?? [], id: \.id) { package in
                    Button(action: {
                        subscribe(package: package)
                    }, label: {
                        Text(getPackageDescription(package: package))
                    })
                    .padding()
                    .foregroundColor(.primary)
                    .background(accentColorManager.accentColor.opacity(0.8))
                    .clipShape(Capsule())
                }
                Button(action: {
                    restore()
                }) {
                    Text("Restore Subscription")
                }
                .padding()
                .foregroundColor(.primary)
                .background(accentColorManager.accentColor.opacity(0.8))
                .clipShape(Capsule())
            }
        }
        .navigationTitle(Text("Subscribers Only"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }

    }
    
    
    func getPackageDescription(package: Package) -> String {
        switch package.identifier {
        case "$rc_monthly":
            return "3 days free then \(package.localizedPriceString) per month"
        case "$rc_annual":
            return "3 days free then \(package.localizedPriceString) per year"
        default:
            return "Invalid Subscription Option"
        }
    }
    
    func subscribe(package: Package) {
        Purchases.shared.getOfferings { offerings, error in
            if (offerings?.current?.availablePackages) != nil {
                Purchases.shared.purchase(package: package) { transaction, customer, error, userCancelled in
                    if error != nil {
                        print("Error subscribing: \(String(describing: error))")
                        
                        alertTitle = "Error Subscribing"
                        alertMessage = "Error: \(String(describing: error?.localizedDescription))"
                        showAlert = true
                    } else {
                        
                        if customer?.entitlements["AddLocation"]?.isActive == true {
                            print("Purchase succeeded")
                            
                            alertTitle = "Thank You!"
                            alertMessage = "Your are now subscribed"
                            showAlert = true
                            
                        }
                        else {
                            print("Purchase completed without error, but user does not have entitlement")
                            
                            alertTitle = "Attention"
                            alertMessage = "Your purchase completed succesfully, but you don't yet have permission to access subscriber content. Try  again in a moment."
                            showAlert = true
                        }
                    }
                }
            }
        }
    }
    
    func restore() {
        Purchases.shared.restorePurchases { customer, error in
            if error != nil {
                print("Error restoring: \(String(describing: error))")
                
                alertTitle = "Error Subscribing"
                alertMessage = "Error: \(String(describing: error?.localizedDescription))"
                showAlert = true
                
            } else {
                
                if customer?.entitlements["AddLocation"]?.isActive == true {
                    print("Restore succeeded")
                    
                    alertTitle = "Restore Successful"
                    alertMessage = "You now have access to your subscription"
                    showAlert = true
                    
                }
                
                else {
                    print("No purchases available to restore")
                    
                    alertTitle = "Nothing to Restore"
                    alertMessage = "It doesn't look like you have ever purchased a subscription to Orange Weather"
                    showAlert = true
                }
            }
        }
    }
}


