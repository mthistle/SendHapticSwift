//
//  BandManager.swift
//  Blitz Talk
//
//  Created by Mark Thistle on 3/16/15.
//  Copyright (c) 2015 New Thistle LLC. All rights reserved.
//

import Foundation

let kConnectionChangedNotification = "kConnectionChangedNotification"
let kConnectionFailedNotification  = "kConnectionFailedNotification"

private let _SharedBandManagerInstance = BandManager()

class BandManager : NSObject, MSBClientManagerDelegate {
    
    private(set) var client: MSBClient?
    private var connectionBlock: ((Bool) -> ())?
    private var discoveredClients = [MSBClient]()
    
    private var clientManager = MSBClientManager.sharedManager()
    
    class var sharedInstance: BandManager {
        return _SharedBandManagerInstance
    }
    
    override init() {
        super.init()
        self.clientManager.delegate = self
    }
    
    func attachedClients() -> [MSBClient]? {
        if let manager = self.clientManager {
            self.discoveredClients = [MSBClient]()
            for client in manager.attachedClients() {
                self.discoveredClients.append(client as! MSBClient)
            }
        }
        return self.discoveredClients
    }
    
    func disconnectClient(client: MSBClient) {
        if (!client.isDeviceConnected) {
            return;
        }
        if let manager = self.clientManager {
            manager.cancelClientConnection(client)
            self.client = nil
        }
    }
    
    func connectClient(client: MSBClient, completion: (connected: Bool) -> Void) {
        if (client.isDeviceConnected && self.client == client) {
            if (self.connectionBlock != nil)
            {
                self.connectionBlock!(true)
            }
            return;
        }
        
        if let connectedClient = self.client {
            self.disconnectClient(client)
        }
        
        self.connectionBlock = completion;
        self.clientManager.connectClient(client)
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        if (self.connectionBlock != nil) {
            self.client = client
            self.connectionBlock!(true)
            self.connectionBlock = nil
        }
        
        self.fireClientChangeNotification(client)
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        self.fireClientChangeNotification(client)
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        if error != nil {
            println(error)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(kConnectionFailedNotification, object: self, userInfo: ["client": client])
    }
    
    func fireClientChangeNotification(client: MSBClient) {
        NSNotificationCenter.defaultCenter().postNotificationName(kConnectionChangedNotification, object: self, userInfo: ["client": client])
    }
    
}
