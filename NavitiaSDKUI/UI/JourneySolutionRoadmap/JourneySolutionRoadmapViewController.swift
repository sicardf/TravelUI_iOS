//
//  JourneySolutionRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit

open class JourneySolutionRoadmapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewScroll = [UIView]()
    var margin: CGFloat = 10
    var composentWidth: CGFloat = 0
    var journey: Journey?
    var ridesharingJourney: Journey?
    var intermediatePointsCircles = [SectionCircle]()
    var journeyPolyline = [CLLocationCoordinate2D]()
    var ridesharing: Bool = false
    var ridesharingView: RidesharingView!
    var ridesharingDeepLink: String?
    var ridesharingIndex = 0
    var timeRidesharing: Int32?
    var display = false
    var disruptions: [Disruption]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "roadmap".localized(withComment: "Roadmap", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        
        _setupMapView()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composentWidth = _updateWidth()
        if !display {
            _display()
        }
        
        _updateOriginViewScroll()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _updateWidth(customMargin: CGFloat? = nil) -> CGFloat {
        if let margeCustom = customMargin {
            if #available(iOS 11.0, *) {
                return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margeCustom * 2)
            }
            return scrollView.frame.size.width - (margeCustom * 2)
        }
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margin * 2)
        }
        return scrollView.frame.size.width - (margin * 2)
    }
    
    private func _display() {
        if let journey = journey {
            _displayHeader(journey)
            _displayDeparture(journey)
            _displayStep(journey)
            _displayArrival(journey)
        }
        display = true
    }
    
    private func _displayHeader(_ journey: Journey) {
        let journeySolutionView = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        journeySolutionView.disruptions = disruptions
        journeySolutionView.setData(journey)
        
        _addViewInScroll(view: journeySolutionView, customMargin: 0)
        
        if ridesharing {
            journeySolutionView.setDataRidesharing(journey)
            ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 255))
            ridesharingView.parentViewController = self
            
            _addViewInScroll(view: ridesharingView)
        }
    }
    
    private func _displayStep(_ journey: Journey) {
        if let sections = journey.sections {
            for (index, section) in sections.enumerated() {
                if let type = section.type {
                    switch type {
                        case .publicTransport:
                            if index == 0 {
                                _displayPublicTransport(section)
                            }
                            _displayPublicTransport(section, waiting: sections[index - 1])
                            break
                        case .transfer:
                            _displayTransferStep(section)
                            break
                        case .crowFly:
                            _displayCrowFlyStep(section)
                            break
                        case .ridesharing:
                            _updateRidesharingView(section)
                            _displayRidesharingStep(section)
                            break
                        case .streetNetwork:
                            if let mode = section.mode {
                                switch mode {
                                    case .walking:
                                        _displayTransferStep(section)
                                        break
                                    case .car:
                                        _displayTransferStep(section)
                                        break
                                    case .ridesharing:
                                        _updateRidesharingView(section)
                                        if let ridesharingJourneys = section.ridesharingJourneys {
                                            _displayStep(ridesharingJourneys[ridesharingIndex])
                                        }
                                    default:
                                        _displayBikeStep(section)
                                        break
                                }
                            }
                            break
                        default :
                            continue
                    }
                }
            }
        }
    }
    
    private func _displayDeparture(_ journey: Journey) {
        let viewDeparture = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewDeparture.information = journey.sections?.first?.from?.name ?? ""
        viewDeparture.time = journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        viewDeparture.type = .departure
        
        _addViewInScroll(view: viewDeparture)
    }
    
    private func _displayArrival(_ journey: Journey) {
        let viewArrival = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewArrival.information = journey.sections?.last?.to?.name ?? ""
        viewArrival.time = journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        viewArrival.type = .arrival
        
        _addViewInScroll(view: viewArrival)
    }
    
    private func _displayTransferStep(_ section: Section) {
        let view = TransferStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.time = section.duration?.minuteToString()
        view.direction = section.to?.name ?? ""
        
        _addViewInScroll(view: view)
    }
    
    private func _displayCrowFlyStep(_ section: Section) {
        let view = TransferStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.time = ""
        view.direction = section.to?.name ?? ""
        
        _addViewInScroll(view: view)
    }
    
    private func _displayBikeStep(_ section: Section) {
        let view = BikeStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.origin = section.from?.name ?? ""
        view.destination = section.to?.name ?? ""
        view.takeName = section.from?.poi?.properties?["network"] ?? ""
        view.time = section.duration?.minuteToString()
        
        _addViewInScroll(view: view)
    }
    
    private func _displayRidesharingStep(_ section: Section) {
        let view = RidesharingStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        view.origin = ridesharingView.addressFrom ?? ""
        view.destination = ridesharingView.addressTo ?? ""
        view.time = section.duration?.minuteToString()
        
        _addViewInScroll(view: view)
    }
    
    private func _displayPublicTransport(_ section: Section, waiting: Section? = nil) {
        let publicTransportView = PublicTransportView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        publicTransportView.modeString = Modes().getModeIcon(section: section)
        publicTransportView.take = section.displayInformations?.commercialMode ?? ""
        publicTransportView.transportColor = section.displayInformations?.color?.toUIColor() ?? UIColor.black
        publicTransportView.transportName = section.displayInformations?.label ?? ""
        publicTransportView.origin = section.from?.name ?? ""
        publicTransportView.startTime = section.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        publicTransportView.directionTransit = section.displayInformations?.direction ?? ""
        publicTransportView.destination = section.to?.name ?? ""
        publicTransportView.endTime = section.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""

        var stopDate: [String] = []
        if let stopDateTimes = section.stopDateTimes {
            for (index, stop) in stopDateTimes.enumerated() {
                if let name = stop.stopPoint?.name {
                    if index != 0 && index != (stopDateTimes.count - 1) {
                        stopDate.append(name)
                    }
                }
            }
        }
        publicTransportView.stations = stopDate
        if let waiting = waiting {
            if waiting.type == .waiting {
                if let durationWaiting = waiting.duration?.minuteToString() {
                    publicTransportView.waitTime = durationWaiting
                }
            }
        }
        
        if let links = section.displayInformations?.links {
            for link in links {
                if let type = link.type, let id = link.id, let disruptions = disruptions {
                    if type == "disruption" {
                        for disruption in disruptions {
                            if disruption.id == id {
                                publicTransportView.setDisruptionType(disruption)
                                publicTransportView.disruptionTitle = disruption.severity?.name
  
                                if let message = disruption.messages?.first?.escapedText {
                                    publicTransportView.disruptionInformation = message
                                }
                                if let begin = disruption.applicationPeriods?.first?.begin?.toDate(format: Configuration.date), let end = disruption.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
                                    publicTransportView.disruptionDate = String(format: "%@ %@ %@ %@",
                                                                                "from".localized(withComment: "Back", bundle: NavitiaSDKUI.shared.bundle),
                                                                                begin.toString(format: Configuration.dateInterval),
                                                                                "to_period".localized(withComment: "Back", bundle: NavitiaSDKUI.shared.bundle),
                                                                                end.toString(format: Configuration.dateInterval))
        
                                }
                            }
                        }
                    }
                }
            }
        }
        
        _addViewInScroll(view: publicTransportView)
    }
    
    private func _updateRidesharingView(_ section: Section) {
        if let ridesharingJourneys = section.ridesharingJourneys?[safe: ridesharingIndex] {
            ridesharingView.price = section.ridesharingJourneys?[safe: ridesharingIndex]?.fare?.total?.value ?? ""
            if let sectionRidesharing = ridesharingJourneys.sections?[safe: 1] {
                timeRidesharing = sectionRidesharing.duration
                ridesharingDeepLink = sectionRidesharing.links?[safe: 0]?.href
                ridesharingView.title = sectionRidesharing.ridesharingInformations?.network ?? ""
                ridesharingView.startDate = sectionRidesharing.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
                ridesharingView.login = sectionRidesharing.ridesharingInformations?.driver?.alias ?? ""
                ridesharingView.gender = sectionRidesharing.ridesharingInformations?.driver?.gender?.rawValue ?? ""
                ridesharingView.addressFrom = sectionRidesharing.from?.name ?? ""
                ridesharingView.addressTo = sectionRidesharing.to?.name ?? ""
                ridesharingView.seatCount(sectionRidesharing.ridesharingInformations?.seats?.available)
                ridesharingView.setPicture(url: sectionRidesharing.ridesharingInformations?.driver?.image)
                ridesharingView.setNotation(sectionRidesharing.ridesharingInformations?.driver?.rating?.count)
                ridesharingView.setFullStar(sectionRidesharing.ridesharingInformations?.driver?.rating?.value)
            }
        }
    }
    
    public func openDeepLink() {
        if let ridesharingDeepLink = ridesharingDeepLink {
            if let urlRidesharingDeepLink = URL(string: ridesharingDeepLink) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlRidesharingDeepLink, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(urlRidesharingDeepLink)
                }
            }
        }
    }
    
}

extension JourneySolutionRoadmapViewController {
    
    private func _setupMapView() {
        _drawSections(journey: journey)
        
        _drawPinAnnotation(coordinates: journey?.sections?.first?.geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
        _drawPinAnnotation(coordinates: journey?.sections?.last?.geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
        
        mapView.setVisibleMapRect(MKPolyline(coordinates: journeyPolyline, count: journeyPolyline.count).boundingMapRect,
                                  edgePadding: UIEdgeInsetsMake(60, 40, 10, 40),
                                  animated: true)
    }
    
    private func _drawSections(journey: Journey?) {
        guard let sections = journey?.sections else {
            return
        }
        
        for (_, section) in sections.enumerated() {
            if _drawRidesharingSection(section: section) {
                break
            }
            
            var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
            if let coordinates = section.geojson?.coordinates {
                for (_, coordinate) in coordinates.enumerated() {
                    if coordinate.count > 1 {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                    }
                }
            }
            
            _addSectionCircle(section: section)
            _addSectionPolyline(sectionPolylineCoordinates: sectionPolylineCoordinates, section: section)
        }
    }
    
    private func _drawRidesharingSection(section: Section) -> Bool {
        if let ridesharingJourneys = section.ridesharingJourneys {
            _drawSections(journey: ridesharingJourneys[ridesharingIndex])
            return true
        }
        
        if section.type == .ridesharing {
            _drawPinAnnotation(coordinates: section.geojson?.coordinates?.first, annotationType: .RidesharingAnnotation, placeType: .Other)
            _drawPinAnnotation(coordinates: section.geojson?.coordinates?.last, annotationType: .RidesharingAnnotation, placeType: .Other)
        }
        
        return false
    }
    
    private func _drawPinAnnotation(coordinates: [Double]?, annotationType: PinAnnotation.AnnotationType, placeType: PinAnnotation.PlaceType) {
        guard let coordinates = coordinates else {
            return
        }
        
        if coordinates.count > 1 {
            let pinAnnotation = PinAnnotation(coordinate: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                              annotationType: annotationType,
                                              placeType: placeType)
            mapView.addAnnotation(pinAnnotation)
            _getCircle(coordinates: coordinates)
        }
    }
    
    private func _addSectionPolyline(sectionPolylineCoordinates: [CLLocationCoordinate2D], section: Section) {
        var sectionPolyline = SectionPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)

        switch section.type {
        case .streetNetwork?:
            _streetNetworkPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .crowFly?:
            _crowFlyPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .publicTransport?:
            sectionPolyline.sectionStrokeColor = section.displayInformations?.color?.toUIColor()
            sectionPolyline.sectionLineWidth = 5
        case .transfer?:
            sectionPolyline.sectionStrokeColor = Configuration.Color.gray
            sectionPolyline.sectionLineWidth = 4
        case .ridesharing?:
            sectionPolyline.sectionStrokeColor = UIColor.black
            sectionPolyline.sectionLineWidth = 4
        default:
            sectionPolyline.sectionStrokeColor = UIColor.black
            sectionPolyline.sectionLineWidth = 4
        }
        
        mapView.add(sectionPolyline)
    }
    
    private func _streetNetworkPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
        sectionPolyline.sectionStrokeColor = Configuration.Color.gray
        sectionPolyline.sectionLineWidth = 4
        
        switch mode {
        case .walking?:
            sectionPolyline.sectionLineDashPattern = [0.01, NSNumber(value: Float(2 * sectionPolyline.sectionLineWidth))]
            sectionPolyline.sectionLineCap = CGLineCap.round
        default:
            break
        }
    }
    
    private func _crowFlyPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
        sectionPolyline.sectionStrokeColor = Configuration.Color.gray
        sectionPolyline.sectionLineWidth = 4
        
        switch mode {
        case .walking?:
            sectionPolyline.sectionLineDashPattern = [0.01, NSNumber(value: Float(2 * sectionPolyline.sectionLineWidth))]
            sectionPolyline.sectionLineCap = CGLineCap.round
        default:
            break
        }
    }
    
    private func _getCircle(coordinates: [Double]?, backgroundColor: UIColor? = Configuration.Color.black) {
        guard let coordinates = coordinates, let backgroundColor = backgroundColor else {
            return
        }
        
        if coordinates.count > 1 {
            let sectionCircle = SectionCircle(center: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                              radius: _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: mapView.camera.altitude))
            sectionCircle.sectionBackgroundColor = backgroundColor
            journeyPolyline.append(sectionCircle.coordinate)
            intermediatePointsCircles.append(sectionCircle)
        }
    }
    
    private func _addSectionCircle(section: Section) {
        if let coordinates = section.geojson?.coordinates {
            var backgroundColor = section.displayInformations?.color?.toUIColor()
            if section.type == .ridesharing {
                backgroundColor = Configuration.Color.black
            }
            
            _getCircle(coordinates: coordinates.first, backgroundColor: backgroundColor)
            _getCircle(coordinates: coordinates.last, backgroundColor: backgroundColor)
        }
    }
    
    private func _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        let altitudeReferenceValue = 10000.0
        let circleMaxmimumRadius = 100.0
        return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
    }
    
    private func _redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(intermediatePointsCircles)
        
        var updatedIntermediatePointsCircles = [SectionCircle]()
        for (_, drawnCircle) in intermediatePointsCircles.enumerated() {
            let updatedCircleView = SectionCircle(center: drawnCircle.coordinate,
                                                  radius: _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedCircleView.sectionBackgroundColor = drawnCircle.sectionBackgroundColor
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        intermediatePointsCircles = updatedIntermediatePointsCircles
        
        mapView.addOverlays(intermediatePointsCircles)
    }
    
}

extension JourneySolutionRoadmapViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        _redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let sectionPolyline = overlay as? SectionPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: sectionPolyline)
            polylineRenderer.lineWidth = sectionPolyline.sectionLineWidth
            polylineRenderer.strokeColor = sectionPolyline.sectionStrokeColor
            if let sectionLineDashPattern = sectionPolyline.sectionLineDashPattern {
                polylineRenderer.lineDashPattern = sectionLineDashPattern
            }
            if let sectionLineCap = sectionPolyline.sectionLineCap {
                polylineRenderer.lineCap = sectionLineCap
            }
            
            return polylineRenderer
        } else if let circle = overlay as? SectionCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.lineWidth = 1.5
            circleRenderer.strokeColor = circle.sectionBackgroundColor
            circleRenderer.fillColor = UIColor.white
            
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? PinAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotation.identifier)
            if annotationView == nil {
                annotationView = customAnnotation.getAnnotationView(annotationIdentifier: customAnnotation.identifier, bundle: NavitiaSDKUI.shared.bundle)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationViewIdentifier")
            annotationView?.annotation = annotation
            
            return annotationView
        }
    }
    
}

extension JourneySolutionRoadmapViewController {
    
    private func _addViewInScroll(view: UIView, customMargin: CGFloat? = nil) {
        if let margeCustom = customMargin {
            view.frame.origin.x = margeCustom
        } else {
            view.frame.origin.x = margin
        }
        if viewScroll.isEmpty {
            view.frame.origin.y = 0
        } else {
            if let viewBefore = viewScroll.last {
                view.frame.origin.y = viewBefore.frame.origin.y + viewBefore.frame.size.height
            }
        }
        viewScroll.append(view)
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height
        }
        scrollView.addSubview(view)
    }
    
    private func _updateOriginViewScroll() {
        for (index, view) in viewScroll.enumerated() {
            if index == 0 {
                view.frame.origin.y = view.frame.origin.x
                view.frame.size.width = _updateWidth(customMargin: view.frame.origin.x)
            } else {
                view.frame.origin.y = viewScroll[index - 1].frame.origin.y + viewScroll[index - 1].frame.height + margin
                composentWidth = _updateWidth()
                view.frame.size.width = _updateWidth()
            }
        }
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height + margin
        }
    }
    
}

extension JourneySolutionRoadmapViewController: AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
        openDeepLink()
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
}
