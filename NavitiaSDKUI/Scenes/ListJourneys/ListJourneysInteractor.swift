//
//  ListJourneysInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysBusinessLogic {
    
    var journeysRequest: JourneysRequest? { get set }
    
    func displaySearch(request: ListJourneys.DisplaySearch.Request)
    func fetchPhysicalModes(request: ListJourneys.FetchPhysicalModes.Request)
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request)
}

protocol ListJourneysDataStore {
    
    var journeysRequest: JourneysRequest? { get set }
    var physicalModes: [PhysicalMode]? { get }
    var journeys: [Journey]? { get }
    var ridesharingJourneys: [Journey]? { get }
    var disruptions: [Disruption]? { get }
    var notes: [Note]? { get }
    var context: Context? { get }
}

internal class ListJourneysInteractor: ListJourneysBusinessLogic, ListJourneysDataStore {

    var presenter: ListJourneysPresentationLogic?
    var navitiaWorker = NavitiaWorker()
    var journeysRequest: JourneysRequest?
    var physicalModes: [PhysicalMode]?
    var journeys: [Journey]?
    var ridesharingJourneys: [Journey]?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    
    // MARK: - Display Search
    
    func displaySearch(request: ListJourneys.DisplaySearch.Request) {
        if let from = request.from {
            journeysRequest?.originId = from.id
            journeysRequest?.originLabel = from.name
        }
        if let to = request.to {
            journeysRequest?.destinationId = to.id
            journeysRequest?.destinationLabel = to.name
        }

        if let journeysRequest = journeysRequest {
            let response = ListJourneys.DisplaySearch.Response(journeysRequest: journeysRequest)
            
            self.presenter?.presentDisplayedSearch(response: response)
        }
    }
    
    // MARK: - Fetch Physical Modes
    
    func fetchPhysicalModes(request: ListJourneys.FetchPhysicalModes.Request) {
        if let journeysRequest = request.journeysRequest {
            self.journeysRequest = journeysRequest
        }
        
        guard let journeysRequest = journeysRequest else {
            return
        }
        
        presenter?.presentFetchedSearchInformation(journeysRequest: journeysRequest)
        
        navitiaWorker.fetchPhysicalMode(coverage: journeysRequest.coverage) { (physicalModes) in
            self.physicalModes = physicalModes
            
            let response = ListJourneys.FetchPhysicalModes.Response(physicalModes: physicalModes)
            
            self.presenter?.presentFetchedPhysicalModes(response: response)
        }
    }
    
    // MARK: - Fetch Journey
    
    func fetchJourneys(request: ListJourneys.FetchJourneys.Request) {
        if let journeysRequest = request.journeysRequest {
            self.journeysRequest = journeysRequest
        }
        
        guard let journeysRequest = journeysRequest else {
            return
        }
        
        presenter?.presentFetchedSearchInformation(journeysRequest: journeysRequest)
        
        navitiaWorker.fetchJourneys(journeysRequest: journeysRequest) { (journeys, ridesharings, disruptions, notes, context) in
            self.journeys = journeys
            self.ridesharingJourneys = ridesharings
            self.disruptions = disruptions
            self.notes = notes
            self.context = context
            
            let response = ListJourneys.FetchJourneys.Response(journeysRequest: journeysRequest,
                                                               journeys: (journeys, withRidesharing: ridesharings),
                                                               disruptions: disruptions)
            
            self.presenter?.presentFetchedJourneys(response: response)
        }
    }
}
