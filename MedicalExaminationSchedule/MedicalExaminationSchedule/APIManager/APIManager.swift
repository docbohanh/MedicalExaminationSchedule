//
//  APIManager.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/11/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Alamofire

typealias ServiceResponse = (AnyObject, NSError?) -> Void
typealias AlamofireResponse = (DataResponse<Any>) -> Void

public var acceptSelfSignedCertificate = true
public var url : URL?
class APIManager: NSObject,URLSessionDelegate {
    static let sharedInstance = APIManager()
    
    static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://api.medhub.vn/": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
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
    
    func postDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let urlString = REST_API_URL + url
        APIManager.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
//                print(response)
        }
    }
    
    func getDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = REST_API_URL + url + "?" + parameterString
        
        APIManager.Manager.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
//                print(response)
        }
    }
    
    func postImage(url : String,image : UIImage,onCompletion: @escaping AlamofireResponse) {
        
        let requestURL = REST_API_URL + url// + "/post"
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        Alamofire.upload(imageData!, to: requestURL).responseJSON { response in
            onCompletion(response)
        }
        
    }
    
    func uploadImage(url : String, image: UIImage, param: [String:String], completion: @escaping AlamofireResponse) {
        let requestURL = REST_API_URL + url
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        APIManager.Manager.upload(
            multipartFormData: { multipartFormData in
//                multipartFormData.append(imageData!, withName: "image", mimeType: "image/png")
                multipartFormData.append(imageData!, withName: "image")
                for (key, value) in param {
                    print("\(key) -> \(value)")
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
}
