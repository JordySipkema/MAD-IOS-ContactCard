//
//  PersonStartViewController.swift
//  ContactCardApp
//
//  Created by Jordy Sipkema on 28/08/2017.
//  Copyright © 2017 Jordy Sipkema. All rights reserved.
//

import UIKit

class PersonStartViewController: UIViewController {
    
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setRoundedCornersOfUserImage()
        
        // Register to UIDeviceOrientationDidChange-event
        NotificationCenter.default.addObserver(self, selector: #selector(PersonStartViewController.onDeviceRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoundedCornersOfUserImage(){
        UserImage.layer.cornerRadius = UserImage.frame.size.width / 2
        UserImage.clipsToBounds = true
        UserImage.layer.borderColor = UIColor.white.cgColor
        UserImage.layer.borderWidth = 3.0
    }
    
    func onDeviceRotate(){
        setRoundedCornersOfUserImage()
    }

    @IBAction func refreshOnClick(_ sender: Any) {
        requestUser()
    }
    
    func updateUser(firstName: String, lastName: String, imageUrl: String){
        DispatchQueue.main.async {
            self.FirstNameLabel.text = firstName.capitalized
            self.LastNameLabel.text = lastName.uppercased()
            self.UserImage.image = #imageLiteral(resourceName: "AvatarPlaceholder")
            
            let url = URL(string: imageUrl);
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!);
                DispatchQueue.main.async {
                    self.UserImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func requestUser(){
        let url = URL(string: "https://randomuser.me/api")
        
        let task = URLSession.shared.dataTask(with: url!) {
            data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Data is empty...")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            for result in results! {
                let name = result["name"] as? [String: Any]
                let firstName = name?["first"] as? String
                let lastName = name?["last"] as? String
                let pictureInfo = result["picture"] as? [String: Any]
                let imageUrl = pictureInfo?["large"] as? String
                
            self.updateUser(firstName: firstName!, lastName: lastName!, imageUrl: imageUrl!)
            }
        }
        
        task.resume()
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
