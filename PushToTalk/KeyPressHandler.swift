//
//  KeyPressHandler.swift
//  PushToTalk
//
//  Created by Luis Valdés on 28/7/18.
//  Copyright © 2018 yulrizka. All rights reserved.
//

import Cocoa

final class KeyPressHandler {
    enum KeyEvent {
        case keyDown
        case keyUp
    }

    var didPressKey: ((KeyEvent) -> Void)?

    private let keyCode: UInt16
    private let isModifierKey: Bool

    init(keyCode: UInt16, isModifierKey: Bool) {
        self.keyCode = keyCode
        self.isModifierKey = isModifierKey

        let eventsMask: NSEvent.EventTypeMask = isModifierKey ? [.flagsChanged] : [.keyDown, .keyUp]

        // Handle key press events when application is on background
        NSEvent.addGlobalMonitorForEvents(matching: eventsMask, handler: { [weak self] event in
            self?.handleKeyEvent(event)
        })

        // Handle key press events when application is on foreground
        NSEvent.addLocalMonitorForEvents(matching: eventsMask, handler: { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        })
    }

    // MARK - Event Handling
    private var previousModifierFlags: NSEvent.ModifierFlags?

    private func handleKeyEvent(_ event: NSEvent) {
        guard event.keyCode == keyCode else {
            return
        }

        let keyEvent: KeyEvent
        if isModifierKey {
            if let previousModifierFlags = previousModifierFlags {
                keyEvent = previousModifierFlags.intersection(event.modifierFlags).isEmpty ? .keyUp : .keyDown
            } else {
                keyEvent = .keyDown
            }
            previousModifierFlags = event.modifierFlags
        } else {
            keyEvent = event.type == .keyDown ? .keyDown : .keyUp
        }

        didPressKey?(keyEvent)
    }
}
