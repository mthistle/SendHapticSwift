//
//  ViewController.swift
//  SendHapticSwift
//
//  Created by Mark Thistle on 3/30/15.
//  Copyright (c) 2015 New Thistle LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sendHapticButton: UIButton!
    @IBOutlet weak var connectSpinner: UIActivityIndicatorView!
    
    var band: MSBClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prime the BandManager
        BandManager.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIControl Methods
    @IBAction func didSelectConnectButton(sender: AnyObject) {
        if let band = BandManager.sharedInstance.attachedClients()?.first as MSBClient? {
            self.connectSpinner.hidden = false
            self.connectSpinner.startAnimating()
            // listen for changes in client connection state
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateConnectionStatus:", name: kConnectionChangedNotification, object: nil)
            // connect to the band
            BandManager.sharedInstance.connectClient(band, completion: {(connected: Bool) in
                if !connected {
                    println("Failed to connect to band")
                    return
                } else {
                    self.band = band
                    self.connectSpinner.stopAnimating()
                    self.connectSpinner.hidden = true
                }
            })
        } else {
            println("No bands found yet, try again.")
        }
    }
    
    @IBAction func didSelectSendHapticButton(sender: AnyObject) {
        if let band = self.band {
            band.notificationManager.vibrateWithType(MSBVibrationType.NotificationOneTone, completionHandler: {(error) in
                if error != nil {
                    println("Error vibrating device: \(error)")
                }
            })
        }
    }
    
    // MARK: - Microsoft Band Methods
    func updateConnectionStatus(notification: NSNotification) {
        if let band = band {
            println("Connected to Microsoft Band: \(band.name)")
            self.sendHapticButton.enabled = true
        }
    }
}

