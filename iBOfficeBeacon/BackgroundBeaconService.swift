//
//  BackgroundBeaconService
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class BackgroundBeaconService:NSObject, ESTBeaconManagerDelegate {
    
    var client: ESTBeaconManager!
    var notificationService: LocalNotificationService!
    var store: BeaconAddressStore!
    
    var lastEnteredRegion: CLBeaconRegion!
    
    init(withBeaconClient client:ESTBeaconManager,
        andNotificationService service: LocalNotificationService,
        officeStore: BeaconAddressStore) {
        
        self.client = client
        self.notificationService = service
        self.store = officeStore
    }
    
    func startBackgroundMonitoring() {
        client.delegate = self
        client.monitoredRegions.forEach{
            client.startMonitoringForRegion($0 as! CLBeaconRegion)
        }
    }
    
    //Mark: ESTBeaconManagerDelegate
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        if let room = store.roomWithMajor((region.major?.integerValue)!, minor: (region.minor?.integerValue)!) {
            lastEnteredRegion = region
            notificationService.clearLastNotification()
            notificationService.fireNotification("You are in \(room.name)")
        }
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        if lastEnteredRegion != nil && lastEnteredRegion.isEqualTo(region) {
            notificationService.clearLastNotification()
        }
    }
}
