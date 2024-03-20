import SwiftUI
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import CoreLocation

struct ContentView: View {
    @State private var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
    ]

    @State private var directionsRoute: Route?
    @State private var showNavigation = false

    @State private var locationManager = CLLocationManager()

    var body: some View {
        // Your map view content
        MapView(annotations: $annotations, directionsRoute: $directionsRoute, showNavigation: $showNavigation)
            .centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324))
            .zoomLevel(16.0)
            .styleURL(MGLStyle.streetsStyleURL)
            .onAppear {
                requestLocationPermission()
            }
            .sheet(isPresented: $showNavigation, content: {
                NavigationView(directionsRoute: self.$directionsRoute, showNavigation: self.$showNavigation)
            })
    }

    func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension ContentView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted
            print("Location permission granted")
           
            locationManager.startUpdatingLocation() 
        case .denied:
            // Permission denied
            print("Location permission denied")
           
            print("Please enable location access for this app in Settings.")
        case .restricted:
            // Permission restricted
            print("Location permission restricted")
            print("Location access is restricted. Please contact your device administrator.")
        case .notDetermined:
            // Permission not determined yet
            print("Location permission not determined")
           
            print("Location permission is not determined yet.")
        default:
            break
        }
    }
}
