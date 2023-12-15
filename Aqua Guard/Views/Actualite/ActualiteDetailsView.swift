// ActualiteDetailsView.swift

import SwiftUI

struct ActualiteDetailsView: View {
    var actualite: Actualite

    @State private var selectedOption: Int? = nil
    let avis = ["true", "not true", "maybe"]

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "http://127.0.0.1:9090/images/actualite/\(actualite.image)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }

            Text(actualite.title)
                .font(.title)
                .fontWeight(.medium)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(actualite.description)
                .font(.system(size: 12))
                .fontWeight(.medium)
                .padding(.leading)
                .padding(.top, 1)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(actualite.text)
                .font(.system(size: 12))
                .fontWeight(.light)
                .padding(.leading)
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .leading)

            Picker("Select an Option", selection: $selectedOption) {
                
                ForEach(0..<avis.count) { index in
                    Text(self.avis[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .onChange(of: selectedOption) { newOption, _ in
                print("Selected Option: \(String(describing: newOption))")

                let avis = Avis(userId: "6554092c88519a44716228d3", actualiteTitle: actualite.id, avis: avis[newOption!])

                ActualiteWebService.shared.addOrUpdateAvis(userId: avis.userId, actualiteTitle: avis.actualiteTitle, avis: avis.avis) { success, error in
                    if success {
                        // Avis added or updated successfully
                        print("Avis added or updated successfully")
                    } else {
                        // Error handling
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            print("Unknown error")
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationBarTitle(actualite.title, displayMode: .inline)
    }
}
