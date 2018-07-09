//
//  NavitiaSDKPartnersKeolisAccountManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 23/03/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(KeolisAccountManagementConfiguration) public class KeolisAccountManagementConfiguration : NSObject, AccountManagementConfiguration {
    
    public var network : String
    public var encodedSecretClient64Oauth : String
    public var encodedSecretClient64WS : String
    
    public let type : AccountManagementType = .Keolis
    public let url : String = (NavitiaSDKPartners.shared.environment == .Preprod ? "https://preprod-moncompte.keolis.com" : "https://moncompte.keolis.com")
    public let typeFlux : String = "QU"
    public let ssaEmeteur : String = "WEB"
    public let ssaRecepteur : String = "CRM"
    public let hmacKey : String = "316imSTTnDvoeFc08TFpxg=="
    
    public init(network : String, encodedSecretClient64Oauth : String, encodedSecretClient64WS : String) {
        
        self.network = network
        self.encodedSecretClient64Oauth = encodedSecretClient64Oauth
        self.encodedSecretClient64WS = encodedSecretClient64WS
    }
    
}