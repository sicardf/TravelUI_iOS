//
// PlaceUriApi.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class CoverageLonLatPlacesIdRequestBuilder: NSObject {
    let currentApi: PlaceUriApi

    /**
    * enum for parameter addPoiInfos
    */
    public enum AddPoiInfos: String { 
        case bssStands = "bss_stands"
        case carPark = "car_park"
        case empty = ""
        case _none = "none"
    }
    var lat:Double? = nil
    var lon:Double? = nil
    var id:String? = nil
    var bssStands:Bool? = nil
    var addPoiInfos: [String]? = nil
    var disableGeojson:Bool? = nil
    var debugURL: String? = nil

    public init(currentApi: PlaceUriApi) {
        self.currentApi = currentApi
    }

    open func withLat(_ lat: Double?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.lat = lat
        
        return self
    }
    open func withLon(_ lon: Double?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.lon = lon
        
        return self
    }
    open func withId(_ id: String?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.id = id
        
        return self
    }
    open func withBssStands(_ bssStands: Bool?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.bssStands = bssStands
        
        return self
    }
    open func withAddPoiInfos(_ addPoiInfos: [AddPoiInfos]?) -> CoverageLonLatPlacesIdRequestBuilder {
        guard let addPoiInfos = addPoiInfos else {
            return self
        }
        
        var items = [String]()
        for item in addPoiInfos {
            items.append(item.rawValue)
        }
        self.addPoiInfos = items

        return self
    }
    open func withDisableGeojson(_ disableGeojson: Bool?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.disableGeojson = disableGeojson
        
        return self
    }

    open func withDebugURL(_ debugURL: String?) -> CoverageLonLatPlacesIdRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{lon};{lat}/places/{id}"

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

        if let id = id {
            let idPreEscape: String = "\(id)"
            let idPostEscape: String = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "bss_stands": self.bssStands, 
            "add_poi_infos[]": self.addPoiInfos, 
            "disable_geojson": self.disableGeojson
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: Places?,_ error: Error?) -> Void)) {
        if (self.lat == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
        }
        if (self.lon == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
        }
        if (self.id == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<Places>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.lat == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
    }
    if (self.lon == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
    }
    if (self.id == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
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

open class CoverageRegionPlacesIdRequestBuilder: NSObject {
    let currentApi: PlaceUriApi

    /**
    * enum for parameter addPoiInfos
    */
    public enum AddPoiInfos: String { 
        case bssStands = "bss_stands"
        case carPark = "car_park"
        case empty = ""
        case _none = "none"
    }
    var region:String? = nil
    var id:String? = nil
    var bssStands:Bool? = nil
    var addPoiInfos: [String]? = nil
    var disableGeojson:Bool? = nil
    var debugURL: String? = nil

    public init(currentApi: PlaceUriApi) {
        self.currentApi = currentApi
    }

    open func withRegion(_ region: String?) -> CoverageRegionPlacesIdRequestBuilder {
        self.region = region
        
        return self
    }
    open func withId(_ id: String?) -> CoverageRegionPlacesIdRequestBuilder {
        self.id = id
        
        return self
    }
    open func withBssStands(_ bssStands: Bool?) -> CoverageRegionPlacesIdRequestBuilder {
        self.bssStands = bssStands
        
        return self
    }
    open func withAddPoiInfos(_ addPoiInfos: [AddPoiInfos]?) -> CoverageRegionPlacesIdRequestBuilder {
        guard let addPoiInfos = addPoiInfos else {
            return self
        }
        
        var items = [String]()
        for item in addPoiInfos {
            items.append(item.rawValue)
        }
        self.addPoiInfos = items

        return self
    }
    open func withDisableGeojson(_ disableGeojson: Bool?) -> CoverageRegionPlacesIdRequestBuilder {
        self.disableGeojson = disableGeojson
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoverageRegionPlacesIdRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{region}/places/{id}"

        if let region = region {
            let regionPreEscape: String = "\(region)"
            let regionPostEscape: String = regionPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{region}", with: regionPostEscape, options: .literal, range: nil)
        }

        if let id = id {
            let idPreEscape: String = "\(id)"
            let idPostEscape: String = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "bss_stands": self.bssStands, 
            "add_poi_infos[]": self.addPoiInfos, 
            "disable_geojson": self.disableGeojson
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: Places?,_ error: Error?) -> Void)) {
        if (self.region == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
        }
        if (self.id == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<Places>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.region == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
    }
    if (self.id == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
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

open class PlacesIdRequestBuilder: NSObject {
    let currentApi: PlaceUriApi

    /**
    * enum for parameter addPoiInfos
    */
    public enum AddPoiInfos: String { 
        case bssStands = "bss_stands"
        case carPark = "car_park"
        case empty = ""
        case _none = "none"
    }
    var id:String? = nil
    var bssStands:Bool? = nil
    var addPoiInfos: [String]? = nil
    var disableGeojson:Bool? = nil
    var debugURL: String? = nil

    public init(currentApi: PlaceUriApi) {
        self.currentApi = currentApi
    }

    open func withId(_ id: String?) -> PlacesIdRequestBuilder {
        self.id = id
        
        return self
    }
    open func withBssStands(_ bssStands: Bool?) -> PlacesIdRequestBuilder {
        self.bssStands = bssStands
        
        return self
    }
    open func withAddPoiInfos(_ addPoiInfos: [AddPoiInfos]?) -> PlacesIdRequestBuilder {
        guard let addPoiInfos = addPoiInfos else {
            return self
        }
        
        var items = [String]()
        for item in addPoiInfos {
            items.append(item.rawValue)
        }
        self.addPoiInfos = items

        return self
    }
    open func withDisableGeojson(_ disableGeojson: Bool?) -> PlacesIdRequestBuilder {
        self.disableGeojson = disableGeojson
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> PlacesIdRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/places/{id}"

        if let id = id {
            let idPreEscape: String = "\(id)"
            let idPostEscape: String = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "bss_stands": self.bssStands, 
            "add_poi_infos[]": self.addPoiInfos, 
            "disable_geojson": self.disableGeojson
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: Places?,_ error: Error?) -> Void)) {
        if (self.id == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<Places>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.id == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : id"])))
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



open class PlaceUriApi: APIBase {
    let token: String

    public init(token: String) {
        self.token = token
    }

    public func newCoverageLonLatPlacesIdRequestBuilder() -> CoverageLonLatPlacesIdRequestBuilder {
        return CoverageLonLatPlacesIdRequestBuilder(currentApi: self)
    }
    public func newCoverageRegionPlacesIdRequestBuilder() -> CoverageRegionPlacesIdRequestBuilder {
        return CoverageRegionPlacesIdRequestBuilder(currentApi: self)
    }
    public func newPlacesIdRequestBuilder() -> PlacesIdRequestBuilder {
        return PlacesIdRequestBuilder(currentApi: self)
    }
}
