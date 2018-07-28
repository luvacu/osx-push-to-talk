//
//  Microphone.swift
//  PushToTalk
//
//  Created by Chris Nielubowicz on 12/5/16.
//  Copyright © 2016 yulrizka. All rights reserved.
//

import AudioToolbox

final class Microphone {

    typealias StatusUpdate = (MicrophoneStatus) -> ()
    var statusUpdated: StatusUpdate?

    /// Public method to set status of the microphone
    ///
    /// - Discussion:
    ///     This method calls necessary private methods to mute or unmute the microphone
    var status: MicrophoneStatus = .muted {
        didSet {
            setMuted(status == .muted)
            statusUpdated?(status)
        }
    }

    func toggleStatus() {
        status = (status == .muted) ? .speaking : .muted
    }
}

// MARK - Sound Methods
private extension Microphone {
    
    func setMuted(_ muted: Bool) {
        
        /* https://github.com/paulreimer/ofxAudioFeatures/blob/master/src/ofxAudioDeviceControl.mm */

        var mute: UInt32 = muted ? 1 : 0
        let size = UInt32(MemoryLayout.size(ofValue: mute))

        // set mute
        var muteInputPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyMute,
                                                                  mScope: kAudioDevicePropertyScopeInput,
                                                                  mElement: kAudioObjectPropertyElementMaster)

        AudioObjectSetPropertyData(defaultInputDeviceId, &muteInputPropertyAddress, 0, nil, size, &mute)
    }

    var defaultInputDeviceId: AudioDeviceID {
        var inputDeviceID = AudioDeviceID(0)
        var inputDeviceIDSize = UInt32(MemoryLayout.size(ofValue: inputDeviceID))

        var getDefaultInputDevicePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDefaultInputDevice,
                                                                              mScope: kAudioObjectPropertyScopeGlobal,
                                                                              mElement: kAudioObjectPropertyElementMaster)

        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultInputDevicePropertyAddress,
            0,
            nil,
            &inputDeviceIDSize,
            &inputDeviceID)

        return inputDeviceID
    }
}
