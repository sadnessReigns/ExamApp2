//
//  NetworkManager.swift
//  ExamApp2
//
//  Created by Vladislav McKay on 7/22/20.
//  Copyright © 2020 Vladislav McKay. All rights reserved.
//

import Foundation

class NetworkManager {
 
    let requestURL = URL(string: "https://my.api.mockaroo.com/people.json?key=e1e89470")
    
    func getPeople (urlSession: URLSession, completion: @escaping (([Person]) -> Void))  {
        var peopleToReturn: [Person] = []
         let task = urlSession.dataTask(with: requestURL!) {
            
            (data, response, error) in
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                
                var jsonDict: [String:Any] = [:]
                
                for singlePersonFromRequest in json {
                    jsonDict =  singlePersonFromRequest as! [String : Any]
                    
                    peopleToReturn.append(Person.init(age: jsonDict["age"] as? Int, firstName: jsonDict["first_name"] as? String, lastName: jsonDict["last_name"] as? String, email: jsonDict["email"] as? String, gender: jsonDict["gender"] as? String, ipAddress: jsonDict["ip_address"] as? String))
                }
                
                completion(peopleToReturn)
            } catch let jsonError {
                print(jsonError)
            }
            
        }
        
        task.resume()
        
        
    }
    
}
