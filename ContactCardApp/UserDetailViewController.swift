//
//  PersonStartViewController.swift
//  ContactCardApp
//
//  Created by Jordy Sipkema on 28/08/2017.
//  Copyright © 2017 Jordy Sipkema. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var FirstNameLabel: UILabel!

    var selectedUser: ApiResults.ResultsElement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setRoundedCornersOfUserImage()
        setUser()
        
//        // Register to UIDeviceOrientationDidChange-event
//        NotificationCenter.default.addObserver(self, selector: #selector(PersonStartViewController.onDeviceRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoundedCornersOfUserImage(){
        print(#file + "+" + #function)
        UserImage.layer.cornerRadius = UserImage.frame.size.width / 2
        UserImage.clipsToBounds = true
        UserImage.layer.borderColor = UIColor.white.cgColor
        UserImage.layer.borderWidth = 3.0
    }
    
    func setUser(){
        print(#file + "+" + #function)
        if let user = selectedUser {
            print(user)
            self.FirstNameLabel.text = user.name.first
            self.LastNameLabel.text = user.name.last
            
            let url = URL(string: user.picture.large)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.UserImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func onDeviceRotate(){
        setRoundedCornersOfUserImage()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
