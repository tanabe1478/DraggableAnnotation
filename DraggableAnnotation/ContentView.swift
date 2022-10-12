//
//  ContentView.swift
//  DraggableAnnotation
//
//  Created by tanabe.nobuyuki on 2022/10/12.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var title = ""
    @State var subTitle = ""
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            MapView(title: self.$title, subTitle: self.$subTitle).edgesIgnoringSafeArea(.all)
            
            if self.title != "" {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.body)
                            .foregroundColor(.gray)
                        Text(self.subTitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color("Color"))
                .cornerRadius(15)
            }

        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct MapView: UIViewRepresentable {
    
    func makeCoordinator() -> Self.Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> some UIView {
        let map = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        map.delegate = context.coordinator
        map.addAnnotation(annotation)
        return map
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MapView>) {
    }
    
    @Binding var title: String
    @Binding var subTitle: String
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
 
        init(parent1: MapView) {
            parent = parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .red
            pin.animatesDrop = true
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
            guard let latitude = view.annotation?.coordinate.latitude,
                  let longitude = view.annotation?.coordinate.longitude else {
                return
            }
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (places, err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                }
                self.parent.title = (places?.first?.name ?? places?.first?.postalCode)!
                self.parent.subTitle = (places?.first?.locality ?? places?.first?.country ?? "None")!
                
            }
        }
    }
}
