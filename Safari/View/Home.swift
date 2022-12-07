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
                    .offset(x: animator.startAnimantion ? 80 : 0 )

                })
                .zIndex(1)
            PaymentsCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            ZStack(alignment: .bottom){
                 // Cloud View
                ZStack{
                    if animator.showClouds {
                        Group{
                            /// Multiple Clouds for better animation
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.2, size: size)
                                .offset(y: size.height * -0.5)
                            CloudView(delay: 2.5, size: size)
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 2.5, size: size)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                if animator.showLoadingView {
                    BackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        })
        .background{
            DetailView(size: size, safeArea: safeArea)
                .environmentObject(animator)
        }
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader{ proxy in
                    // Extracting Rect form Anchor using Geomtry Reader that will extract CGRect from the Anchor
                    let rect = proxy[anchor]
                    let planeRect = animator.initialPlanePoistion
                    let status = animator.currentPaymentStatus
                    /// Reseting plane's position when final view appears
                    let animationStatus = status == .finished && !animator.showFinalView
                    Image("Airplane")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: planeRect.width, height: planeRect.height)
                    /// Flight Movement Animation
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0))
                        .shadow(color: Color("PicoVoid").opacity(0.25), radius: 1, x: status == .finished ? -400 :0, y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                    /// Moving plane bit down to look like it's center the 3d animation is happening
                        .offset(y: animator.startAnimantion ? 40 : 0)
                    
                        .onAppear{
                            animator.initialPlanePoistion = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 2.5 ), value: animationStatus)
                    
                }
            }
        })
        /// One OverLayed over the Airplane
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: size.height * -0.25)
            }
        })
        .background {
            Color("CoastalBreeze").opacity(0.8)
                .ignoresSafeArea()
        }
        // Toogle Cloud View whenever status changed to finished
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
                /// Activating final view after some time
                DispatchQueue.main.asyncAfter(deadline: . now() + 5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
                
            }
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
        /// Applying 3D Rotation
        .rotation3DEffect(.init(degrees: animator.startAnimantion ? -90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimantion ? 100 : 0)
    }
    
    func buyTicket() {
        
        /// Animating content
        withAnimation(.easeOut(duration: 0.85)){
            animator.startAnimantion = true
        }
        
        /// Showing Loading View  after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            withAnimation(.easeOut(duration: 0.7)) {
                animator.showLoadingView = true
            }
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
    
    
    // MARK: - Background loading view with ring animation
    @ViewBuilder
    func BackgroundView() -> some View{
        
        VStack{
            /// Payment Status
            
            VStack(spacing: 0){
                ForEach(PaymentStatus.allCases, id: \.rawValue) { status in
                    
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("PicoVoid").opacity(0.2))
                        .frame(height: 30)
                }
                
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 :
                        animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: 30, alignment: .top)
            .clipped()
            .zIndex(1)
            
            ZStack{
                
                //Rings
                /// Ring 1
                Circle()
                    .fill(Color("CoastalBreeze"))
                    .shadow(color: .white.opacity(0.45) ,radius: 5, x:5, y:5)
                    .shadow(color: .white.opacity(0.45) ,radius: 5, x:-5, y:-5)
                    .scaleEffect(animator.ringAnimation[0] ? 5 : 1)
                    .opacity(animator.ringAnimation[0] ? 0 : 1 )
                
                /// Ring 2
                Circle()
                    .fill(Color("CoastalBreeze"))
                    .shadow(color: .white.opacity(0.45) ,radius: 5, x:5, y:5)
                    .shadow(color: .white.opacity(0.45) ,radius: 5, x:-5, y:-5)
                    .scaleEffect(animator.ringAnimation[1] ? 5 : 1)
                    .opacity(animator.ringAnimation[1] ? 0 : 1 )
                
                Circle()
                    .fill(Color("CoastalBreeze"))
                    .shadow(color: Color("PicoVoid").opacity(0.1) ,radius: 5, x:5, y:5)
                    .shadow(color: Color("PicoVoid").opacity(0.1) ,radius: 5, x:-5, y:-5)
                    .scaleEffect(1.25)
                 
                Circle()
                    .fill(.white)
                    .shadow(color: Color("PicoVoid").opacity(0.1) ,radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(Color("PicoVoid").opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
        }
        // Using timer to simulate Loading  Effect
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initiated{
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        }
        .onAppear(perform: {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                animator.ringAnimation[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animator.ringAnimation[1] = true
                }
            }
        })
        .padding(.bottom, size.height * 0.15)
    }

}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: -  Cloud View
 
struct CloudView: View{
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
         
    var body: some View {
        ZStack {
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
             
        }
        .onAppear{
            /// Duration  = speed of the movement of the clouds
            withAnimation(.easeInOut(duration: 6.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}


// MARK: - Observable Object that holds all animation properties

class Animator: ObservableObject{
    // Animation Properties
    @Published var startAnimantion: Bool = false
    
    // Initial image position
    @Published var initialPlanePoistion: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initiated
    
    // Rings Status
    @Published var ringAnimation : [Bool] = [false, false]
    
    // Loding Status
    @Published var showLoadingView: Bool = false
    
    // CloudView Status
    @Published var showClouds: Bool = false
    
    // Final View status
    @Published var showFinalView: Bool = false
    
    
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
