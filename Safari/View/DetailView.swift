//
//  DetailView.swift
//  Safari
//
//  Created by Le Bon B' Bauma on 07/12/2022.
//

import SwiftUI

struct DetailView: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    @EnvironmentObject var animator: Animator
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
            .offset(y: animator.showFinalView ? 0 : 300)
            .background {
                Rectangle()
                    .fill(Color("PicoVoid"))
                    .scaleEffect(y: animator.showFinalView ? 1 : 0.001, anchor: .top)
                    .padding(.bottom, 80)
            }
            .clipped()
            
            
            // MARK: - Contact Information
            
            GeometryReader { proxy in
                /// For smaller devices Adoption
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical,showsIndicators: false){
                         ContactInformation()
                    }
                }
                .offset(y: animator.showFinalView ? 0 : size.height)
                
            }
        }
        
        .animation(.easeInOut(duration: animator.showFinalView ? 1 : 0.3).delay(animator.showFinalView ? 1 : 0), value: animator.showFinalView)
       
        
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
            ContactView(name: "Le Bon Bauma", email: "lebonbauma.devGmail.com", profile: "user2")
            
            VStack(alignment: .leading,spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PicoVoid").opacity(0.4))
                
                Text("$1,536.00")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PicoVoid"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 15)
            
            // MARK: - Home Screen Button
            Button {
                
            } label: {
                Text("Go To Home Screen")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(Color("PicoVoid").gradient)
                    }
            }
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom )

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
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
