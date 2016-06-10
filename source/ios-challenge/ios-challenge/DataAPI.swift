//
//  DataAPI.swift
//  ios-challenge
//
//  Created by Justin Pradier on 6/10/16.
//  Copyright © 2016 Chromecide. All rights reserved.
//

import Foundation

class DataAPI{
    class StructUserData{
        var id:Int
        var name:String
        var email:String
        var town:String
        
        init(id:Int, name:String, email:String, town:String){
            self.id = id
            self.name = name
            self.email = email
            self.town = town
        }
        
        static func isTownMarked(townName:String) -> Bool {
            return (townName=="McKenziehaven" || townName == "South Christy")
        }
    }
    
    var adapter:APIAdapter
    var jsonEndPoint:String = ""
    
    
    init(_ baseURI:String   ){
        if((baseURI) != ""){
            self.jsonEndPoint = baseURI
        }
        
        adapter = httpAdapter(baseURI: self.jsonEndPoint)
    }
    
    func fetchUsers(callback:(Array<StructUserData>, String?)-> Void){
        let queryParams = NSDictionary()
        adapter.get("/users", queryParams:queryParams){
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if error != nil {
                callback(Array<StructUserData>(), error)
            } else {
                if(data["rows"] != nil){
                    var fetchedData:Array< StructUserData > = Array < StructUserData >()
                    
                    if let rows:Array<AnyObject> = (data ["rows"] as! Array<AnyObject>){
                        for u in rows {
                            let userItem = u as! [String:AnyObject]
                            let itemId = userItem ["id"] as! Int
                            let itemName = userItem ["name"] as! String
                            let itemEmail = userItem ["email"] as! String
                            var itemTown = "";
                            if let ia:AnyObject = userItem["address"]{
                                let itemAddress = ia as! [String:AnyObject]
                                itemTown = (itemAddress ["city"] as? String)!
                            }
                            
                            let userS = StructUserData(id: itemId, name: itemName, email: itemEmail, town: itemTown)
                            
                            fetchedData.append(userS);
                        }
                    }
                    
                    callback(fetchedData, nil);
                    
                }else{
                    callback(Array<StructUserData>(), "Error Fetching User List")
                }
                
            }
        }
    }
}

var IOSChallengeAPI:DataAPI = DataAPI("http://jsonplaceholder.typicode.com");