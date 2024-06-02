//
//  ViewController.swift
//  CapitalCities
//
//  Created by Jason Cox on 6/1/24.
//

import Cocoa
import MapKit

class ViewController: NSViewController, MKMapViewDelegate {

    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var scoreLabel: NSTextField!
    @IBOutlet var mapView: MKMapView!
    var cities = [Pin]()
    var currentCity: Pin?
    
    var score = 0 {
        didSet {
            scoreLabel.stringValue = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
               
        setupMapView()
        updateUI()
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)
        
        startNewGame()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            updateUI()
        }
    }

    // Setup the map view
    private func setupMapView() {
        // You can set the initial region, add annotations, etc.
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -98.5795)
        let region = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 900000, longitudinalMeters: 900000)
        mapView.setRegion(region, animated: true)
    }
    
    // Update the UI elements
    private func updateUI() {
        questionLabel.stringValue = "Your question goes here."
        scoreLabel.stringValue = "Score: 0"
    }

    func addPin(at coord: CLLocationCoordinate2D) {
        // make sure we have a city that we're looking for
        guard let actual = currentCity else { return }
        
        // create a pin representing the player's guess, and add it to the map
        let guess = Pin(title: "Your guess", coordinate: coord, color: NSColor.red)
        mapView.addAnnotation(guess)
        
        // also add the correct answer
        mapView.addAnnotation(actual)
        
        // convert both coordinates to map points
        let point1 = MKMapPoint(guess.coordinate)
        let point2 = MKMapPoint(actual.coordinate)
        
        //calculate how many kilometers they are apart, then subtract that from 500
        let distance = Int(max(0, 500 - point1.distance(to: point2) / 1000))
        
        // add that to the score; this will trigger the property observer
        score += distance
        
        // tell the map view to select the correct answer, making it zoom in and show its title and subtitle
        mapView.selectAnnotation(actual, animated: true)
        
    }
    
    @objc func mapClicked(recognizer: NSClickGestureRecognizer) {
        if mapView.annotations.isEmpty {
            addPin(at: mapView.convert(recognizer.location(in: mapView), toCoordinateFrom: mapView))
        } else {
            mapView.removeAnnotations(mapView.annotations)
            nextCity()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        // convert the annotation to a pin so we can read its color
        guard let pin = annotation as? Pin else {return nil}
        
        // 2: Create an identifier string that will be used to share map pins
        let identifier = "Guess"
        
        // 3: Attempt to dequeue a pin from the re-use queue
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            // 4: There was no pin to re-use; create a new one
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            // 5: We got back a pin to re-use, so update its annotation to the new annotation
            annotationView!.annotation = annotation
        }
        // 6: Customize the pin so that it can show a call out and has a color
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = pin.color
            
        return annotationView
        
    }
    
    func startNewGame() {
        // Clear the score
        score = 0
        
        // Clear the map annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Create example cities
        cities = [
        Pin(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)),
        Pin(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)),
        Pin(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)),
        Pin(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)),
        Pin(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)),Pin(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.682839, longitude: 139.759455)),
        Pin(title: "Moscow", coordinate: CLLocationCoordinate2D(latitude: 55.755826, longitude: 37.6173)),
        Pin(title: "Beijing", coordinate: CLLocationCoordinate2D(latitude: 39.904202, longitude: 116.407394)),
        Pin(title: "Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.520007, longitude: 13.404954)),
        Pin(title: "Canberra", coordinate: CLLocationCoordinate2D(latitude: -35.280937, longitude: 149.130009)),
        Pin(title: "Brasília", coordinate: CLLocationCoordinate2D(latitude: -15.794229, longitude: -47.882166)),
        Pin(title: "Ottawa", coordinate: CLLocationCoordinate2D(latitude: 45.421530, longitude: -75.697193)),
        Pin(title: "New Delhi", coordinate: CLLocationCoordinate2D(latitude: 28.613939, longitude: 77.209021)),
        Pin(title: "Cairo", coordinate: CLLocationCoordinate2D(latitude: 30.044420, longitude: 31.235712)),
        Pin(title: "Madrid", coordinate: CLLocationCoordinate2D(latitude: 40.416775, longitude: -3.703790)),
        Pin(title: "Buenos Aires", coordinate: CLLocationCoordinate2D(latitude: -34.603684, longitude: -58.381559)),
        Pin(title: "Bangkok", coordinate: CLLocationCoordinate2D(latitude: 13.756331, longitude: 100.501762)),
        Pin(title: "Riyadh", coordinate: CLLocationCoordinate2D(latitude: 24.713552, longitude: 46.675296)),
        Pin(title: "Jerusalem", coordinate: CLLocationCoordinate2D(latitude: 31.768319, longitude: 35.213710)),
        Pin(title: "Seoul", coordinate: CLLocationCoordinate2D(latitude: 37.566536, longitude: 126.977966)),
        ]
        
        // Start playing the game
        nextCity()
    }
    
    func nextCity() {
        if let city = cities.popLast() {
            // make this the city to guess
            currentCity = city
            questionLabel.stringValue = "Where is \(city.title!)?"
        } else {
            // no more cities!
            currentCity = nil
            let alert = NSAlert()
            alert.messageText = "Final score: \(score)"
            alert.runModal()
            // Start a new game
            startNewGame()
        }
    }
    
}

