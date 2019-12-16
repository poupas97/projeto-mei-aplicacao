//
//  LeagueTableViewController.swift
//  Project
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 ipleiria. All rights reserved.
//

import UIKit
import CoreLocation

class LeagueTableViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager: CLLocationManager = CLLocationManager();
    let geoCoder = CLGeocoder()
    
    var cityFounded: String? = nil
    
    @IBOutlet var leagueTableView: UITableView!
    
    var leagues: [League] = [League(id: 1, name: "honra"), League(id: 2, name: "serie a")];
    let identifier = "LeagueIdentifier";
    var idToSend: Int = 0;
    var idReceived: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation();
        
        leagueTableView.delegate = self
        locationManager.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - GPS
    
    @IBAction func stateGPS(_ sender: Any) {
        if(CLLocationManager.authorizationStatus() != .authorizedWhenInUse && CLLocationManager.authorizationStatus() !=  .authorizedAlways) {
            getLocation();
        }
    }
    
    private func getLocation () {
        // open defenictions
        locationManager.requestAlwaysAuthorization();
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
            print("authorizationStatus")
            locationManager.startUpdatingLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, _) -> Void in
            let placemark = placemarks?.last!
            let city = placemark?.locality
            self.cityFounded = city!
            
            if self.cityFounded != nil {
                self.tableView.beginUpdates();
            }
        })
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! LeagueTableViewCell;
        cell.labelOutlet.text = leagues[indexPath.row].name;
        return cell;
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idToSend = leagues[indexPath.row].id;
        performSegue(withIdentifier: "goToClassification", sender: idToSend);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as? ClassificationTableViewController;
        info?.idLeagueReceived = self.idToSend;
    }
}
