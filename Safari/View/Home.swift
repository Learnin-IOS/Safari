//
//  Home.swift
//  Safari
//
//  Created by Le Bon B' Bauma on 04/12/2022.
//

import SwiftUI

struct Home: View {
    
    // MARK: - View Bounds
    var size: CGSize
    var safeArea: EdgeInsets
    var body: some View {
        VStack(spacing: 0){
            HeaderView()
        }
    }
    
    // MARK: - Top Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: size.width * 0.4)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
               FlightDetailView(place: "Nairobi", code: "NBO", timing: "04 Dec, 23:15")
                
                VStack(spacing: 8){
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                    Text("8h 28m")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                FlightDetailView(alignment: .trailing, place: "Paris", code: "CDG", timing: "05 Dec, 05:50 + 1")
            }
            .padding(.top, 20)

            // MARK: - Airplane Image View
            Image("Airplane")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .padding(.bottom, -40)
            
        }
        .padding([.horizontal, .top], 15)
        .padding(.top, safeArea.top)
        .background{
            Rectangle()
                .fill(.linearGradient(colors:[
                    Color("PicoVoid"),
//                    Color("MazarineBlue"),
                    Color("BrightGreek"),
                    Color("ElectronBlue"),
                    Color("DarnerTailBlue")
                ], startPoint: .top, endPoint: .bottom))
                
        }
    }
    @ViewBuilder
    func FlightDetailView(alignment: HorizontalAlignment = .leading, place: String, code: String, timing: String) -> some View{
        
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



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
