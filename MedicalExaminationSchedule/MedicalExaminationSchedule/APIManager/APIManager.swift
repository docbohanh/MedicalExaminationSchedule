//
//  APIManager.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/11/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
typealias ServiceResponse = (AnyObject, NSError?) -> Void
public var acceptSelfSignedCertificate = true
public var url : URL?
class APIManager: NSObject,URLSessionDelegate {
    static let sharedInstance = APIManager()
    
    func makeHTTPGetRequest(path: String, param:[String:AnyObject], onCompletion: @escaping ServiceResponse) {
        let parameterString = param.stringFromHttpParameters()
        let requestURL = URL(string:"\(path)?\(parameterString)")!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//            let json:JSON = JSON(data: data)
            if (data != nil) {
                guard let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] else { return }
                print("json:", json)
                onCompletion(json as AnyObject, error as NSError?)
            }else{
                print("Error !!! %@",(error as! NSError).description)
                onCompletion("" as AnyObject, error as NSError?)
            }
        })
        task.resume()
    }
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        var request = URLRequest(url: NSURL(string: path) as! URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set the method to POST
        request.httpMethod = "POST"
        
        // Set the POST body for the request
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if (data != nil) {
                print("data != nil")
                 guard let json = try! JSONSerialization.jsonObject(with: data!, options:[]) as? [String: AnyObject] else { return }
                onCompletion(json as AnyObject, error as NSError?)
            } else {
                print("data == nil")
                print("Error !!! %@",(error as! NSError).description)
                onCompletion("" as AnyObject, error as NSError?)
            }
        })
        task.resume()
    }
    
    @objc public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(acceptSelfSignedCertificate && challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == url.host) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential);
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }

}
