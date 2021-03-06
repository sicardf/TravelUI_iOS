//
// ImpactedStop.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class ImpactedStop: JSONEncodable, Mappable {

    public enum StopTimeEffect: String { 
        case delayed = "delayed"
        case added = "added"
        case deleted = "deleted"
        case unchanged = "unchanged"
    }
    public var amendedArrivalTime: String?
    public var stopPoint: StopPoint?
    public var stopTimeEffect: StopTimeEffect?
    public var departureStatus: String?
    public var amendedDepartureTime: String?
    public var baseArrivalTime: String?
    public var cause: String?
    public var baseDepartureTime: String?
    public var arrivalStatus: String?

    public init() {}
    required public init?(map: Map) {

    }


    public func mapping(map: Map) {
        amendedArrivalTime <- map["amended_arrival_time"]
        stopPoint <- map["stop_point"]
        stopTimeEffect <- map["stop_time_effect"]
        departureStatus <- map["departure_status"]
        amendedDepartureTime <- map["amended_departure_time"]
        baseArrivalTime <- map["base_arrival_time"]
        cause <- map["cause"]
        baseDepartureTime <- map["base_departure_time"]
        arrivalStatus <- map["arrival_status"]
    }

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["amended_arrival_time"] = self.amendedArrivalTime
        nillableDictionary["stop_point"] = self.stopPoint?.encodeToJSON()
        nillableDictionary["stop_time_effect"] = self.stopTimeEffect?.rawValue
        nillableDictionary["departure_status"] = self.departureStatus
        nillableDictionary["amended_departure_time"] = self.amendedDepartureTime
        nillableDictionary["base_arrival_time"] = self.baseArrivalTime
        nillableDictionary["cause"] = self.cause
        nillableDictionary["base_departure_time"] = self.baseDepartureTime
        nillableDictionary["arrival_status"] = self.arrivalStatus

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
