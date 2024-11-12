Task{
            do{
                let _ = try await dbManager.connect(uri: URI)
                
                // get all posts
                let posts = try await self.dbManager.getAllPosts() ?? []
                //print("all posts: \(posts)")
                
                // get one post
                let post = try await dbManager.getPost(id: ObjectId("672fd596c66d52147f2abf05")!)
                print("post: \(post)")
                
                // insert post
                let iPost = Post(author: "author3", content: "content3", date: Date(), title: "title3", comments: ["comment0", "comment1"])
                try await dbManager.insertPost(post: iPost)
                
                // delete post test
                try await dbManager.deletePost(postId: ObjectId("672fcf85c66d52147f2abf00")!)
            }
            catch {
                print(error)
            }Ï
}
