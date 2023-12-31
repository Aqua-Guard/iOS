//
//  PostCardView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import SwiftUI
import UserNotifications

struct PostCardView: View {
    let notificationDelegate = NotificationDelegate()
    
    
    @ObservedObject var viewModel = PostViewModel()
    //let post: PostModel
    let postIndex: Int
    @State private var isLiked = false
    @State private var likeCount: Int = 0
    @State private var commentText: String = ""
    
    
    @State private var showShareSheet = false
        @State private var shareItems: [Any] = ["Shared content goes here"]
    
    private var post: PostModel {
        viewModel.posts![postIndex]
    }
    
    
    init(viewModel: PostViewModel, postIndex: Int) {
        self.viewModel = viewModel
        self.postIndex = postIndex
        self._likeCount = State(initialValue: viewModel.posts![postIndex].nbLike)
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
    }
    private func checkIfLiked() {
        Task {
            isLiked = await viewModel.checkIfPostIsLiked(postId: post.idPost)
        }
    }
    
    var body: some View {
        let commentCount: Int = post.nbComments
        
        // MaterialCardView equivalent in SwiftUI is a VStack inside a RoundedRectangle
        VStack(alignment: .leading, spacing: 2) {
            // User info and post image
            HStack {
                
                AsyncImage(url: URL(string: "https://aquaguard-tux1.onrender.com/images/user/\(post.userImage ?? "")")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                    case .failure(_):
                        Image(systemName: "photo") // A fallback image in case of failure
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView() // An activity indicator while the image is loading
                    @unknown default:
                        EmptyView() // A default view for unknown phase
                    }
                }
                .frame(width: 65, height: 65) // Set the frame size for the image
                .clipShape(Circle()) // Clip the image to a circle
                .overlay(Circle().stroke(Color.darkBlue, lineWidth: 2)) // Add a border around the image
                
                // User name and role
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.userName)
                        .font(.title2)
                    Text(post.userRole)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                Spacer()
                NavigationLink( destination: PostDetailView(post: post)) {
                    Image(systemName:"info.circle").foregroundColor(.blue)
                    
                }
            }
            Divider()
                .background(Color.darkBlue)
            
            // Post description
            Text(post.description)
                .padding(16)
                .foregroundColor(.secondary)
            
            //  i want ti center this image
            AsyncImage(url: URL(string: "https://aquaguard-tux1.onrender.com/images/post/\(post.postImage)")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Fit the content in the current view size
                        .frame(height: 200) // Set the frame height
                        .frame(maxWidth: .infinity, alignment: .center) // Set the frame width to be as wide as possible and align it to the center
                case .failure(_):
                    Image(systemName: "photo") // An image to display in case of failure to load
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                case .empty:
                    ProgressView() // An activity indicator until the image loads
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                @unknown default:
                    EmptyView() // Default view in case of unknown phase
                }
            }
            .padding(.bottom) // Add some padding at the bottom
            
            
            Divider()
                .background(Color.darkBlue)
            
            
            HStack {
                // Like icon with label and count
                
                Button(action: {
                    if isLiked {
                        Task {
                            await viewModel.dislikePost(postId: post.idPost)
                            likeCount -= 1
                           
                        }
                    } else {
                        // Like the post
                        Task {
                            await viewModel.likePost(postId: post.idPost)
                            likeCount += 1
                            print(post.userName, "------",viewModel.CurrentUserName,(post.userName == viewModel.CurrentUserName))
                            if(post.userName == viewModel.CurrentUserName){
                                scheduleNotification(title: "Post Liked", contentt: "liked your post",postId: post.idPost,username: post.userName,userImage: post.userImage)
                            }
                            
                        }
                    }
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .pink : .pink)
                    Text("Like \(self.likeCount)").foregroundStyle(Color.black)
                }
                .padding(.trailing, -6)
                
                
                
                
                // this don't want to chage their
                Spacer()
                
                Image(systemName: commentCount > 0 ? "text.bubble.fill" : "text.bubble")
                    .foregroundColor(commentCount > 0 ? .yellow : .yellow )
                    .padding(.trailing, -6)
                Text("Comment \(commentCount)")
                
                Spacer()
                
                
                Button(action: {
                               self.shareItems = ["This is what I want to share from my post."] // Set your sharing content here
                               self.showShareSheet = true
                           }) {
                               Image(systemName: "square.and.arrow.up")
                                   .foregroundColor(Color("babyBlue"))
                               Text("Share 0")
                           }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showShareSheet) {
                        ShareSheetPost(items: shareItems)
                    }
            
            
            
            Divider()
                .background(Color.darkBlue)
            
            HStack {
                // Text field for the comment
                TextField("Add your comment", text:$commentText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1)) // Light gray background
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                // Send button
                Button(action: {
                    Task {
                        await viewModel.addComment(postId:post.idPost, comment: commentText)
                        // static user id
                        commentText = "" // Clear the text field on send
                        if(post.userName == viewModel.CurrentUserName){
                            scheduleNotification(title: "Post Commented", contentt: "comment your post",postId: post.idPost,username: post.userName,userImage: post.userImage)
                        }
                        
                    }
                    
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20) // Adjust size of the icon
                        .padding(10)
                }
                .background(Color.blue) // Use a more appealing color
                .foregroundColor(.white) // White color for the icon
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Message"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
            VStack(spacing: 8) {
                // here i fetch all paosts
                ForEach(post.comments.prefix(2), id: \.id) { comment in
                    CommentCardView(comment: comment)
                }
                
                
                if post.comments.count > 2 {
                    Divider()
                        .background(Color.darkBlue)
                    HStack {
                        
                        Spacer() // Pushes the content to center
                        Text("...")
                            .foregroundColor(Color.darkBlue)
                        NavigationLink(destination: PostDetailView(post: post)) {
                            Text("View more")
                                .foregroundColor(.darkBlue)
                        }
                        Spacer() // Pushes the content to center
                    }
                }
            }
            .padding(.vertical, 5)
            
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        
        .cornerRadius(8)
        .shadow(radius: 4)
        // .padding(5)
        .onAppear {
            checkIfLiked() // Calling the function when the view appears
            
        }
        
    }
    
    func downloadImage(from url: URL, completion: @escaping (URL?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let tempDirURL = FileManager.default.temporaryDirectory
            let localURL = tempDirURL.appendingPathComponent(url.lastPathComponent)
            do {
                try data.write(to: localURL)
                completion(localURL)
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func scheduleNotification( title : String, contentt: String , postId: String, username: String, userImage: String) {
        guard let imageUrl = URL(string: "https://aquaguard-tux1.onrender.com/images/user/\(userImage)") else { return }
print("zzaaaaa77 haya")
        downloadImage(from: imageUrl) { localURL in
            guard let localURL = localURL else { return }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = "\(username) \(contentt)"


            if let attachment = try? UNNotificationAttachment(identifier: "image", url: localURL, options: nil) {
                content.attachments = [attachment]
            }

            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }

}

struct ShareSheetPost: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update the controller in this case
    }
}
struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.darkBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Adjust as needed
    }
}
