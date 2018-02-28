//
// LineHeadersSchema.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class LineHeadersSchema: JSONEncodable, Mappable {

    public var cellLat: CellLatSchema?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        cellLat <- map["cell_lat"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cell_lat"] = self.cellLat?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
