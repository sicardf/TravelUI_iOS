//
//  ShowJourneyRoadmapPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ShowJourneyRoadmapPresentationLogic {
    
    func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response)
    func presentMap(response: ShowJourneyRoadmap.GetMap.Response)
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response)
    func presentPark(response: ShowJourneyRoadmap.FetchPark.Response)
}

class ShowJourneyRoadmapPresenter: ShowJourneyRoadmapPresentationLogic {
    
    weak var viewController: ShowJourneyRoadmapDisplayLogic?
    
    // MARK: Presenter
    
    func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response) {
        guard let departure = getDepartureViewModel(journey: response.journey),
            let sectionsClean = getSectionModels(response: response),
            let arrival = getArrivalViewModel(journey: response.journey),
            let emission = getEmission(response: response) else {
            return
        }

        let viewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel(ridesharing: getRidesharing(journeyRidesharing: response.journeyRidesharing),
                                                                departure: departure,
                                                                sections: sectionsClean,
                                                                arrival: arrival,
                                                                emission: emission,
                                                                disruptions: response.disruptions,
                                                                journey: response.journey,
                                                                ridesharingJourneys: response.journeyRidesharing)
        
        viewController?.displayRoadmap(viewModel: viewModel)
    }
    
    func presentMap(response: ShowJourneyRoadmap.GetMap.Response) {
        let viewModel = ShowJourneyRoadmap.GetMap.ViewModel(journey: response.journey)
        viewController?.displayMap(viewModel: viewModel)
    }
    
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response) {
        guard let stands = getStands(stands: response.poi.stands, carPark: response.poi.carPark, type: .bssRent) else {
            return
        }

        response.notify(stands)
    }
    
    func presentPark(response: ShowJourneyRoadmap.FetchPark.Response) {
        guard let stands = getStands(stands: response.poi.stands, carPark: response.poi.carPark, type: .park) else {
            return
        }
        
        response.notify(stands)
    }
    
    // MARK: Ridesharing
    
    private func getRidesharingSection(ridesharingJourney: Journey?) -> Section? {
        guard let ridesharingJourney = ridesharingJourney, let ridesharingSections = ridesharingJourney.sections else {
            return nil
        }
        
        for section in ridesharingSections {
            if section.type == .ridesharing {
                return section
            }
        }
        
        return nil
    }
    
    private func getRidesharingAccessibility(departureAddress: String, arrivalAddress: String) -> String {
        return String(format: "ridesharing_offer".localized(), departureAddress, arrivalAddress)
    }
    
    private func getRidesharing(journeyRidesharing: Journey?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing? {
        guard let ridesharingSection = getRidesharingSection(ridesharingJourney: journeyRidesharing) else {
            return nil
        }
        
        let network = ridesharingSection.ridesharingInformations?.network ?? ""
        let departure = ridesharingSection.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
        let driverPictureURL = ridesharingSection.ridesharingInformations?.driver?.image ?? ""
        let driverNickname = ridesharingSection.ridesharingInformations?.driver?.alias ?? ""
        let driverGender = ridesharingSection.ridesharingInformations?.driver?.gender?.rawValue ?? ""
        let rating = ridesharingSection.ridesharingInformations?.driver?.rating?.value ?? 0
        let ratingCount = ridesharingSection.ridesharingInformations?.driver?.rating?.count ?? 0
        let departureAddress = ridesharingSection.from?.name ?? ""
        let arrivalAddress = ridesharingSection.to?.name ?? ""
        let seatsCount = ridesharingSection.ridesharingInformations?.seats?.available
        let price = journeyRidesharing?.fare?.total?.value ?? ""
        let deepLink = ridesharingSection.links?[safe: 0]?.href ?? ""
        let accessibility = getRidesharingAccessibility(departureAddress: departureAddress, arrivalAddress: arrivalAddress)
        let ridesharingViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing(network: network,
                                                                                       departure: departure,
                                                                                       driverPictureURL: driverPictureURL,
                                                                                       driverNickname: driverNickname,
                                                                                       driverGender: driverGender,
                                                                                       rating: rating,
                                                                                       ratingCount: ratingCount,
                                                                                       departureAddress: departureAddress,
                                                                                       arrivalAddress: arrivalAddress,
                                                                                       seatsCount: seatsCount,
                                                                                       price: price,
                                                                                       deepLink: deepLink,
                                                                                       accessibility: accessibility)

        return ridesharingViewModel
    }
    
    // MARK: DepartureViewModel
    
    private func getDepartureViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let departureName = getDepartureName(journey: journey),
            let departureTime = getDepartureTime(journey: journey) {
            let accessibility = getDepartureAccessibilty(journey: journey)
            let departureViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .departure,
                                                                                              information: departureName,
                                                                                              time: departureTime,
                                                                                              calorie: nil,
                                                                                              accessibility: accessibility)
            
            
            return departureViewModel
        }
        
        return nil
    }
    
    private func getDepartureName(journey: Journey) -> String? {
        return journey.sections?.first?.from?.name
    }
    
    private func getDepartureTime(journey: Journey) -> String? {
        guard let departureDate = journey.departureDateTime?.toDate(format: Configuration.date) else {
            return nil
        }
        
        return departureDate.toString(format: Configuration.time)
    }
    
    private func getDepartureAccessibilty(journey: Journey) -> String {
        guard let name = journey.sections?.first?.from?.name,
            let dateTime = journey.departureDateTime?.toDate(format: Configuration.date) else {
                return ""
        }
        
        if let timeZone = TimeZone(identifier: "CET") {
            var calendar = Foundation.Calendar(identifier: .gregorian)
            calendar.timeZone = timeZone
            
            let hourComponents = calendar.dateComponents([.hour, .minute], from: dateTime)
            
            if var hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
                if let hour = hourComponents.hour, hour == 0 {
                    hours = String(format: "%d %@, %@", hour, "hour".localized(), hours)
                }
                
                return String(format: "departure_at_from".localized(), hours, name)
            }
        }
        
        return ""
    }
    
    private func getArrivalAccessibilty(journey: Journey) -> String {
        guard let name = journey.sections?.last?.to?.name,
            let dateTime = journey.arrivalDateTime?.toDate(format: Configuration.date) else {
                return ""
        }
        
        if let timeZone = TimeZone(identifier: "CET") {
            var calendar = Foundation.Calendar(identifier: .gregorian)
            calendar.timeZone = timeZone
            
            let hourComponents = calendar.dateComponents([.hour, .minute], from: dateTime)
            
            if var hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
                if let hour = hourComponents.hour, hour == 0  {
                    hours = String(format: "%d %@, %@", hour, "hour".localized(), hours)
                }
                
                return String(format: "arrival_at_to".localized(), hours, name)
            }
        }

        return ""
    }
    
    // MARK: ArrivalViewModel
    
    private func getArrivalViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let arrivalName = getArrivalName(journey: journey),
            let arrivalTime = getArrivalTime(journey: journey),
            let calorie = getCalorie(journey: journey) {
            let accessibility = getArrivalAccessibilty(journey: journey)
            let arrivalViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .arrival,
                                                                                            information: arrivalName,
                                                                                            time: arrivalTime,
                                                                                            calorie: calorie,
                                                                                            accessibility: accessibility)
            
            return arrivalViewModel
        }
        
        return nil
    }
    
    private func getArrivalName(journey: Journey) -> String? {
        return journey.sections?.last?.to?.name
    }
    
    private func getArrivalTime(journey: Journey) -> String? {
        guard let arrivalDate = journey.arrivalDateTime?.toDate(format: Configuration.date) else {
            return nil
        }
        
        return arrivalDate.toString(format: Configuration.time)
    }
    
    private func getCalorie(journey: Journey) -> String? {
        guard let walkingDuration = journey.durations?.walking, let bikeDuration = journey.durations?.bike else {
            return nil
        }
        
        let calorie = (Double(walkingDuration) * Configuration.caloriePerSecWalking + Double(bikeDuration) * Configuration.caloriePerSecBike).rounded()
        
        return String(format: "%d", Int(calorie))
    }
    
    // MARK: Section
    
    private func getType(section: Section) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.ModelType? {
        guard let typeRawValue = section.type?.rawValue,
            let type = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.ModelType.init(rawValue: typeRawValue) else {
                return nil
        }
        
        return type
    }
    
    private func getMode(section: Section) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Mode? {
        guard let modeRawValue = section.mode?.rawValue,
            let mode = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Mode.init(rawValue: modeRawValue) else {
                return nil
        }
        
        return mode
    }
    
    private func getFrom(section: Section) -> String {
        return section.from?.name ?? ""
    }
    
    private func getTo(section: Section) -> String {
        return section.to?.name ?? ""
    }
    
    private func getDepartureDateTime(section: Section) -> String {
        guard let departureDate = section.departureDateTime?.toDate(format: Configuration.date) else {
            return ""
        }
        
        return departureDate.toString(format: Configuration.time)
    }
    
    private func getArrivalDateTime(section: Section) -> String {
        guard let arrivalDate = section.arrivalDateTime?.toDate(format: Configuration.date) else {
            return ""
        }
        
        return arrivalDate.toString(format: Configuration.time)
    }
    
    private func getActionDescription(section: Section) -> String? {
        guard let type = section.type else {
            return nil
        }

        if type == .park {
            return "park_in_the".localized()
        } else if type == .ridesharing {
            return "take_the_ridesharing".localized()
        } else if type == .transfer || section.mode != nil {
            return "to_with_uppercase".localized()
        } else if let commercialMode = section.displayInformations?.commercialMode {
            return String(format: "%@ %@", "take_the".localized(), commercialMode)
        } else if let poi = section.from?.poi ?? section.to?.poi {
            if type == .bssRent {
                return String(format: "take_a_bike_at".localized(), poi.properties?["network"] ?? "")
            } else if type == .bssPutBack {
                return String(format: "dock_bike_at".localized(), poi.properties?["network"] ?? "")
            }
        }

        return nil
    }
    
    private func getDuration(section: Section) -> String? {
        guard let duration = section.duration else {
            return nil
        }
       
        var durationString: String? = nil
        var keyword: String = ""
        
        if duration >= 60 {
            keyword = "a_time_"
            durationString = String(format: "%@ %@", duration.minuteToString(), duration == 60 ? "units_minute".localized() : "units_minutes".localized())
            
            if section.type == .waiting, let durationString = durationString {
                return String(format: "%@ %@", "wait".localized(), durationString)
            }
        } else {
            keyword = "less_than_a_minute_"
        }

        if (section.type == .streetNetwork && section.mode == .car) || section.type == .ridesharing {
            keyword += "drive"
        } else if (section.type == .streetNetwork && section.mode == .walking) || section.type == .transfer {
            keyword += "walk"
        } else if (section.type == .streetNetwork && section.mode == .bike) || (section.type == .streetNetwork && section.mode == .bss) {
            keyword += "ride"
        } else {
            return nil
        }

        if let durationString = durationString {
            return String(format: keyword.localized(), durationString)
        }
        
        return keyword.localized()
    }
    
    private func getWaiting(sectionBefore: Section?, section: Section) -> String? {
        guard let sectionBefore = sectionBefore else {
            return nil
        }
        
        if sectionBefore.type == .waiting {
            return getDuration(section: sectionBefore)
        }
        
        return nil
    }
    
    private func getStopDate(section: Section) -> [String] {
        var stopDate = [String]()
        
        if let stopDateTimes = section.stopDateTimes {
            for (index, stop) in stopDateTimes.enumerated() {
                if let name = stop.stopPoint?.name {
                    if index != 0 && index != (stopDateTimes.count - 1) {
                        stopDate.append(name)
                    }
                }
            }
        }
        
        return stopDate
    }
    
    private func getPoi(section: Section?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Poi? {
        guard let type = section?.type,
        let poi = section?.from?.poi ?? section?.to?.poi,
        let latString = poi.coord?.lat,
        let lonString = poi.coord?.lon
        else {
                return nil
        }
        
        let name = poi.name
        let addressId = poi.address?.id
        var addressName: String? = nil
        let network = poi.properties?["network"]
        let lat = Double(latString)
        let lon = Double(lonString)
        let standsViewModel = getStands(stands: poi.stands, carPark: poi.carPark, type: type)
        
        if type == .bssRent || type == .bssPutBack {
            addressName = poi.address?.name
        } else if type == .streetNetwork && section?.mode == .car {
            addressName = poi.address?.name
        } else if type != .park {
            return nil
        }

        let poiViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Poi(name: name,
                                                                                    network: network,
                                                                                    lat: lat,
                                                                                    lont: lon,
                                                                                    addressName: addressName,
                                                                                    addressId: addressId,
                                                                                    stands: standsViewModel)
        
        return poiViewModel
    }
    
    private func getStands(stands: Stands?, carPark: CarPark?, type: Section.ModelType) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands? {
        var availabilityTemplate = ""

        if let stands = stands {
            let bssStationStatus = getBssStationStatus(sectionType: type, stationStatus: stands.status)
            
            switch type {
            case .bssRent:
                if let availableBikes = stands.availableBikes {
                    if availableBikes <= 1 {
                        availabilityTemplate = "bss_available_bikes".localized()
                    } else {
                        availabilityTemplate = "bss_available_bikes_plural".localized()
                    }
                    
                    let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands(status: bssStationStatus, availability: String(format: availabilityTemplate, availableBikes),
                                                                                                      icon: nil)
                    return standsViewModel
                }
            case .bssPutBack:
                if let availablePlaces = stands.availablePlaces {
                    if availablePlaces <= 1 {
                        availabilityTemplate = "available_places".localized()
                    } else {
                        availabilityTemplate = "available_places_plural".localized()
                    }
                    
                    let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands(status: bssStationStatus, availability: String(format: availabilityTemplate, availablePlaces),
                                                                                                      icon: nil)
                    return standsViewModel
                }
            default:
                return nil
            }
        } else if let carPark = carPark {
            switch type {
            case .park:
                if let availablePlaces = carPark.available {
                    if availablePlaces <= 1 {
                        availabilityTemplate = "available_places".localized()
                    } else {
                        availabilityTemplate = "available_places_plural".localized()
                    }
                    let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands(status: nil, availability: String(format: availabilityTemplate, availablePlaces),
                                                                                                      icon: "park")
                    return standsViewModel
                }
            default:
                return nil
            }
        }
        
        return nil
    }
    
    private func getBssStationStatus(sectionType: Section.ModelType, stationStatus: Stands.Status?) -> String? {
        guard let stationStatus = stationStatus else {
            return nil
        }
        
        switch stationStatus {
        case .open:
            return nil
        case .closed:
            return "bss_station_status_closed".localized()
        case .unavailable:
            return sectionType == .bssRent ? "bss_station_status_unavailable_pick_up".localized() : "bss_station_status_unavailable_drop_off".localized()
        }
    }
    
    private func getBackground(section: Section) -> Bool {
        if let mode = section.mode {
            switch mode {
            case .ridesharing,
                 .carnopark:
                return true
            default:
                return false
            }
        } else if let type = section.type {
            switch type {
            case .transfer:
                return false
            default:
                return true
            }
        }
        
        return false
    }
    
    private func getSectionModel(section: Section, sectionBefore: Section?, disruptions: [Disruption]?, notes: [Note]?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel? {
        guard let type = getType(section: section) else {
            return nil
        }
        
        let sectionModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel(type: type,
                                                                                mode: getMode(section: section),
                                                                                from: getFrom(section: section),
                                                                                to: getTo(section: section),
                                                                                startTime: getDepartureDateTime(section: section),
                                                                                endTime: getArrivalDateTime(section: section),
                                                                                actionDescription: getActionDescription(section: section),
                                                                                duration: getDuration(section: section),
                                                                                path: getPaths(section: section),
                                                                                stopDate: getStopDate(section: section),
                                                                                displayInformations: getDisplayInformations(displayInformations: section.displayInformations),
                                                                                waiting: getWaiting(sectionBefore: sectionBefore, section: section),
                                                                                disruptions: getDisruption(section: section, disruptions: disruptions),
                                                                                disruptionsClean: getDisruptionModel(section: section, disruptions: disruptions),
                                                                                notes: getNotesOnDemandTransport(section: section, notes: notes),
                                                                                poi: getPoi(section: section),
                                                                                icon: Modes().getMode(section: section, roadmap: true),
                                                                                realTime: getRealTime(section: section),
                                                                                background: getBackground(section: section),
                                                                                section: section)
        
        return sectionModel
    }
    
    private func getSectionModels(response:  ShowJourneyRoadmap.GetRoadmap.Response) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel]? {
        var sectionsModel = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel]()
        
        if let sections = response.journey.sections {
            for (index, section) in sections.enumerated() {
                if section.mode == .ridesharing {
                    if let sectionsRidesharing = response.journeyRidesharing?.sections {
                        for (index, ridesharingSection) in sectionsRidesharing.enumerated() {
                            if let SectionModel = getSectionModel(section: ridesharingSection, sectionBefore: sectionsRidesharing[safe: index - 1], disruptions: response.disruptions, notes: response.notes) {
                                sectionsModel.append(SectionModel)
                            }
                        }
                    }
                } else {
                    if let sectionModel = getSectionModel(section: section, sectionBefore: sections[safe: index - 1], disruptions: response.disruptions, notes: response.notes) {
                        sectionsModel.append(sectionModel)
                    }
                }
            }
        }
        
        return sectionsModel
    }
    
    // MARK: Emission
    
    private func getEmission(response: ShowJourneyRoadmap.GetRoadmap.Response) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission? {
        guard let journeyValue = response.journey.co2Emission?.value,
            let journeyCarbonSummary = getFormattedEmission(emissionValue: journeyValue) else {
            return nil
        }

        let carCarbonSummary = getFormattedEmission(emissionValue: response.context.carDirectPath?.co2Emission?.value)
        
        var emissionViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission.init(journey: journeyCarbonSummary,
                                                                                      car: carCarbonSummary,
                                                                                      accessibility: "")
        let accessibilityLabel = getEmissionAccessibility(emissionViewModel: emissionViewModel)
        
        emissionViewModel.accessibility = accessibilityLabel
        
        return emissionViewModel
    }
    
    private func getFormattedEmission(emissionValue: Double?) -> (value: Double, unit: String)? {
        guard var emissionValue = emissionValue else {
            return nil
        }
        
        var carbonUnit = "units_g".localized()
        if emissionValue >= 1000 {
            emissionValue = emissionValue / 1000
            carbonUnit = "units_kg".localized()
        }
        carbonUnit.append(String(format: " %@", "carbon".localized()))
        
        return (value: emissionValue, unit: carbonUnit)
    }
    
    private func getValueEmissionAccessibility(value: Double, unit: String) -> String {
        if unit == "g CO2" {
            return String(format: "%.1f %@ %@. ", value, "gram".localized(), "of_carbon_dioxide".localized())
        } else if unit == "Kg CO2" {
            return String(format: "%.1f %@ %@. ", value, "kilogram".localized(), "of_carbon_dioxide".localized())
        }
        
        return ""
    }
    
    private func getEmissionAccessibility(emissionViewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission) -> String {
        var accessibilityLabel = String(format: "carbon_footprint".localized(), getValueEmissionAccessibility(value: emissionViewModel.journey.value, unit: emissionViewModel.journey.unit))
        if let car = emissionViewModel.car {
            accessibilityLabel += String(format: "carbon_comparison_car".localized(), getValueEmissionAccessibility(value: car.value, unit: car.unit))
        }
        
        return accessibilityLabel
    }
    
    // MARK: DisplayInformations
    
    private func getCommercialMode(displayInformations: VJDisplayInformation?) -> String? {
        guard let commercialMode = displayInformations?.commercialMode else {
            return nil
        }

        return commercialMode
    }
    
    private func getColor(displayInformations: VJDisplayInformation?) -> UIColor {
        guard let color = displayInformations?.color else {
            return .black
        }
        
        return color.toUIColor()
    }
    
    private func getDirection(displayInformations: VJDisplayInformation?) -> String {
        return displayInformations?.direction ?? ""
    }
    
    private func getTransportCode(displayInformations: VJDisplayInformation?) -> String? {
        guard let code = displayInformations?.code, !code.isEmpty else {
            return nil
        }
        
        return code
    }
    
    private func getNetwork(displayInformations: VJDisplayInformation?) -> String? {
        guard Configuration.multiNetwork, let network = displayInformations?.network else {
            return nil
        }
        
        return network
    }
    
    private func getDisplayInformations(displayInformations: VJDisplayInformation?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisplayInformations {
        let commercialMode = getCommercialMode(displayInformations: displayInformations)
        let color = getColor(displayInformations: displayInformations)
        let direction = getDirection(displayInformations: displayInformations)
        let code = getTransportCode(displayInformations: displayInformations)
        let displayInformationsClean = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisplayInformations(commercialMode: commercialMode,
                                                                                                                color: color,
                                                                                                                directionTransit: direction,
                                                                                                                code: code,
                                                                                                                network: getNetwork(displayInformations: displayInformations))
        
        return displayInformationsClean
    }
    
    private func getNotesOnDemandTransport(section: Section, notes: [Note]?) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note] {
        var noteOnDemandTransport = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note]()
        
        guard section.type == .onDemandTransport else {
            return noteOnDemandTransport
        }
        
        for note in section.selectLinks(type: "notes") {
            if let notes = notes, let id = note.id, let note = section.getNote(notes: notes, id: id) {
                noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note(content: note.value ?? ""))
            }
        }
        
        if let firstStopDateTimes = section.stopDateTimes?.first {
            let links = firstStopDateTimes.selectLinks(type: "notes")
            if links.count > 0 {
                for i in links {
                    if let notes = notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                        noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note(content: note.value ?? ""))
                    }
                }
                
                return noteOnDemandTransport
            }
        }
        
        if let laststopDateTimes = section.stopDateTimes?.last {
            for i in laststopDateTimes.selectLinks(type: "notes") {
                if let notes = notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                    noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note(content: note.value ?? ""))
                }
            }
        }
        
        return noteOnDemandTransport
    }
    
    func getDateDisruption(disruption: Disruption) -> String {
        if let startDate = disruption.applicationPeriods?.first?.begin?.toDate(format: Configuration.date),
            let endDate = disruption.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
            
            return String(format: "%@ %@ %@ %@", "from".localized(),
                          startDate.toString(format: Configuration.dateInterval),
                          "to_period".localized(),
                          endDate.toString(format: Configuration.dateInterval))
        }
        
        return ""
    }
    
    func getAccessibilityDisruption(disruption: Disruption) -> String {
        let title = disruption.severity?.name ?? ""
        let information = Disruption.message(disruption: disruption)?.text?.htmlToAttributedString?.string ?? ""
        var startDate = ""
        var endDate = ""
        
        if let start = disruption.applicationPeriods?.first?.begin?.toDate(format: Configuration.date) {
            startDate = DateFormatter.localizedString(from: start, dateStyle: .medium, timeStyle: .none)
        }
        if let end = disruption.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
            endDate = DateFormatter.localizedString(from: end, dateStyle: .medium, timeStyle: .none)
        }

        return String(format: "%@ %@ %@ %@ %@ : %@.",
                      title,
                      "from".localized(),
                      startDate,
                      "to_period".localized(),
                      endDate,
                      information)
    }
    
    func getDisruptionModel(section: Section, disruptions: [Disruption]?) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisruptionModel] {
        let disruptions = getDisruption(section: section, disruptions: disruptions)
        var disruptionsClean = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisruptionModel]()

        for (_, disruption) in disruptions.enumerated() {
            let disruptionModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisruptionModel(color: disruption.severity?.color?.toUIColor() ?? UIColor.red,
                                                                                                       icon: Disruption.iconName(of: disruption.level),
                                                                                                       title: disruption.severity?.name ?? "",
                                                                                                       date: getDateDisruption(disruption: disruption),
                                                                                                       information: Disruption.message(disruption: disruption)?.text?.htmlToAttributedString?.string,
                                                                                                       accessibility: getAccessibilityDisruption(disruption: disruption))
            disruptionsClean.append(disruptionModel)
        }
        
        return disruptionsClean
    }
    
    // Disruption /!\
    
    func getDisruption(section: Section, disruptions: [Disruption]?) -> [Disruption] {
        var sectionDisruptions = [Disruption]()
        
        guard let disruptions = disruptions else {
            return sectionDisruptions
        }
        
        if disruptions.count > 0, let displayInformations = section.displayInformations, let displayInformationsLinks = displayInformations.links {
            var disruptionLinkIds = [String]()
            for linkSchema in displayInformationsLinks {
                if let schemaType = linkSchema.type, let schemaId = linkSchema.id, schemaType == "disruption" {
                    disruptionLinkIds.append(schemaId)
                }
            }
            
            for disruption in disruptions {
                if let disruptionId = disruption.id, disruption.applicationPeriods != nil && disruptionLinkIds.contains(disruptionId) {
                    sectionDisruptions.append(getDisruptionWithSortedMessages(disruptionIn: disruption))
                }
            }
            
            let sortedDisruptions = getSortedDisruptions(disruptions:sectionDisruptions)
            
            return sortedDisruptions
        }
        
        return sectionDisruptions
    }
    
    fileprivate func getSortedDisruptions(disruptions: [Disruption]) -> [Disruption] {
        var mutatedDisruptions = disruptions
        for (i, _) in mutatedDisruptions.enumerated() {
            var j = i + 1
            while (j < mutatedDisruptions.count) {
                if mutatedDisruptions[j].level.rawValue > mutatedDisruptions[i].level.rawValue {
                    let substituteDisruption = mutatedDisruptions[j]
                    mutatedDisruptions[j] = mutatedDisruptions[i]
                    mutatedDisruptions[i] = substituteDisruption
                }
                
                j += 1
            }
        }
        
        return mutatedDisruptions
    }
    
    /*
     Channel Types Order :
     1- Mobile
     2- Web and Mobile
     3- Web
     */
    fileprivate func getDisruptionWithSortedMessages(disruptionIn: Disruption) -> Disruption {
        let disruptionOut = disruptionIn
        if let messages = disruptionOut.messages {
            var sortedMessages = [Message]()
            for message in messages {
                if let channelTypes = message.channel?.types, channelTypes.count > 0 {
                    if channelTypes.contains(Channel.Types.mobile) && channelTypes.contains(Channel.Types.web) {
                        sortedMessages.insert(message, at: getInsertionIndex(messages: sortedMessages, channelType: 2))
                    } else if channelTypes.contains(Channel.Types.mobile) {
                        sortedMessages.insert(message, at: 0)
                    } else if channelTypes.contains(Channel.Types.web) {
                        sortedMessages.insert(message, at: getInsertionIndex(messages: sortedMessages, channelType: 3))
                    }
                }
            }
            
            disruptionOut.messages = sortedMessages
        }
        
        return disruptionOut
    }
    
    /*
     Channel Types Order :
     1- Mobile
     2- Web and Mobile
     3- Web
     */
    fileprivate func getInsertionIndex(messages: [Message], channelType: Int) -> Int {
        if messages.count >= 1 && channelType != 1 {
            var outIndex = 0
            for (index, message) in messages.enumerated() {
                if let channelTypes = message.channel?.types {
                    if (channelType == 2 && channelTypes.contains(Channel.Types.web)) || (channelType == 3 && channelTypes.contains(Channel.Types.web) && !channelTypes.contains(Channel.Types.mobile)) {
                        return index
                    }
                }
                
                outIndex = index
            }
            
            return channelType == 2 || channelType == 3 ? outIndex + 1 : 0
        }
        
        return 0;
    }
    
    func getRealTime(section: Section) -> Bool {
        if let sectionDepartureTime = section.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"), let currentDateTime = Date().toLocalDate(format: "yyyyMMdd'T'HHmmss"), abs(sectionDepartureTime.timeIntervalSince(currentDateTime)) <= Configuration.approvalTimeThreshold {
            return true
        }
        
        return false
    }
    
    private func getDirectionPath(pathDirection: Int32?) -> String {
        guard let pathDirection = pathDirection else {
            return "arrow_right"
        }
        
        if pathDirection == 0 {
            return "arrow_straight"
        } else if pathDirection < 0 {
            return "arrow_left"
        } else {
            return "arrow_right"
        }
    }
    
    private func getDirectionInstruction(pathDirection: Int32, pathLength: Int32, pathInstruction: String) -> String {
        if pathDirection == 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "carry_straight_on".localized(), String(format: "for_meter".localized(), pathLength)) : String(format: "%@ %@ %@", "continue_on".localized(), pathInstruction, String(format: "for_meter".localized(), pathLength))
        } else if pathDirection < 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "turn_left".localized(), String(format: "in_meter".localized(), pathLength)) : String(format: "%@ %@ %@", "turn_left_on".localized(), pathInstruction, String(format: "in_meter".localized(), pathLength))
        } else {
            return pathInstruction == "" ? String(format: "%@ %@", "turn_right".localized(), String(format: "in_meter".localized(), pathLength)) : String(format: "%@ %@ %@", "turn_right_on".localized(), pathInstruction, String(format: "in_meter".localized(), pathLength))
        }
    }
    
    private func getPath(path: Path) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Path {
        let path = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Path(directionIcon: getDirectionPath(pathDirection: path.direction),
                                                                             instruction: getDirectionInstruction(pathDirection: path.direction ?? 0,
                                                                                                                  pathLength: path.length ?? 0,
                                                                                                                  pathInstruction: path.name ?? ""))
        
        return path
    }
    
    private func getPaths(section: Section) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Path]? {
        var newPaths = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Path]()
        
        guard let paths = section.path, let mode = section.mode else {
            return newPaths
        }
        
        if mode == .ridesharing || mode == .carnopark {
            return nil
        }
        
        for (_, path) in paths.enumerated() {
            let path = getPath(path: path)
            newPaths.append(path)
        }
        
        return newPaths
    }
}
