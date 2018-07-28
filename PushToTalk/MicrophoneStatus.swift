//
//  MicrophoneStatus.swift
//  PushToTalk
//
//  Created by Chris Nielubowicz on 12/5/16.
//  Copyright © 2016 yulrizka. All rights reserved.
//

import Cocoa

enum MicrophoneStatus {
    case muted
    case speaking
}

protocol GUIRepresentable {
    var image: NSImage { get }
    var title: String { get }
}

extension MicrophoneStatus: GUIRepresentable {
    var image: NSImage {
        switch self {
        case .muted:
            return NSImage(named: NSImage.Name(rawValue: "statusIconMute"))!
        case .speaking:
            return NSImage(named: NSImage.Name(rawValue: "statusIconTalk"))!
        }
    }

    var title: String {
        switch self {
        case .muted:
            return "Disable"
        case .speaking:
            return "Enable"
        }
    }
}
