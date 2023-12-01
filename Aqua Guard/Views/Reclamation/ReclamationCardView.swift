//
//  ReclamationCardView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ReclamationCardView: View {
    var body: some View {
          VStack(spacing: 0) {
              ZStack {
        
                                 
                                
                  LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1333333333, green: 0.6235294118, blue: 0.9176470588, alpha: 1)), Color(#colorLiteral(red: 0.9490196078, green: 0.9803921569, blue: 1, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                      .frame(height:77)
                      .padding(-70)
                  
                  Image("moi")
                      .resizable()
                      .scaledToFill()
                      .frame(width: 60, height: 70)
                      .clipShape(Circle())
                      .overlay(Circle().stroke(Color.white, lineWidth: 5))
                      .padding(EdgeInsets(top: 10, leading: 290, bottom: 0, trailing: 10))
                  
                  Text("this is the message of reclamation ")
                      .font(.system(size: 14, weight: .bold))
                      .foregroundColor(.black)
                      .multilineTextAlignment(.leading) // Align text to the left
                      .padding(EdgeInsets(top:-27, leading: -100, bottom: 0, trailing: 10))
                    
                  
              }.cornerRadius(15)
          
              VStack {
                  Text("« Texte « Texte » est issu du mot latin « textum », dérivé du ve«« Texte » est issu du mot latin « textum », dérivé du ve« Texte » est issu du mot latin « textum », dérivé du verbe « texere » qui signifie « tisser »..« Texte » est issu du mot latin « textum », dérivé du verbe « texere » qui signifie « tisser »..rbe « texere » qui signifie « tisser ».. Texte » est issu du mot latin « textum », dérivé du verbe « texere » qui signifie « tisser »..rbe « texere » qui signifie « tisser »..» est issu du mot latin « textum », dérivé du verbe « texere » qui signifie « tisser »...")
                      .padding(EdgeInsets(top:-5, leading: 15, bottom: 50, trailing: 15))
                  
                  Text("le 29/11/2023 at 12:06")
                      
                      .font(.system(size: 16, weight: .light))
                      .padding(EdgeInsets(top:-27, leading: -10, bottom: 0, trailing: 10))
                      .foregroundColor(Color(#colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)))
                      .multilineTextAlignment(.leading) // Align text to the left
                      .padding(.leading, -160)
                  
                  Button(action: {
                      // Action when the button is tapped
                  }) {
                      Text("voir la discution ")
                          .foregroundColor(.white)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .frame(height:45)
                          .background(Color.darkBlue)
                  }
                  
              }
              .background(Color.white)
              
          }
          .frame(maxWidth: .infinity)
          .cornerRadius(15)
          .padding([.top, .leading], 10)
          .padding(.trailing, 14)
      }
    
  }

  struct ReclamationCardView_Previews: PreviewProvider {
      static var previews: some View {
          ReclamationCardView()
      }
  }
