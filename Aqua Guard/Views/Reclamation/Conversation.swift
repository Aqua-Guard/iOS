import SwiftUI

struct Conversation: View {
    var reclamationId: String // Pass the reclamationId to the view
    @ObservedObject var viewModel: ReclamationViewModel
    
    init(reclamationId: String, viewModel: ReclamationViewModel) {
        self.reclamationId = reclamationId
        self.viewModel = viewModel
    }

    @State private var newMessage = ""

    var body: some View {
        VStack {
            List(viewModel.discussions, id: \.createdAt) { discussion in
                DiscussionView(discussion: discussion)
            }
            .padding(8)
            .listStyle(PlainListStyle()) // Use PlainListStyle to remove the default list appearance
            .navigationTitle("Reclamation Title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchDiscussions(reclamationId: reclamationId)
                print("Fetched discussions for reclamationId: \(reclamationId)")
                print("Discussions count: \(viewModel.discussions.count)")
            }

            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                                    Text("Send")
                                        .padding()
                }
            }
        }
        .padding()
    }

    func sendMessage() {
        Task {
            do {
                let success = try await viewModel.sendMessage(message: newMessage, userRole: "user", reclamationId: reclamationId)
                newMessage = ""
                
              
                    await viewModel.fetchDiscussions(reclamationId: reclamationId)
               

            } catch {
                // Handle errors if needed
                print("Failed to send message:", error)
            }
        }
    }


}

struct DiscussionView: View {
    var discussion: Discussion

    var body: some View {
        HStack {
            if discussion.userRole == "user" {
                Spacer()
            }

            Text(discussion.message)
                .padding(10)
                .background(discussion.userRole == "user" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

            if discussion.userRole != "user" {
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}
