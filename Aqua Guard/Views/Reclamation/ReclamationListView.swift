import SwiftUI

struct ReclamationListView: View {
    @State private var isSheetPresented = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(0..<5) { index in
                        ReclamationCardView()
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 4, trailing: 0))
                    }
                }
                .padding(8)
                .listStyle(PlainListStyle()) // Use PlainListStyle to remove the default list appearance
                .navigationTitle("Reclamation")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(
                Image("background_splash_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Perform your action here
                            withHapticFeedback(.medium)
                            isSheetPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 7) // Blue border (contour)
                                )
                                .background(Image("background_splash_screen").resizable())
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding()
                        .sheet(isPresented: $isSheetPresented) {
                            NavigationView {
                                AddReclamation()
                            }
                        }
                    }
                    .padding(.bottom)
                }
            )
        }
    }
}



struct ReclamationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReclamationListView()
    }
}

extension View {
    @discardableResult
    func withHapticFeedback(_ feedback: UIImpactFeedbackGenerator.FeedbackStyle) -> some View {
        let impactFeedback = UIImpactFeedbackGenerator(style: feedback)
        impactFeedback.impactOccurred()
        return self
    }
}
