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
    
    
    // MARK: - Animator state object
    @StateObject var animator: Animator = .init()

    // MARK: - Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentIndex: CGFloat = 0
    var body: some View {
        VStack(spacing: 0){
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PicoVoid").opacity(0.4))
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: Color("PicoVoid").opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    }
                    .offset(x: -15, y: 15)

                })
                .zIndex(1)
            PaymentsCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader{ proxy in
                    // Extracting Rect form Anchor using Geomtry Reader that will extract CGRect from the Anchor
                    let rect = proxy[anchor]
                    let planeRect = animator.initialPlanePoistion
                    Image("Airplane")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: planeRect.width, height: planeRect.height)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        .onAppear{
                            animator.initialPlanePoistion = rect 
                        }
                    
                }
            }
        })
        .background {
            Color("CoastalBreeze").opacity(0.8)
                .ignoresSafeArea()
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
            /// Hiding the original image
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS": anchor]
                })
                .padding(.bottom, -40)
            
        }
        .padding([.horizontal, .top], 15)
        .padding(.top, safeArea.top)
        .background{
            Rectangle()
                .fill(.linearGradient(colors:[
                    Color("PicoVoid"),
                    Color("MazarineBlue"),
                    Color("BrightGreek"),
                    Color("ElectronBlue"),
                    Color("DarnerTailBlue")
                ], startPoint: .top, endPoint: .bottom))
                
        }
        
    ///  Applying  3D Rotation
    
        .rotation3DEffect(.init(degrees: animator.startAnimantion ? 90 : 0) , axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimantion ? -100 : 0)
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
                
                Button(action: buyTicket){
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
        .background{
            Color.white
                .ignoresSafeArea()
        }
    }
    
    func buyTicket() {
        
        /// Animating content
        withAnimation(.easeOut(duration: 0.85)){
            animator.startAnimantion = true
        }
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


// MARK: - Observable Object that holds all animation properties

class Animator: ObservableObject{
    // Animation Properties
    @Published var startAnimantion: Bool = false
    
    /// initial iamge position
    @Published var initialPlanePoistion: CGRect = .zero
}



// MARK: - Anchor Preference Key
/*
 Since the Flight image rotates when 3D animation is applied, we must first determine
 it's precise location on the screen in order to add the smae image as overlay.
 Using Anchor Preference, we can recover it's precise location on the screen 😎
 */

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
                    
    }
    
}
