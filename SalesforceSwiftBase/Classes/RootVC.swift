/*

 Author: @quintonwall
*/


import UIKit

class RootVC: UIViewController, SFAuthenticationManagerDelegate {
    

    @IBOutlet weak var connectButton: UIButton!
    
    
    @IBOutlet weak var tmpButton: UIButton!
    //  #pragma mark - view lifecycle
    
    override func viewWillAppear(animated: Bool) {
        SFAuthenticationManager.sharedManager().addDelegate(self)
        
        if SFAuthenticationManager.sharedManager().haveValidSession {
            print("VALID")
            dispatch_async(dispatch_get_main_queue()){
                
                self.performSegueWithIdentifier("houseview", sender: self)
                
            }
        }

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " Lightning Realtor"
        
        /*
        SFAuthenticationManager.sharedManager().addDelegate(self)
        
        if SFAuthenticationManager.sharedManager().haveValidSession {
            print("VALID")
            dispatch_async(dispatch_get_main_queue()){
                
                self.performSegueWithIdentifier("houseview", sender: self)
                
            }
        }
*/
    }
    @IBAction func tmpTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("houseview", sender: nil)
    }
    
    @IBAction func connectTapped(sender: AnyObject) {
        
         SalesforceSDKManager.sharedManager().launch()
    }
    
    func authManagerDidFinish(manager: SFAuthenticationManager!, info: SFOAuthInfo!) {
        
        //need to perform this check at the end of the authmanager lifecycle
        //because SFRootViewManager removes the current view after didAUthenticate gets called :(
        
        if SFAuthenticationManager.sharedManager().haveValidSession {
            
            self.performSegueWithIdentifier("houseview", sender: nil)
        }
    }
 
}




