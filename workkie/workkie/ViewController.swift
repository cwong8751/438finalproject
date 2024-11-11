//
//  ViewController.swift
//  workkie
//
//  Created by Carl on 11/3/24.
//

import UIKit
import BSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = theData[indexPath.row].name
        cell.imageView?.image = theImageCache[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.imageName = theData[indexPath.row].name
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView() {
        let url = URL(string: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode([Info].self, from:data)
    }
    
    func cacheImages() {
        for item in theData {
            let url = URL(string: item.image_url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTableView()
        fetchDataForTableView()
        cacheImages()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
}

