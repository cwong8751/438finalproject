//
//  TabBarController.swift
//  workkie
//
//  Created by Carl on 11/28/24.
//

import Foundation

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func isLoggedIn() -> Bool {
        
        if let user = UserDefaults.standard.string(forKey: "loggedInUserID"),
           !user.isEmpty,
           let username = UserDefaults.standard.string(forKey: "loggedInUsername"),
           !username.isEmpty {
            
            return true
        }
        return false
    }
    
    // UITabBarControllerDelegate method to handle tab selection
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let viewControllers = tabBarController.viewControllers,
           let selectedIndex = viewControllers.firstIndex(of: viewController),
           selectedIndex == 2{
            
            if isLoggedIn() {
                return true
            }
            else{
                if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                    present(loginVC, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
}
