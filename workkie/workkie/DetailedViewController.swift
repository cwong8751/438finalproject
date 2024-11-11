//
//  DetailedViewController.swift
//  workkie
//
//  Created by Sang Won Bae on 11/10/24.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var image: UIImage?
    var imageName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let theImageFrame = CGRect(x: view.frame.midX - (image?.size.width ?? 0)/2, y: 120, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        view.addSubview(imageView)
        
        let theTextFrame = CGRect(x: 0, y: image?.size.height ?? 0 + 120, width: view.frame.width, height: 30)
        
        let textView = UILabel(frame: theTextFrame)
        textView.text = imageName
        textView.textAlignment = .center
        view.addSubview(textView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
