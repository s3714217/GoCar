//
//  DashboardController.swift
//  GoCar
//
//  Created by Thien Nguyen on 9/3/21.
//

import UIKit
import FirebaseAuth
import Firebase
import MapKit
import CoreLocation
import FirebaseFirestore

struct InputCarData {
    var title: String
    var image: UIImage
    var info: String
}

class DashboardController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    private var databaseService = DBService()
    private let currentUser = Auth.auth().currentUser
    private var all_cars : [Car] = []
    private var all_locations : [parking_location] = []
    private var selected_car_toView = Car()
    private var selected_address_toView = parking_location()
    private var locationManager : CLLocationManager!
    private var displayable_location : [parking_location] = []
    private var current_user_lat : Double = 0
    private var current_user_long : Double = 0
    private var car_data_at_location = [InputCarData]()
    private var pickerData : [String] = []
    private var typePickerData : [String] = []
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var modelPicker: UIPickerView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    
    
    //____________________________________Setup____________________________________
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDescription"{
            let controller = segue.destination as! DescriptionController
           
            controller.carLocation = self.selected_address_toView
            controller.selectedCar = self.selected_car_toView
            controller.distanceFromUser = Int(CLLocation(latitude: current_user_lat, longitude: current_user_long).distance(from: CLLocation(latitude: self.selected_address_toView.lat, longitude: self.selected_address_toView.long)))
        }
    }
    
    
    override func viewDidLoad() {
        
        self.smallView.isHidden = true
        self.smallView.layer.cornerRadius = 30
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.getUserLocation()
        self.filterBtn.isEnabled = false
        databaseService.retrievingAvailableCars()
        databaseService.retrievingLocation()
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if self.databaseService.getCars().count > 0 && self.databaseService.getLocation().count > 0{
                timer.invalidate()
                self.databaseService.sortingCars()
                self.all_cars = self.databaseService.getCars()
                self.all_locations = self.databaseService.getLocation()
                self.displayable_location = self.all_locations
                self.view.addSubview(self.collectionView)
                self.mapKit.delegate = self
                self.tabBar.delegate = self
                self.searchBar.delegate = self
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
                self.collectionView.isHidden = true
                self.displayMarker()
                self.filterBtn.isEnabled = true
                self.mapKit.showsCompass = false
                super.viewDidLoad()
                
            }
           
        }
        
    }
    @IBAction func refresh(_ sender: Any) {
        self.all_cars = self.databaseService.getCars()
        self.all_locations = self.databaseService.getLocation()
        self.displayable_location = self.all_locations
        self.displayMarker()
    }
    
    //____________________________________MapView____________________________________
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        let title = annotationView.annotation?.title as! String
        if title != "My Location"{
            annotationView.markerTintColor = .purple
            annotationView.selectedGlyphImage = UIImage(imageLiteralResourceName: "toyota corolla")
            
            return annotationView
        }

        return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        return
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        return
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title == "My Location"{
           return
        }
        for l in self.all_locations {
            if l.address ==  view.annotation?.title as! String{
                self.selected_address_toView = l
                self.car_data_at_location = []
                for c in l.cars{
                    var contained = false
                   
                    for d in self.car_data_at_location{
                        if d.title.lowercased().trimmingCharacters(in: .whitespaces) == c.model.lowercased().trimmingCharacters(in: .whitespaces){
                            contained = true
                        }
                    }
                    if !contained{
                        self.car_data_at_location.append(InputCarData(title: c.model, image: UIImage(imageLiteralResourceName: c.model.lowercased().trimmingCharacters(in: .whitespaces) ), info: "$\(c.rate)/hr $\(c.rate * 9)/day"))
                    }
                }
                break
            }
        }
        
//        self.car_data_at_location = []
//        for car in self.all_cars{
//            let location = view.annotation?.title as! String
//            if car.parking_location.lowercased() == location.lowercased(){
//                var contained = false
//
//                for d in self.car_data_at_location{
//                    if d.title.lowercased().trimmingCharacters(in: .whitespaces) == car.model.lowercased().trimmingCharacters(in: .whitespaces){
//                        contained = true
//                    }
//                }
//                if !contained{
//                    self.car_data_at_location.append(InputCarData(title: car.model, image: UIImage(imageLiteralResourceName: car.model.lowercased().trimmingCharacters(in: .whitespaces) ), info: "$\(car.rate)/hr $\(car.rate * 9)/day"))
//                }
//            }
//        }
        
        
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.smallView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.smallView.isHidden = true
        self.collectionView.isHidden = true
    }
    
    
    
    //____________________________________SearchBar____________________________________
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchtxt = searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces)
        
        self.displayable_location = []
        
        for l in self.all_locations{
            if l.suburd.lowercased().trimmingCharacters(in: .whitespaces) == searchtxt{
                self.displayable_location.append(l)
            }
        }
        displayMarker()
        
        self.view.endEditing(true)
        searchBar.text = ""
    
        
    }
    func searchBar(_ searchBar : UISearchBar, textDidChange searchText: String){
        
        return
    }
    
    //____________________________________LocationManager____________________________________
    
    
    //____________________________________CollectionView____________________________________
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return car_data_at_location.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.data = self.car_data_at_location[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for c in self.all_cars{
            if self.car_data_at_location[indexPath.row].title == c.model && self.selected_address_toView.address == c.parking_location{
                self.selected_car_toView = c
                break
            }
        }
        
            self.performSegue(withIdentifier: "toDescription", sender: self)
       
        }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
           let cell = collectionView.cellForItem(at: indexPath)
           cell?.layer.borderWidth = 2.0
           cell?.layer.borderColor = UIColor.purple.cgColor
       }
   
       func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           let cell = collectionView.cellForItem(at: indexPath)
           cell?.layer.borderWidth = 2.0
           cell?.layer.borderColor = UIColor.clear.cgColor
       }
    //____________________________________PickerView____________________________________
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if pickerView == self.modelPicker{
            return pickerData.count
        }
        else{
            return typePickerData.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.modelPicker{
            return pickerData[row]
        }
        else{
            return typePickerData[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == self.modelPicker{
            
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 15)
            label.text =  pickerData[row]
            label.textAlignment = .center
            return label
        }
        else{
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 15)
            label.text =  self.typePickerData[row].capitalized
            label.textAlignment = .center
            return label
        }
    }
    
    
    
    private var selectedIndexModel = 0
    private var selectedIndexType = 0
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.modelPicker{
            selectedIndexModel = row
        }
        else{
            selectedIndexType = row
            self.pickerData = []
            if selectedIndexType == 0{
                self.pickerData.append("All Model")
            }
           
            for car in self.all_cars{
               
                var contained = false
                for d in self.pickerData{
                    if car.model.lowercased().trimmingCharacters(in: .whitespaces) == d.lowercased().trimmingCharacters(in: .whitespaces){
                        contained = true
                    }
                    
                }
                
                if !contained && selectedIndexType != 0{
                    if car.vehicle_type.lowercased().trimmingCharacters(in: .whitespaces) == typePickerData[selectedIndexType].lowercased().trimmingCharacters(in: .whitespaces){
                        self.pickerData.append(car.model )
                    }
                }
                else if !contained && selectedIndexType == 0{
                    self.pickerData.append(car.model )
                }
                
            }
            self.modelPicker.selectRow(0, inComponent: 0, animated: true)
            self.modelPicker.reloadAllComponents()
        }
       
    }
    //____________________________________Action____________________________________
    
    @IBAction func close(_ sender: Any) {
        self.smallView.isHidden = true
        self.collectionView.isHidden = true
        
    }
    @IBAction func closePopUp(_ sender: Any) {
        self.popUp.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBAction func showFilter(_ sender: Any) {
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        self.view.addSubview(blurEffectView)
        self.pickerData = []
        self.typePickerData = []
        self.smallView.isHidden = true
        self.collectionView.isHidden = true
        self.popUp.center = self.view.center
        self.popUp.layer.cornerRadius = 30
        self.doneBtn.layer.cornerRadius = 12
        self.pickerData.append("All Model")
        self.typePickerData.append("All Type")
        slider.value = slider.maximumValue
        distanceLabel.text = "\(String(Int(slider.value))) m"
        for car in self.all_cars{
            var contained = false
            for d in self.pickerData{
                if car.model.lowercased().trimmingCharacters(in: .whitespaces) == d.lowercased().trimmingCharacters(in: .whitespaces){
                    contained = true
                }
                
            }
            if !contained{
                self.pickerData.append(car.model )
            }
            
            var contained2 = false
            for t in self.typePickerData{
                if car.vehicle_type.lowercased().trimmingCharacters(in: .whitespaces) == t.lowercased().trimmingCharacters(in: .whitespaces){
                    contained2 = true
                }
            }
            if !contained2{
                self.typePickerData.append(car.vehicle_type)
            }
            
        }
        self.typePickerView.delegate = self
        self.modelPicker.delegate = self
        self.typePickerView.selectRow(0, inComponent: 0, animated: true)
        self.view.addSubview(self.popUp)
        
    }
    @IBOutlet weak var distanceLabel: UILabel!
    private var filterRange = 5000
    @IBAction func sliding(_ sender: UISlider) {
        
        let newValue = Int(sender.value/100) * 100
            sender.setValue(Float(newValue), animated: false)
        distanceLabel.text = "\(String(Int(sender.value)))m"
        filterRange = Int(sender.value)
    }
    
    @IBAction func closeFilter(_ sender: Any) {
        self.displayable_location = self.all_locations
        if selectedIndexModel != 0
        {
            self.displayable_location = []
            for location in self.all_locations {
                for car in location.cars{
                    
                    if car.model.lowercased().trimmingCharacters(in: .whitespaces) == pickerData[selectedIndexModel].lowercased().trimmingCharacters(in: .whitespaces){
                        self.displayable_location.append(location)
                    }
                }
               
            }
        }
        
        let currentLocation = CLLocation(latitude: self.current_user_lat, longitude: self.current_user_long)
        
        let orginal = self.displayable_location
        self.displayable_location = []
        
        for l in orginal {
            let distance = currentLocation.distance(from: CLLocation(latitude: l.lat, longitude: l.long))
            if Int(distance) < Int(filterRange) {
                self.displayable_location.append(l)
            }
            
        }
      
        self.blurEffectView.removeFromSuperview()
        
        self.displayMarker()
        self.popUp.removeFromSuperview()
    }
    //____________________________________NavBar____________________________________
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trip"{
            self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Help"{
            self.performSegue(withIdentifier: "toHelp", sender: self)
        }
    }
    
    func displayMarker() {
        self.mapKit.removeAnnotations(self.mapKit.annotations)
        for l in self.displayable_location{
            if l.car_count > 0{
                let annotation = MKPointAnnotation()
                annotation.title = l.address
                annotation.subtitle = "\(String(Int(CLLocation(latitude: self.current_user_lat, longitude: self.current_user_long).distance(from: CLLocation(latitude: l.lat, longitude: l.long)))))m away"
                annotation.coordinate = .init(latitude: l.lat, longitude: l.long)
                self.mapKit.addAnnotation(annotation)
            }
            
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

            locationManager.startUpdatingLocation()
            let userLocation:CLLocation = locations[0] as CLLocation
            let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            self.current_user_lat = userLocation.coordinate.latitude
            self.current_user_long = userLocation.coordinate.longitude
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapKit.setRegion(region, animated: false)
            locationManager.stopUpdatingLocation()
    }
    func getUserLocation(){
            
             locationManager.delegate = self
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.requestAlwaysAuthorization()
             
             if CLLocationManager.locationServicesEnabled() {
                 locationManager.startUpdatingLocation()
             }
    }
   
    
}




