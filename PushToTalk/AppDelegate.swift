//
//  AppDelegate.swift
//  PushToTalk
//
//  Created by Ahmy Yulrizka on 17/03/15.
//  Copyright (c) 2015 yulrizka. All rights reserved.
//

import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet private weak var window: NSWindow!
    @IBOutlet private weak var statusMenu: NSMenu!
    @IBOutlet private weak var menuItemToggle: NSMenuItem!
    
    private let microphone = Microphone()
    private let keyHandler = KeyPressHandler(keyCode: 61, isModifierKey: true)
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: -1)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        microphone.statusUpdated = { [weak self] status in
            self?.menuItemToggle.title = status.title
            self?.statusItem.image = status.image
        }
        
        microphone.status = .muted
    }

    // MARK: Menu item Actions
    @IBAction private func toggleAction(_ sender: NSMenuItem) {
        microphone.toggleStatus()
    }
    
    @IBAction private func menuItemQuitAction(_ sender: NSMenuItem) {
        microphone.status = .speaking
        exit(0)
    }
}
