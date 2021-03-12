//
//  DashboardController.swift
//  GoCar
//
//  Created by Thien Nguyen on 9/3/21.
//

import UIKit
import FirebaseAuth
import Firebase
import DropDown
import MapKit
import CoreLocation
import FirebaseFirestore

struct CustomData {
    var title: String
    var image: UIImage
    var info: String
}

class DashboardController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
  
    private var db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    var selectedItem = ""
    var locationManager : CLLocationManager!
   
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let data = [
                CustomData(title: "Toyota Corolla", image: #imageLiteral(resourceName: "Honda Civic"), info: "$9/hr $80/day"),
                CustomData(title: "Honda Odyssey", image: #imageLiteral(resourceName: "Honda Odyssey"), info: "$12/hr $90/day"),
                CustomData(title: "Honda Civic", image: #imageLiteral(resourceName: "Honda Civic"), info: "$11/hr $100/day"),
                CustomData(title: "Ford F-150", image: #imageLiteral(resourceName: "Ford F-150"), info: "$15/hr $110/day"),
                ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.collectionView)
        self.tabBar.delegate = self
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        getUserLocation()
    }
  
    func searchBar(_ searchBar : UISearchBar, textDidChange searchText: String){
    }
    
    //_________________________________________________________________________________
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

            let userLocation:CLLocation = locations[0] as CLLocation
            let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            mapKit.setRegion(region, animated: true)
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
    
    //_________________________________________________________________________________
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.isHighlighted = true
        cell.data = self.data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = self.data[indexPath.row].title
        self.performSegue(withIdentifier: "toDescription", sender: self)
       
    }
    
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.purple.cgColor
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.clear.cgColor
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDescription"{
            let controller = segue.destination as! DescriptionController
            controller.carName = self.selectedItem
        }
    }
    //_________________________________________________________________________________
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trips"{
           // self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Help"{
            //self.performSegue(withIdentifier: "toHelp", sender: self)
        }
    }
}



class CustomCell: UICollectionViewCell {
    
    var data: CustomData?{
        didSet{
            guard let data = data else {return}
            img.image = data.image
            info.text = data.info
            title.text = data.title
            
        }
    }
    
    private var img: UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    private var info: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .darkGray
        label.text = "Press to view"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(img)
        contentView.addSubview(title)
        contentView.addSubview(info)
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width-10, height: 20)
        label.frame = CGRect(x: 5, y: contentView.frame.size.height-20, width: contentView.frame.size.width-10, height: 20)
        info.frame = CGRect(x: 5, y: contentView.frame.size.height-40, width: contentView.frame.size.width-10, height: 20)
        img.frame = CGRect(x: 5, y: 20, width: contentView.frame.size.width-10, height: contentView.frame.size.height-50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
