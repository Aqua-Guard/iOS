import SwiftUI

extension View {
    @discardableResult
    func withHapticFeedback(_ feedback: UIImpactFeedbackGenerator.FeedbackStyle) -> some View {
        let impactFeedback = UIImpactFeedbackGenerator(style: feedback)
        impactFeedback.impactOccurred()
        return self
    }
}

struct ReclamationListView: View {
    @EnvironmentObject var viewModel: ReclamationViewModel
    @State private var isSheetPresented = false

    var body: some View {
        NavigationView {
            VStack {
                List {if viewModel.reclamation.isEmpty {
                        Section(header: Text("No reclamations").font(.title).foregroundColor(Color.darkBlue), footer: Text("")) {
                            Image("photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .padding(.top, 5)
                            
                            Text("No Actualite exists")
                                .font(.system(size: 20))
                                .foregroundColor(Color.darkBlue)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                    } else {
                        ForEach(viewModel.reclamation) { reclamation in
                            ReclamationCardView(reclamation: reclamation, viewModel: viewModel)
                                .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                        }
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
                            self.withHapticFeedback(.medium)
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
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .padding(.bottom)
                }
            ).onAppear {
                // Fetch or refresh data when the view appears
                viewModel.fetchreclamation()
            }
        }
    }
}

struct ReclamationListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReclamationListView()
            .environmentObject(ReclamationViewModel())
    }
}
