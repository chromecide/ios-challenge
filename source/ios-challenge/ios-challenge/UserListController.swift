//
//  ViewController.swift
//  ios-challenge
//
//  Created by Justin Pradier on 6/10/16.
//

import UIKit

class UserListController: UIViewController , UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var vwLoadingIndicator: UIView!
    @IBOutlet weak var tblUserList: UITableView!
    
    var userDataLoaded:Bool = false;
    var userData:Array<DataAPI.StructUserData> = Array<DataAPI.StructUserData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblUserList.delegate = self
        tblUserList.dataSource = self
        
        self.reloadData { (loaded) -> Void in
            //done
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadData(callback:(Bool)-> Void){
        dispatch_async(dispatch_get_main_queue(),{
            IOSChallengeAPI.fetchUsers { (fetchedUsers, err) -> Void in
                if(err != nil){
                    //SHOW ERROR
                    print(err)
                }else{
                    self.userData = fetchedUsers
                    self.userDataLoaded = true
                    print(self.userData.count);
                    self.tblUserList.reloadData()
                    dispatch_async(dispatch_get_main_queue(),{
                        self.vwLoadingIndicator.hidden = true
                        self.tblUserList.reloadData()
                        callback(true)
                    })
                }
            }
        })
    }
    
    /*
    UITableViewDelegate
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCellTickable", forIndexPath: indexPath) as UITableViewCell
        
        let userItem:DataAPI.StructUserData = self.userData[indexPath.row]
        
        let contentView = cell.subviews[0]
        let nameLabel = contentView.subviews[0] as! UILabel
        let emailLabel = contentView.subviews[1] as! UILabel
        let townLabel = contentView.subviews[2] as! UILabel
        let image = contentView.subviews[3] as! UIImageView
        
        
        nameLabel.text = userItem.name
        emailLabel.text = userItem.email
        townLabel.text = userItem.town
        
        image.hidden = !DataAPI.StructUserData.isTownMarked(userItem.town)
        
        return cell
    }

}

