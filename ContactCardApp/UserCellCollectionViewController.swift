//
//  UserCellCollectionViewController.swift
//  ContactCardApp
//
//  Created by Jordy Sipkema on 04/09/2017.
//  Copyright © 2017 Jordy Sipkema. All rights reserved.
//

import UIKit

private let reuseIdentifier = "userCell"
private let itemsPerRow: CGFloat = 3
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class UserCellCollectionViewController: UICollectionViewController {
    
    var results: [ApiResults.ResultsElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        self.requestUsers(numberOfUsers: 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestUsers(numberOfUsers: Int) {
        let url = URL(string: "https://randomuser.me/api/?results=\(numberOfUsers)")
        
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
            
            let json = JSON(data)
            let response = ApiResults(json: json)
            self.results = response.results
            
            print("Got \(self.results.count) items from the api.")
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
        task.resume()
    }
    
    func photoForIndexPath(indexPath: IndexPath) -> ApiResults.ResultsElement {
        return self.results[(indexPath as NSIndexPath).item];
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        print("Segue to \(String(describing: segue.identifier))")
        
        if (segue.identifier == "UserDetailSegue") {
            if let destination = segue.destination as? UserDetailViewController {
                let index = self.collectionView?.indexPathsForSelectedItems?.first
                destination.selectedUser = self.results[index!.item]
            }
        }
        
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UserPhotoCell

        let userProfile = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        
        let url = URL(string: userProfile.picture.large)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.userImage.image = UIImage(data: data!)
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

class UserPhotoCell: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageView!
}

extension UserCellCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
