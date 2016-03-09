//
//  PropertyViewController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/9/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import SalesforceRestAPI
import SwiftyJSON


class PropertyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var houses = [House]()
    var refreshControl: UIRefreshControl!
    
    private let reuseIdentifier = "HouseCell"
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 3.0, bottom: 5.0, right: 3.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(self.refreshControl)
       self.collectionView.alwaysBounceVertical = true
      
        fetchProperties()
        
    }
    
    func refresh(sender:AnyObject)
    {
        houses.removeAll()
        fetchProperties()
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProperties() {
        let sharedInstance = SFRestAPI.sharedInstance()
        
        let query = String("select count(id), house__c, house__r.Default_picture_URL__c from Lead where LeadSource = 'Mobile App' group by house__r.Default_picture_URL__c, house__c order by count(id) DESC")
        
        sharedInstance.performSOQLQuery(query, failBlock: { error in
                //TODO: error popup
                print(error)
            }) { response in  //success
   
                let json = JSON(response)
                
                
                for (key,subJson):(String, JSON) in json["records"] {
                    let h :House = House()
                    h.houseId = subJson["House__c"].string!
                    h.likes = subJson["expr0"].int!
                    h.pictureUrl = subJson["Default_picture_URL__c"].string!
                    self.houses.append(h)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView?.reloadData()
                }
               
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: UICollectionViewDataSource
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      
        return 1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return houses.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HouseCell
  
        let h : House = houses[indexPath.row]
        // Configure the cell
        cell.numLikes.text = String(h.likes)
        cell.houseId = h.houseId
        cell.propertyImageUrl = h.pictureUrl
  
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 183, height: 183)
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
   
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */


}
