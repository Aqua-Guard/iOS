//
//  PostViewModel.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 30/11/2023.
//

import Foundation
class PostViewModel : ObservableObject {
    @Published var posts :[PostModel]? = []
    private var likes: [String: Bool] = [:]
    private var likeCounts: [String: Int] = [:]
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    @Published var toastMessageComment: String = ""
    @Published var showToastComment: Bool = false
    
    
    @Published var isError = false // Track if an error occurred
    @Published var errorMessage = ""
    
    @Published var alertMessageCreationPost: String = ""
    @Published var createdPostAlert: Bool = false
    @Published var createdwithSucsess: Bool = false
    
    @Published var updatedwithSucsess: Bool = false
    @Published var alertMessageUpdatePost: String = ""
    @Published var updatePostAlert: Bool = false

    @Published var CurrentUserId : String = "656e34802b507c8255ffd9c6"
    @Published var CurrentUserName : String = "youssef farhat"
    @Published var CurrentUserImage : String = "1701721216200.jpg"
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTZlMzQ4MDJiNTA3YzgyNTVmZmQ5YzYiLCJ1c2VybmFtZSI6InlvdXNzZWYiLCJpYXQiOjE3MDI1OTc4MzIsImV4cCI6MTcwMjYwNTAzMn0.0yAsAs-wo-QvZqmZZSCnP4dHZ_tjYtwONTczkgDJjKY"
    
    @Published var aiDescription: String = ""
    
    func updatePost(postId : String ,description: String) async {
            do {
                let success = try await PostWebService.updatePost(postId : postId ,token: token, description: description)
            
                if success {
                    
                    // Assuming getPosts() is already implemented and it updates the 'posts' array.
                    // await getPosts()
                    DispatchQueue.main.async {
                        print("the new desss" ,description)
                        self.updatedwithSucsess = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    if (description.split(separator: " ").count < 3) {
                        self.alertMessageUpdatePost = "Description is too short."
                    }
                    else{
                        self.alertMessageUpdatePost = "The description contains inappropriate language."
                    }
                  
                    self.updatePostAlert = true
                    
                }
            }
        }
    func createPost(description: String, image: Data) async {
            do {
                let success = try await PostWebService.createPost(token: token, description: description, imageData: image)
            
                if success {
                    
                    // Assuming getPosts() is already implemented and it updates the 'posts' array.
                    await getPosts()
                    DispatchQueue.main.async {
                                   self.createdwithSucsess = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    if (description.split(separator: " ").count < 3) {
                        self.alertMessageCreationPost = "Description is too short."
                    }
                    else{
                        self.alertMessageCreationPost = "The description contains inappropriate language."
                    }
                  
                    self.createdPostAlert = true
                    
                }
            }
        }
    
    func getPosts() async {
        do {
            let posts = try await PostWebService.getPostsData(token: token)
            DispatchQueue.main.async {
                self.posts = posts
                
            }
        }catch (let error){
            print(error.localizedDescription)
        }
    }
    func getMyPosts() async {
        do {
            let posts = try await PostWebService.getMyPostsData(token: token)
            DispatchQueue.main.async {
                self.posts = posts
                self.isError = false // Reset error state
            }
        } catch {
            DispatchQueue.main.async {
                self.isError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
        func addComment(postId: String, comment: String) async {
            do {
                _ = try await PostWebService.addComment(postId: postId, comment: comment, token: token)
                let posts = try await PostWebService.getPostsData(token: token)
                DispatchQueue.main.async {
                    self.posts = posts
                }
                alertMessage = "Comment added successfully"
            } catch {
                alertMessage = error.localizedDescription
            }
            showAlert = true
        }
        
        
        func deleteComment(postId: String, commentId: String) async {
            do {
                // Call the network service to delete the comment
                try await PostWebService.deleteComment(commentId: commentId, token: self.token)
                
                
                DispatchQueue.main.async {
                    if let postIndex = self.posts!.firstIndex(where: { $0.idPost == postId }),
                       let commentIndex = self.posts![postIndex].comments.firstIndex(where: { $0.idComment == commentId }) {
                        self.posts![postIndex].comments.remove(at: commentIndex)
                    }
                }
            } catch {
                // Handle any errors, e.g., show an error message
                print("Error deleting comment: \(error.localizedDescription)")
            }
        }
        
        func updateComment(postId: String, commentId: String, newCommentText: String) async {
            do {
                try await PostWebService.updateComment(commentId: commentId, newComment: newCommentText, token: self.token)
                DispatchQueue.main.async {
                    if let postIndex = self.posts!.firstIndex(where: { $0.idPost == postId }),
                       let commentIndex = self.posts![postIndex].comments.firstIndex(where: { $0.idComment == commentId }) {
                        self.posts![postIndex].comments[commentIndex].comment = newCommentText
                    }
                }
                DispatchQueue.main.async {
                    // Update the comment in your local array if needed
                    self.toastMessageComment = "Comment updated successfully"
                    self.showToastComment = true
                    
                }
            } catch {
                DispatchQueue.main.async {
                    self.toastMessageComment = "Failed to update comment: \(error.localizedDescription)"
                    self.showToastComment = true
                }
            }
        }
        
        func likePost(postId: String) async {
            do {
                try await PostWebService.addLike(to: postId, withToken: self.token)
                // Update local post model to reflect the like
            } catch {
                // Handle errors such as displaying an alert to the user
            }
        }
        
        func dislikePost(postId: String) async {
            do {
                try await PostWebService.dislikePost(with: postId, andToken: self.token)
                // Update local post model to reflect the dislike
            } catch {
                // Handle errors such as displaying an alert to the user
            }
        }
        
        func checkIfPostIsLiked(postId: String) async -> Bool {
            do {
                return try await PostWebService.isPostLiked(by: postId, withToken: self.token)
            } catch {
                // Handle error
                print("Error checking if post is liked: \(error)")
                return false
            }
        }
        
        func deletePost(postId: String) async {
            do {
                // Call the network service to delete the post
                try await PostWebService.deletePost(postId: postId, token: self.token)
                DispatchQueue.main.async {
                                self.posts?.removeAll { $0.idPost == postId }
                            }
            } catch {
                // Handle any errors, e.g., show an error message
                print("Error deleting post: \(error.localizedDescription)")
            }
        }
        
    func fetchAIDescription(prompt: String) async {
           do {
               
               // Call the network service to fetch the AI description
               let description = try await PostWebService.fetchAIDescription(for: prompt, withToken: self.token) // the problem here 
          
               // Update the UI on the main thread
               DispatchQueue.main.async {
                   self.aiDescription = description
               }
           } catch {
               // Handle any errors, e.g., show an error message
               print("Error fetching AI description: \(error.localizedDescription)")
           }
       }
        
        //
        //    init(){
        //        let post1 = PostModel(id: "p1", userName: "Youssef Farhat", userRole: "Partner", description: "Dive into the serene beauty of aquatic life with AquaGard! 🐠💧 Whether you're a seasoned aquarist or just starting your water gardening journey, our latest post offers a treasure trove of insights", userImage: "youssef", postImage: "post1", nbLike: 0, nbComments: 1, nbShare: 10, likes: [], comments: [comment1])
        //
        //        let post2 = PostModel(id: "p2", userName: "Malek labidi", userRole: "partner", description: "🐢 Dive into the enchanting world of aquatic turtles! Explore their unique lifestyle and habitat in our latest post.", userImage: "user", postImage: "tortue", nbLike: 2, nbComments: 2, nbShare: 15, likes: [like1, like2], comments: [comment1, comment2,comment1])
        //
        //        let post3 = PostModel(id: "p3", userName: "AlexSmith", userRole: "Traveler", description: "Exploring the world!", userImage: "yousseff", postImage: "tortue", nbLike: 1, nbComments: 1, nbShare: 20, likes: [like2], comments: [comment2])
        //
        //         posts = [post1,post2,post3]
        //    }
        //    func toggleLike(for post: PostModel) {
        //           let isLiked = likes[post.id] ?? false
        //           likes[post.id] = !isLiked
        //           likeCounts[post.id] = (likeCounts[post.id] ?? 0) + (isLiked ? -1 : 1)
        //       }
        //
        //       func isPostLiked(_ post: PostModel) -> Bool {
        //           likes[post.id] ?? false
        //       }
        //
        //       func likeCount(for post: PostModel) -> Int {
        //           likeCounts[post.id] ?? 0
        //       }
        //    func deleteComment(with commentID: String, fromPostWith postID: String) {
        //            // Find the index of the post
        //            if let postIndex = posts.firstIndex(where: { $0.id == postID }) {
        //                // Find the index of the comment
        //                if let commentIndex = posts[postIndex].comments.firstIndex(where: { $0.id == commentID }) {
        //                    // Remove the comment from the post's comments array
        //                    DispatchQueue.main.async {
        //                        self.posts[postIndex].comments.remove(at: commentIndex)
        //                        // Also decrement the nbComments count for the post
        //                        self.posts[postIndex].nbComments -= 1
        //                    }
        //                }
        //            }
        //        }
    }
    
