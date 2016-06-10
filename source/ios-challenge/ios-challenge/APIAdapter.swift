//
//  APIAdapter.swift
//
//  Created by Justin 'Chromecide' Pradier.
//

import Foundation

class APIAdapter {
    func get(path:String, queryParams:NSDictionary?, callback: (Dictionary<String, AnyObject>, String?) -> Void){}
    func post(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){}
    func put(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){}
    func delete(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){}
    func patch(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){}
}

class httpAdapter :APIAdapter{
    var baseURI:String = ""
    
    init(baseURI:String, basePort:Int? = 443){
        self.baseURI = baseURI
    }
    
    func sendHTTPRequest(request: NSMutableURLRequest,callback: (Dictionary<String, AnyObject>, String?) -> Void) {

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), (error!.localizedDescription) as String)
                } else {
                    var unparsedString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    let dataLength:Int = (unparsedString?.length)!;

                    if(dataLength == 0){
                        callback(Dictionary<String, AnyObject>(), nil);
                    }else{
                        if(unparsedString?.substringToIndex(1)=="["){
                            unparsedString = "{\"rows\":" + (unparsedString! as String) + "}";
                        }
                        
                        let parsedJSON = self.parseJSONResponse(unparsedString as! String)
                        callback(parsedJSON,nil)
                    }
                    
                    
                }
        })
        
        task.resume()

    }
    
    func parseJSONResponse(jsonString:String) -> Dictionary<String, AnyObject> {
        
        if let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding){
                
                do{
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                        data,
                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                            return jsonObj
                    }
                }catch{
                    print("Error")
                }
        }
        return [String: AnyObject]()
    }
    
    override func get(path: String, queryParams: NSDictionary?, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        var paramString:String = ""
        
        if(queryParams?.count > 0){
            for (paramName, paramValue) in queryParams! {
                if(paramString != ""){
                    paramString = paramString+"&"
                }
                paramString=paramString+(paramName as! String)+"="+(paramValue as! String)
            }
        }
        
        var requestURI = self.baseURI+path;

        if(paramString != ""){
         requestURI = requestURI + "?"+paramString
        }
        let request = NSMutableURLRequest(URL: NSURL(string: requestURI)!)
        request.HTTPMethod = "GET"
        print("SENDING REQUEST:"+(request.URL!.absoluteString))
        
        sendHTTPRequest(request, callback: callback)
    }
    
    override func post(path:String, queryParams:NSDictionary?, body:NSData,callback: (Dictionary<String, AnyObject>, String?) -> Void){
        var paramString:String = ""
        
        if(queryParams?.count > 0){
            for (paramName, paramValue) in queryParams! {
                if(paramString != ""){
                    paramString = paramString+"&"
                }
                paramString=paramString+(paramName as! String)+"="+(paramValue as! String)
            }
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.baseURI+path+"?"+paramString)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = body
        
        sendHTTPRequest(request, callback: callback)
    }
    
    override func put(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){
        var paramString:String = ""
        
        if(queryParams?.count > 0){
            for (paramName, paramValue) in queryParams! {
                if(paramString != ""){
                    paramString = paramString+"&"
                }
                paramString=paramString+(paramName as! String)+"="+(paramValue as! String)
            }
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.baseURI+path+"?"+paramString)!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "PUT"
        request.HTTPBody = body
        print("PUTing REQUEST:"+(request.URL!.absoluteString))
        sendHTTPRequest(request, callback: callback)
    }
    
    override func patch(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: self.baseURI+path)!)
        request.HTTPMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sendHTTPRequest(request, callback: callback)
    }
    
    override func delete(path:String, queryParams:NSDictionary?, body:NSData, callback: (Dictionary<String, AnyObject>, String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: self.baseURI+path)!)
        request.HTTPMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sendHTTPRequest(request, callback: callback)
    }
    
}

