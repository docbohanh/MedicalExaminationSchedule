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
    
//    static var Manager: Alamofire.SessionManager = {
//        
//        // Create the server trust policies
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "https://api.medhub.vn/": .disableEvaluation
//        ]
//        
//        // Create custom manager
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//        let manager = Alamofire.SessionManager(
//            configuration: URLSessionConfiguration.default,
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//        )
//        
//        return manager
//    }()
    
    static var Manager: Alamofire.SessionManager = {
        // Set up certificates
        let pathToCert = Bundle.main.path(forResource: "github.com", ofType: "cer")
        let localCertificate = NSData(contentsOfFile: pathToCert!)
        let certificates = [SecCertificateCreateWithData(nil, localCertificate!)!]
        
        let hostname = "https://api.medhub.vn"
        
        // Configure the trust policy manager
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true
        )
        let serverTrustPolicies = [hostname: serverTrustPolicy]
        
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        // Configure session manager with trust policy
        let afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: serverTrustPolicyManager
        )
        
        return afManager
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
        }
    }
    
    func getDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = REST_API_URL + url + "?" + parameterString
        
        APIManager.Manager.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
        }
    }

    func getDataFromFullUrl(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL =  url + "?" + parameterString
        
        APIManager.Manager.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
        }
    }
    
    func putDataToURL(url:String, parameters:[String:String], onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = REST_API_URL + url + "?" + parameterString
        APIManager.Manager.request(requestURL, method: .put, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
        }
    }
    
    func deleteDataToURL(url:String, parameters:[String:String], onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = REST_API_URL + url + "?" + parameterString
        APIManager.Manager.request(requestURL, method: .delete, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
        }
    }
    
    func uploadImage(url : String, image: UIImage, param: [String:String], completion: @escaping AlamofireResponse) {
        let requestURL = REST_API_URL + url
        APIManager.Manager.upload(
            multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
                }
                
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
                        completion(response)
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    completion(DataResponse.init(request: nil, response: nil, data: nil, result: Result.failure(encodingError)))
                }
        })
    }

}
