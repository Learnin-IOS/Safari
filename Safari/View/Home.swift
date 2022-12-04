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
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: size.width * 0.4)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(15)
        .padding(.top, safeArea.top)
        .background{
            Rectangle()
                .fill(.linearGradient(colors:[
                    Color("ElectronBlue"),
                    Color("ElectronBlue"),
                    Color("DarnerTailBlue")
                ], startPoint: .top, endPoint: .bottom))
                
        }
    }
    @ViewBuilder
    func FlightDetailView(alignment: HorizontalAlignment= .leading, place:String, timing: String) -> some View{
        
        
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
