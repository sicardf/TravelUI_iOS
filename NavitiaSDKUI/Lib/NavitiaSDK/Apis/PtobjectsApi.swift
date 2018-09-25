//
// PtobjectsApi.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class CoverageLonLatPtObjectsRequestBuilder: NSObject {
    let currentApi: PtobjectsApi

    /**
    * enum for parameter type
    */
    public enum ModelType: String { 
        case network = "network"
        case commercialMode = "commercial_mode"
        case line = "line"
        case lineGroup = "line_group"
        case route = "route"
        case stopArea = "stop_area"
    }
    var q:String? = nil
    var lat:Double? = nil
    var lon:Double? = nil
    var type: [String]? = nil
    var count:Int32? = nil
    var adminUri:[String]? = nil
    var depth:Int32? = nil
    var disableGeojson:Bool? = nil
    var debugURL: String? = nil

    public init(currentApi: PtobjectsApi) {
        self.currentApi = currentApi
    }

    open func withQ(_ q: String?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.q = q
        
        return self
    }
    open func withLat(_ lat: Double?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.lat = lat
        
        return self
    }
    open func withLon(_ lon: Double?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.lon = lon
        
        return self
    }
    open func withType(_ type: [ModelType]?) -> CoverageLonLatPtObjectsRequestBuilder {
        guard let type = type else {
            return self
        }
        
        var items = [String]()
        for item in type {
            items.append(item.rawValue)
        }
        self.type = items

        return self
    }
    open func withCount(_ count: Int32?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.count = count
        
        return self
    }
    open func withAdminUri(_ adminUri: [String]?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.adminUri = adminUri
        
        return self
    }
    open func withDepth(_ depth: Int32?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.depth = depth
        
        return self
    }
    open func withDisableGeojson(_ disableGeojson: Bool?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.disableGeojson = disableGeojson
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoverageLonLatPtObjectsRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{lon};{lat}/pt_objects"

        if let lat = lat {
            let latPreEscape: String = "\(lat)"
            let latPostEscape: String = latPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{lat}", with: latPostEscape, options: .literal, range: nil)
        }

        if let lon = lon {
            let lonPreEscape: String = "\(lon)"
            let lonPostEscape: String = lonPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{lon}", with: lonPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "q": self.q!, 
            "type[]": self.type, 
            "count": self.count?.encodeToJSON(), 
            "admin_uri[]": self.adminUri, 
            "depth": self.depth?.encodeToJSON(), 
            "disable_geojson": self.disableGeojson
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: PtObjects?,_ error: Error?) -> Void)) {
        if (self.q == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : q"])))
        }
        if (self.lat == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
        }
        if (self.lon == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<PtObjects>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.q == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : q"])))
    }
    if (self.lat == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
    }
    if (self.lon == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
    }

    request(self.makeUrl())
        .authenticate(user: currentApi.token, password: "")
        .validate()
        .responseString{ (response: (DataResponse<String>)) in
            switch response.result {
            case .success:
                completion(response.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

open class CoverageRegionPtObjectsRequestBuilder: NSObject {
    let currentApi: PtobjectsApi

    /**
    * enum for parameter type
    */
    public enum ModelType: String { 
        case network = "network"
        case commercialMode = "commercial_mode"
        case line = "line"
        case lineGroup = "line_group"
        case route = "route"
        case stopArea = "stop_area"
    }
    var q:String? = nil
    var region:String? = nil
    var type: [String]? = nil
    var count:Int32? = nil
    var adminUri:[String]? = nil
    var depth:Int32? = nil
    var disableGeojson:Bool? = nil
    var debugURL: String? = nil

    public init(currentApi: PtobjectsApi) {
        self.currentApi = currentApi
    }

    open func withQ(_ q: String?) -> CoverageRegionPtObjectsRequestBuilder {
        self.q = q
        
        return self
    }
    open func withRegion(_ region: String?) -> CoverageRegionPtObjectsRequestBuilder {
        self.region = region
        
        return self
    }
    open func withType(_ type: [ModelType]?) -> CoverageRegionPtObjectsRequestBuilder {
        guard let type = type else {
            return self
        }
        
        var items = [String]()
        for item in type {
            items.append(item.rawValue)
        }
        self.type = items

        return self
    }
    open func withCount(_ count: Int32?) -> CoverageRegionPtObjectsRequestBuilder {
        self.count = count
        
        return self
    }
    open func withAdminUri(_ adminUri: [String]?) -> CoverageRegionPtObjectsRequestBuilder {
        self.adminUri = adminUri
        
        return self
    }
    open func withDepth(_ depth: Int32?) -> CoverageRegionPtObjectsRequestBuilder {
        self.depth = depth
        
        return self
    }
    open func withDisableGeojson(_ disableGeojson: Bool?) -> CoverageRegionPtObjectsRequestBuilder {
        self.disableGeojson = disableGeojson
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoverageRegionPtObjectsRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{region}/pt_objects"

        if let region = region {
            let regionPreEscape: String = "\(region)"
            let regionPostEscape: String = regionPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{region}", with: regionPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "q": self.q!, 
            "type[]": self.type, 
            "count": self.count?.encodeToJSON(), 
            "admin_uri[]": self.adminUri, 
            "depth": self.depth?.encodeToJSON(), 
            "disable_geojson": self.disableGeojson
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: PtObjects?,_ error: Error?) -> Void)) {
        if (self.q == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : q"])))
        }
        if (self.region == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<PtObjects>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.q == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : q"])))
    }
    if (self.region == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
    }

    request(self.makeUrl())
        .authenticate(user: currentApi.token, password: "")
        .validate()
        .responseString{ (response: (DataResponse<String>)) in
            switch response.result {
            case .success:
                completion(response.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}



open class PtobjectsApi: APIBase {
    let token: String

    public init(token: String) {
        self.token = token
    }

    public func newCoverageLonLatPtObjectsRequestBuilder() -> CoverageLonLatPtObjectsRequestBuilder {
        return CoverageLonLatPtObjectsRequestBuilder(currentApi: self)
    }
    public func newCoverageRegionPtObjectsRequestBuilder() -> CoverageRegionPtObjectsRequestBuilder {
        return CoverageRegionPtObjectsRequestBuilder(currentApi: self)
    }
}
