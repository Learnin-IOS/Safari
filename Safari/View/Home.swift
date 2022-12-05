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
    

    // MARK: - Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentIndex: CGFloat = 0
    var body: some View {
        VStack(spacing: 0){
            HeaderView()
                .zIndex(1)
            PaymentsCardsView()
                .zIndex(0)
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
    
    
    // MARK: - Payments
    @ViewBuilder
    func PaymentsCardsView() -> some View{
        VStack{
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color("PicoVoid").opacity(0.4))
                .padding(.vertical)
            
            GeometryReader{_ in
                VStack(spacing: 0){
                    ForEach(sampleCard.indices, id: \.self) { index in
                        CardView(index: index)
                        
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentIndex * -200.0)
                
                // Gradient View
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false)
                /**
                 Why?
                    Since the rectangle is an overlay view, it will prevent all intersctions
                        with the view below , so activating this modifier(allowHitsTesting(False)) will entirely disable
                        the rectangle's interaction.
                 **/
                
                
                // MARK: - Purchase Button
                
                Button {
                    
                } label: {
                    Text("Confirm $1,536.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color("PicoVoid").gradient)
                                
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom ==  0 ? 15 : safeArea.bottom)
                
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    // Decreasing Speed
                    offsetY = value.translation.height * 0.3
                }).onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeOut){
                        // MARK: - Increase/Decrease Index Based on condition
                        
                        // we using 100 since the Card's heidght is 200 so half the height.
                        if translation > 0  && translation > 100 && currentIndex > 0{
                            currentIndex -= 1
                        }
                        if translation < 0 && -translation > 100 && currentIndex < CGFloat(sampleCard.count - 1) {
                            currentIndex += 1
                        }
                        offsetY = .zero
                    }
                })
        )
    }
    
    // MARK: - Card View
    @ViewBuilder
    func CardView(index: Int) -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCard[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                // Shadow
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
            
                // Stacked cCard Animation
                .rotation3DEffect(.init(degrees: constrainedProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                .padding(.top,  progress * -150.0)
            
                // Moving Current Card to the Top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCard.count - index))
        .onTapGesture {
             print(index)
        }
        
    }

}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Detail View UI

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


struct DetailView: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    var body: some View{
        VStack {
            VStack(spacing: 0) {
                VStack{
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    
                    Text("Your order has been submitted")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    
                    Text("We arewaiting for your booking confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.white.opacity(0.1)))
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
                .padding(15)
                .padding(.bottom, 70)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 15)
            .padding([.horizontal, .bottom], 15)
            .background {
                Rectangle()
                    .fill(Color("PicoVoid"))
                    .padding(.bottom, 80)
            }
            
            
            // MARK: - Contact Information
            
            GeometryReader { proxy in
                /// For smaller devices Adoption
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical,showsIndicators: false){
                         ContactInformation()
                    }
                }
                
            }
        }
       
        
    }
    
    @ViewBuilder
    func ContactInformation()-> some View {
        VStack(spacing: 15){
            HStack{
                InfoView(title:"Flight"  , subtitle: "AR 500")
                InfoView(title:"Class"  , subtitle: "Business")
                InfoView(title:"Aircraft"  , subtitle: "B 737 - 400")
                InfoView(title:"Possibility"  , subtitle: "AR 580")
            }
            
           ContactView(name: "Murphy Musokya", email: "murhpy.m@gmail.com", profile: "user1")
                .padding(.top, 30)
            ContactView(name: "Le Bon", email: "lebonbauma.devGmail.com", profile: "user2")
            
            
            // MARK: - Home Screen Button
            Button {
                <#code#>
            } label: {
                <#code#>
            }

        }
        .padding(15)
        .padding(.top, 20)
    }
    
    
    // MARK: - ContactView
    @ViewBuilder
    func ContactView(name: String, email: String, profile: String)-> some View {
        HStack{
            VStack(alignment: .leading, spacing: 4) {
                 Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PicoVoid"))
                Text(email)
                    .font(.callout)
                    .foregroundColor(Color("PicoVoid").opacity(0.4))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
             
            
        }
        .padding(.horizontal, 15)
    }
    
    
    // MARK: - Info
    @ViewBuilder
    func InfoView(title: String, subtitle: String)-> some  View {
        VStack(alignment: .center, spacing: 4){
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(Color("PicoVoid").opacity(0.4))
            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color("PicoVoid"))
        }
        .frame(maxWidth: .infinity)
    }
}
