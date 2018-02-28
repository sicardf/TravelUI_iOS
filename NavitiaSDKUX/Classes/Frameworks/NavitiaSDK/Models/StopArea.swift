//
// StopArea.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class StopArea: JSONEncodable, Mappable {

    public var comment: String?
    public var codes: [Code]?
    /** Name of the object */
    public var name: String?
    public var links: [LinkSchema]?
    public var physicalModes: [PhysicalMode]?
    public var comments: [Comment]?
    /**  Label of the stop area. The name is directly taken from the data whereas the label is  something we compute for better traveler information. If you don&#39;t know what to display, display the label.  */
    public var label: String?
    public var commercialModes: [CommercialMode]?
    public var coord: Coord?
    public var administrativeRegions: [Admin]?
    public var timezone: String?
    public var stopPoints: [StopPoint]?
    /** Identifier of the object */
    public var id: String?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        comment <- map["comment"]
        codes <- map["codes"]
        name <- map["name"]
        links <- map["links"]
        physicalModes <- map["physical_modes"]
        comments <- map["comments"]
        label <- map["label"]
        commercialModes <- map["commercial_modes"]
        coord <- map["coord"]
        administrativeRegions <- map["administrative_regions"]
        timezone <- map["timezone"]
        stopPoints <- map["stop_points"]
        id <- map["id"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comment"] = self.comment
        nillableDictionary["codes"] = self.codes?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["physical_modes"] = self.physicalModes?.encodeToJSON()
        nillableDictionary["comments"] = self.comments?.encodeToJSON()
        nillableDictionary["label"] = self.label
        nillableDictionary["commercial_modes"] = self.commercialModes?.encodeToJSON()
        nillableDictionary["coord"] = self.coord?.encodeToJSON()
        nillableDictionary["administrative_regions"] = self.administrativeRegions?.encodeToJSON()
        nillableDictionary["timezone"] = self.timezone
        nillableDictionary["stop_points"] = self.stopPoints?.encodeToJSON()
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
