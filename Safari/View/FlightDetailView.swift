//
//  FlightDetailView.swift
//  Safari
//
//  Created by Le Bon B' Bauma on 07/12/2022.
//

import SwiftUI

struct FlightDetailView: View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing:  String
    
    
    var body: some View{
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlightDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
