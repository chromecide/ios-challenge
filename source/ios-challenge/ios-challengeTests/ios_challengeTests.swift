//
//  ios_challengeTests.swift
//  ios-challengeTests
//
//  Created by Justin Pradier on 6/10/16.
//

import XCTest
@testable import ios_challenge

class ios_challengeTests: XCTestCase {
    class TestAPI: ios_challenge.DataAPI {
        override func fetchUsers(callback:(Array<StructUserData>, String?)-> Void){
            
            let user1 = StructUserData(id: 1, name: "User 1", email: "user1Email@testing.test", town: "Wodonga")
            let user2 = StructUserData(id: 2, name: "User 2", email: "user2Email@testing.test", town: "South Christy")
            
            var userList = Array<StructUserData>()
            userList.append(user1)
            userList.append(user2)
            
            callback(userList, nil)
        }
    }
    
    var userListController: ios_challenge.UserListController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ios_challenge.IOSChallengeAPI = TestAPI("") as ios_challenge.DataAPI
        
        userListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserListView") as! ios_challenge.UserListController
        
        let _ = userListController.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTownMarking() {
        let readyEx = expectationWithDescription("ready")
        
        userListController.reloadData { (loaded) -> Void in
            readyEx.fulfill()
            XCTAssertTrue(loaded, "Data Was Loaded")
            //check that an item without an appropriate town is NOT ticked
            let item1IndexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            let image1Cell = self.userListController.tblUserList.cellForRowAtIndexPath(item1IndexPath)! as UITableViewCell
            
            let image1ContentView = image1Cell.subviews[0]
            let image1View = image1ContentView.subviews[3]
            XCTAssertTrue(image1View.hidden, "Tick Graphic Should be hidden")
            
            //check that an item without an appropriate town is IS ticked
            let item2IndexPath = NSIndexPath(forRow: 1, inSection: 0)
            
            let image2Cell = self.userListController.tblUserList.cellForRowAtIndexPath(item2IndexPath)! as UITableViewCell
            let image2ContentView = image2Cell.subviews[0]
            let image2View = image2ContentView.subviews[3]
            XCTAssertFalse(image2View.hidden, "Tick Graphic Should not be hidden")
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler:nil)

    }
}
