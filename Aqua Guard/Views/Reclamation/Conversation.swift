import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    var content: String
    var isUser: Bool
}

struct Conversation: View {
    @State private var messages: [Message] = [
        Message(content: "reclamation1!", isUser: false),
        Message(content: "reponse de reclamation1", isUser: true),
        Message(content: "How are you?", isUser: false),
        Message(content: "I'm good, thanks!", isUser: true),
    ]

    @State private var newMessage = ""

    var body: some View {
        VStack {
            List(messages) { message in
                MessageView(message: message)
            }.padding(8)
                .listStyle(PlainListStyle()) // Use PlainListStyle to remove the default list appearance
                .navigationTitle("Reclamation Title").navigationBarTitleDisplayMode(.inline)
            .onAppear {
                scrollToLastMessage()
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
        messages.append(Message(content: newMessage, isUser: true))
        newMessage = ""

        // Scroll to the last message after sending a new message
        scrollToLastMessage()
    }

    func scrollToLastMessage() {
        // Scroll to the last message in the list
        if let lastMessage = messages.last {
            withAnimation {
                // Scroll to the last message
            }
        }
    }
}

struct MessageView: View {
    var message: Message

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }

            Text(message.content)
                .padding(10)
                .background(message.isUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

            if !message.isUser {
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}

struct Conversation_Previews: PreviewProvider {
    static var previews: some View {
        Conversation()
    }
}
