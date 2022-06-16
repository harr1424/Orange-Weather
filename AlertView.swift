//
//  AlertView.swift
//  Orange Weather
//
//  Created by user on 6/15/22.
//

import SwiftUI

struct AlertView: View {
    var alert: Alert
    var body: some View {
        Text(alert.event)
            .fontWeight(.bold)
            .font(.system(size: 24))
        Text(alert.description)
            .font(.system(size: 18))
        Text(alert.sender_name)
            .font(.system(size: 18))
    }
}
