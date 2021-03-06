//
// Context.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class Context: JSONEncodable, Mappable {

    /** Timezone of any datetime in the response, default value Africa/Abidjan (UTC) */
    public var timezone: String?
    /** The datetime of the request (considered as \&quot;now\&quot;) */
    public var currentDatetime: String?
    public var carDirectPath: CO2?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        timezone <- map["timezone"]
        currentDatetime <- map["current_datetime"]
        carDirectPath <- map["car_direct_path"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["timezone"] = self.timezone
        nillableDictionary["current_datetime"] = self.currentDatetime
        nillableDictionary["car_direct_path"] = self.carDirectPath?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
