// ActualiteCardView.swift

import SwiftUI

struct ActualiteCardView: View {
    var actualite: Actualite

    @State private var isShareSheetPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "http://127.0.0.1:9090/images/actualite/\(actualite.image)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(actualite.title)
                    .font(.title)
                    .fontWeight(.medium)

                Text(actualite.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                HStack {
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .onTapGesture {
                            withAnimation {
                                isShareSheetPresented.toggle()
                            }
                        }
                        .sheet(isPresented: $isShareSheetPresented) {
                            ShareSheet(activityItems: [actualite.title, actualite.description, actualite.image])
                        }

                    NavigationLink(destination: ActualiteDetailsView(actualite: actualite)) {
                        EmptyView()
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(8)
    }
}

// ShareSheet.swift

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        var sharingItems: [Any] = []

        for item in activityItems {
            if let image = item as? UIImage {
                if let imageData = image.pngData() {
                    sharingItems.append(imageData)
                }
            } else {
                sharingItems.append(item)
            }
        }

        let controller = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the view controller if needed
    }
}
