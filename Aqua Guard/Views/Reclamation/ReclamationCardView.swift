//
//  ReclamationCardView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ReclamationCardView: View {
    var reclamation: Reclamation
    @StateObject var viewModel: ReclamationViewModel

    @State private var isDetailVisible = false
    @State private var isConversationSheetPresented = false

    @State private var isDetailExpanded = false

    var body: some View {
          VStack(spacing: 0 ) {
              ZStack {
        
                                 
                                
                  LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1333333333, green: 0.6235294118, blue: 0.9176470588, alpha: 1)), Color(#colorLiteral(red: 0.9490196078, green: 0.9803921569, blue: 1, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                      .frame(height:77)
                      .padding(-70)
                  AsyncImage(url: URL(string: "http://192.168.93.190:9090/images/reclamation/\(reclamation.image)")) { phase in
                      switch phase {
                      case .empty:
                          ProgressView()
                      case .success(let image):
                          image
                              .resizable()
                              .scaledToFill()
                              .frame(width: 60, height: 70)
                              .clipShape(Circle())
                              .overlay(Circle().stroke(Color.white, lineWidth: 5))
                              .padding(EdgeInsets(top: 10, leading: 290, bottom: 0, trailing: 10))
                      case .failure:
                  Image("moi")
                      .resizable()
                      .scaledToFill()
                      .frame(width: 60, height: 70)
                      .clipShape(Circle())
                      .overlay(Circle().stroke(Color.white, lineWidth: 5))
                      .padding(EdgeInsets(top: 10, leading: 290, bottom: 0, trailing: 10))
                      @unknown default:
                          EmptyView()
                      }
                  }
                  Text(reclamation.title)
                      .font(.system(size: 14, weight: .bold))
                      .foregroundColor(.black)
                      .multilineTextAlignment(.leading) // Align text to the left
                      .padding(EdgeInsets(top: isDetailExpanded ? -25 : -27, leading: -100, bottom: 0, trailing: 10))
                                         .onTapGesture {
                                             withAnimation {
                                                 isDetailExpanded.toggle()
                                                 isDetailVisible.toggle()
                                             }
                                         }
                    
                  
              }.cornerRadius(15)
                  

          
              VStack {
                  Text(reclamation.description)
                      .id("detail")
                      .opacity(isDetailVisible ? 1 : 0)
                      .padding(EdgeInsets(top: isDetailExpanded ? -5 : -110, leading: isDetailExpanded ? 15:-15000, bottom: isDetailExpanded ? 50 : 0, trailing:isDetailExpanded ? 15:-30000))

                      
                  
                  Text("le 29/11/2023 at 12:06")
                      .id("date_et_heure")
                      .font(.system(size: 16, weight: .light))
                      .padding(EdgeInsets(top:-27, leading: -10, bottom: 0, trailing: 10))
                      .foregroundColor(Color(#colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)))
                      .multilineTextAlignment(.leading) // Align text to the left
                      .padding(.leading, -160)
                  
         
                  
                  Button(action: {
                      isConversationSheetPresented.toggle()
                  }) {
                      Text("Conversation")
                          .background(Color.darkBlue)
                          .foregroundColor(.white)
                          .cornerRadius(8)
                          .opacity(isDetailVisible ? 1 : 0)
                          .padding(EdgeInsets(top: isDetailExpanded ? 7 : -100, leading: isDetailExpanded ? 15 : -15000, bottom: isDetailExpanded ? 10 : 0, trailing: isDetailExpanded ? 15 : -30000))
                          .frame(maxWidth: .infinity)
                          .background(Color.darkBlue)
                  }
                  .sheet(isPresented: $isConversationSheetPresented) {
                      NavigationView {
                          Conversation(reclamationId: reclamation.id, viewModel: viewModel)
                              .navigationBarHidden(true)
                              .navigationBarBackButtonHidden(true)
                      }
                  }

                  
              }
              .background(Color.white)
              
          }
          .id("card")
          .frame(maxWidth: .infinity)
          .cornerRadius(15)
          .padding([.top, .leading], 10)
          .padding(.trailing, 14)
      }
    
  }

  
