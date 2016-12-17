//
//  NetworkManager.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/17/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

import Alamofire

class NetworkManager {
    let manager = Manager
    init() {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://api.medhub.vn": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            ),
            "https://api.medhub.vn": .disableEvaluation
        ]
        
        let manager = Alamofire.Manager(
            configuration: URLSessionConfiguration.defaultSessionConfiguration(),
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
}
