import SwiftUI
import WeatherKit


struct AlertView: View {
    var alert: WeatherAlert
    var body: some View {
        
        Text(alert.summary)
            .fontWeight(.bold)
            .font(.system(size: 24))
        Text("Severity: \(alert.severity.description)")
            .font(.system(size: 18))
        Text("Issued by \(alert.source.description)")
            .font(.system(size: 18))
        Link(destination: alert.detailsURL.absoluteURL) {
            Text("More Information")
        }
    }
}

