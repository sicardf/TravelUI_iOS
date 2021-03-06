//
// MultiLineStringSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class MultiLineStringSchema: JSONEncodable, Mappable {

    public var type: String?
    public var coordinates: [[[Float]]]?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        type <- map["type"]
        coordinates <- map["coordinates"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["type"] = self.type
        nillableDictionary["coordinates"] = self.coordinates?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
