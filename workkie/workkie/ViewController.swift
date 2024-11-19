//
//  ViewController.swift
//  workkie
//
//  Created by Carl on 11/3/24.
//

import UIKit
import BSON
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dbManager = MongoTest()

    
    let tableData: [Post] = [
        Post(author: "sophyRidge", content: "A day to think of the sacrifice made by those poor boys for their country and for all of us. And it's also a day when so many of us will have someone in particular that we'll be thinking about - I certainly will, I'm sure you will too.", date: Date(), title: "Are ministers playing politics with their outrage over protests?", comments: []),
        Post(author: "samCoates", content: "That is the flavour of the questions facing Sir Keir today after he walked up the plane steps to resume globetrotting, spending the morning in Paris meeting President Macron before a further five-hour flight to the COP29 climate change summit in the oil-rich capital of Azerbaijan, Baku.", date: Date(), title: "Can spending time abroad help Starmer's domestic agenda?", comments: []),
        Post(author: "jonCraig", content: "Mr Sunak said his 'working assumption' was the election would be in the second half of this year. And, to be fair, he was true to his word - just - with a 4 July poll.", date: Date(), title: "What if Rishi Sunak had waited until now to call an election?", comments: []),
        Post(author: "aliFortescue", content: "On a trip to talk about immigration, the questions following her are about pro-Palestinian protests and her claim homeless people pitching tents are making a 'lifestyle choice.'", date: Date(), title: "Does Suella Braverman relish her position as the most controversial minister in the cabinet?", comments: []),
        Post(author: "bethRigby", content: "The lingering question is whether, as some MPs privately warn, Badenoch can survive to the next election, given that she won the support of only a third of Conservative MPs in the leadership race.", date: Date(), title: "Kemi Badenoch will be looking over her shoulder after less than emphatic victory", comments: []),
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return theData.count
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        cell.textLabel!.text = theData[indexPath.row].name
//        cell.imageView?.image = theImageCache[indexPath.row]
        let post = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.postAuthor.text = post.author
        cell.postContent.text = post.content
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        cell.postDate.text = dateString
        cell.postTitle.text = post.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedVC = DetailedViewController()
//        detailedVC.image = theImageCache[indexPath.row]
//        detailedVC.imageName = theData[indexPath.row].name
        
        detailedVC.author = tableData[indexPath.row].author
        detailedVC.content = tableData[indexPath.row].content
        detailedVC.postTitle = tableData[indexPath.row].title
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        detailedVC.date = dateString
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView() {
        let url = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        Task {
            do{
                try await dbManager.connect(uri: url)
                
                // get list of posts, [Post]
                let gotPosts = try await self.dbManager.getAllPosts() ?? []
                
                if gotPosts.isEmpty {
                    // error check
                }
                else{
                    // process the rest
                }
                
                
                // access a post
                // when the user clicks on one of the posts from the list, you
                // open a new page to show that specific post
//                let post = try await self.dbManager.getPost(id: ObjectId)
                
                // insert a post, when the user wants to create their own post
                let arbitraryPost = Post(author: "author1", content: "content1", date: Date(), title: "title", comments: ["comment"])
                let postResult = try await self.dbManager.insertPost(post: arbitraryPost)
                
                // delete a post
                // need to grab post from somewhere, grab the post id
//                let deleteResult = try await self.dbManager.deletePost(postId: <#T##ObjectId#>)
                
                // postresult and deleteresult both return booleans
//                if deleteResult {
//                    // delete success
//                }
//                else{
//                    // delete failed
//                }
                
// NOTE FOR CARL: The two lines of code below are commented out to enable the mapping feature.
// The mapping functionality requires latitude and longitude values to be saved for each user.


//                Creating a new user
//                let user = User(username: "", password: "")
//               try await self.dbManager.insertUser(user: user)
                
                
            }
            catch {
                // catch error
            }
        }
//        let data = try! Data(contentsOf: url!)
//        theData = try! JSONDecoder().decode([Info].self, from:data)
    }
    
    func cacheImages() {
//        for item in theData {
//            let url = URL(string: item.image_url)
//            let data = try? Data(contentsOf: url!)
//            let image = UIImage(data: data!)
//            theImageCache.append(image!)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
//        setupTableView()
//        fetchDataForTableView()
//        cacheImages()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
}

