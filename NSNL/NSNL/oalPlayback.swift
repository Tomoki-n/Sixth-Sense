//
//  oalPlayback.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/21/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//

import UIKit
import AVFoundation

import OpenAL.AL
import OpenAL.ALC
typealias ALCcontext = COpaquePointer
typealias ALCdevice = COpaquePointer

let kDefaultDistance: Float = 25.0

@objc(oalPlayback)
class oalPlayback: NSObject {
    @IBOutlet var musicSwitch: UISwitch!
    
    var source: ALuint = 0
    var buffer: ALuint = 0
    var context: ALCcontext = nil
    var device: ALCdevice = nil
    
    var data: UnsafeMutablePointer<Void> = nil
    var sourceVolume: ALfloat = 0
    // Whether the sound is playing or stopped
    dynamic var isPlaying: Bool = false
    // Whether playback was interrupted by the system
    var wasInterrupted: Bool = false
    
    var bgURL: NSURL!
    var bgPlayer: AVAudioPlayer?
    // Whether the iPod is playing
    var iPodIsPlaying: Bool = false
    
    
    //MARK: AVAudioSession
    //- (void)handleInterruption:(NSNotification *)notification
    //{
    func handleInterruption(notification: NSNotification) {
    //    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
        let theInterruptionType = notification.userInfo![AVAudioSessionInterruptionTypeKey] as? UInt ?? 0
    //
    //    NSLog(@"Session interrupted > --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
        NSLog("Session interrupted > --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionType.Began.rawValue ? "Begin Interruption" : "End Interruption")
    //
    //    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        if theInterruptionType == AVAudioSessionInterruptionType.Began.rawValue {
    //        alcMakeContextCurrent(NULL);
            alcMakeContextCurrent(nil)
    //        if (self.isPlaying) {
            if self.isPlaying {
    //            self.wasInterrupted = YES;
                self.wasInterrupted = true
    //        }
            }
    //    } else if (theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        } else if theInterruptionType == AVAudioSessionInterruptionType.Ended.rawValue {
            // make sure to activate the session
    //        NSError *error;
            var error: NSError?
    //        bool success = [[AVAudioSession sharedInstance] setActive:YES error:&error];
            let success = AVAudioSession.sharedInstance().setActive(true, error: &error)
    //        if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
            if !success {
                NSLog("Error setting session active! %@\n", error!.localizedDescription)
            }
    //
    //        alcMakeContextCurrent(self.context);
            alcMakeContextCurrent(self.context)
    //
    //        if (self.wasInterrupted)
    //        {
            if self.wasInterrupted {
    //            [self startSound];
                self.startSound()
    //            self.wasInterrupted = NO;
                self.wasInterrupted = false
    //        }
            }
    //    }
        }
    //}
    }
    //
    //MARK: -Audio Session Route Change Notification
    //
    //- (void)handleRouteChange:(NSNotification *)notification
    //{
    func handleRouteChange(notification: NSNotification) {
    //    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
        let reasonValue = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? UInt ?? 0
    //    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    //
    //    NSLog(@"Route change:");
        NSLog("Route change:")
    //    switch (reasonValue) {
        switch reasonValue {
    //        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        case AVAudioSessionRouteChangeReason.NewDeviceAvailable.rawValue:
    //            NSLog(@"     NewDeviceAvailable");
            NSLog("     NewDeviceAvailable")
    //            break;
    //        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.rawValue:
    //            NSLog(@"     OldDeviceUnavailable");
            NSLog("     OldDeviceUnavailable")
    //            break;
    //        case AVAudioSessionRouteChangeReasonCategoryChange:
        case AVAudioSessionRouteChangeReason.CategoryChange.rawValue:
    //            NSLog(@"     CategoryChange");
            NSLog("     CategoryChange")
    //            NSLog(@" New Category: %@", [[AVAudioSession sharedInstance] category]);
            NSLog(" New Category: %@", AVAudioSession.sharedInstance().category)
    //            break;
    //        case AVAudioSessionRouteChangeReasonOverride:
        case AVAudioSessionRouteChangeReason.Override.rawValue:
    //            NSLog(@"     Override");
            NSLog("     Override")
    //            break;
    //        case AVAudioSessionRouteChangeReasonWakeFromSleep:
        case AVAudioSessionRouteChangeReason.WakeFromSleep.rawValue:
    //            NSLog(@"     WakeFromSleep");
            NSLog("     WakeFromSleep")
    //            break;
    //        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
        case AVAudioSessionRouteChangeReason.NoSuitableRouteForCategory.rawValue:
    //            NSLog(@"     NoSuitableRouteForCategory");
            NSLog("     NoSuitableRouteForCategory")
    //            break;
    //        default:
        case AVAudioSessionRouteChangeReason.RouteConfigurationChange.rawValue:
            NSLog("     RouteConfigurationChange")
        default:
    //            NSLog(@"     ReasonUnknown");
            NSLog("     ReasonUnknown")
    //    }
        }
    //
        if let routeDescription = notification.userInfo![AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
    //    NSLog(@"Previous route:\n");
            NSLog("Previous route:\n")
    //    NSLog(@"%@", routeDescription);
            NSLog("%@", routeDescription)
        }
    //}
    }
    //
    //- (void)initAVAudioSession
    //{
    func initAVAudioSession() {
        // Configure the audio session
    //    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
        let sessionInstance = AVAudioSession.sharedInstance()
    //    NSError *error;
        var error: NSError?
    
        // set the session category
    //    iPodIsPlaying = [sessionInstance isOtherAudioPlaying];
        iPodIsPlaying = sessionInstance.otherAudioPlaying
    //    NSString *category = iPodIsPlaying ? AVAudioSessionCategoryAmbient : AVAudioSessionCategorySoloAmbient;
        let category = iPodIsPlaying ? AVAudioSessionCategoryAmbient : AVAudioSessionCategorySoloAmbient
    //    bool success = [sessionInstance setCategory:category error:&error];
        var success = sessionInstance.setCategory(category, error: &error)
    //    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
        if !success {
            NSLog("Error setting AVAudioSession category! %@\n", error!.localizedDescription)
        }
    //
    //    double hwSampleRate = 44100.0;
        let hwSampleRate = 44100.0
    //    success = [sessionInstance setPreferredSampleRate:hwSampleRate error:&error];
        success = sessionInstance.setPreferredSampleRate(hwSampleRate, error: &error)
    //    if (!success) NSLog(@"Error setting preferred sample rate! %@\n", [error localizedDescription]);
        if !success {
            NSLog("Error setting preferred sample rate! %@\n", error!.localizedDescription)
        }
    
        // add interruption handler
    //    [[NSNotificationCenter defaultCenter]   addObserver:self
        NSNotificationCenter.defaultCenter().addObserver(self,
    //                                            selector:@selector(handleInterruption:)
            selector: "handleInterruption:",
    //                                            name:AVAudioSessionInterruptionNotification
            name: AVAudioSessionInterruptionNotification,
    //                                            object:sessionInstance];
            object: sessionInstance)
    
        // we don't do anything special in the route change notification
    //    [[NSNotificationCenter defaultCenter]   addObserver:self
        NSNotificationCenter.defaultCenter().addObserver(self,
    //                                            selector:@selector(handleRouteChange:)
            selector: "handleRouteChange:",
    //                                            name:AVAudioSessionRouteChangeNotification
            name: AVAudioSessionRouteChangeNotification,
    //                                            object:sessionInstance];
            object: sessionInstance)
        
        // activate the audio session
    //    success = [sessionInstance setActive:YES error:&error];
        success = sessionInstance.setActive(true, error: &error)
    //    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
        if !success {
            NSLog("Error setting session active! %@\n", error!.localizedDescription)
        }
    //}
    }
    //
    //MARK: Object Init / Maintenance
    override init() {
        super.init()
        // Start with our sound source slightly in front of the listener
        self._sourcePos = CGPointMake(0.0, -70.0)
        
        // Put the listener in the center of the stage
        self._listenerPos = CGPointMake(0.0, 0.0)
        
        // Listener looking straight ahead
        self._listenerRotation = 0.0
        
        		// Setup AVAudioSession
        //        [self initAVAudioSession];
        self.initAVAudioSession()
        
        bgURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background", ofType: "m4a")!)!
        bgPlayer = AVAudioPlayer(contentsOfURL: bgURL, error: nil)
        
        wasInterrupted = false
        
        // Initialize our OpenAL environment
        self.initOpenAL()
        
    }
    
    func checkForMusic() {
        if iPodIsPlaying {
            //the iPod is playing, so we should disable the background music switch
            NSLog("Disabling background music, iPod is active")
            musicSwitch.enabled = false
        } else {
            musicSwitch.enabled = true
        }
    }
    
    deinit {
        self.teardownOpenAL()
    }
    
    //MARK: AVAudioPlayer
    
    @IBAction func toggleMusic(sender: UISwitch) {
        NSLog("toggling music %@", sender.on ? "on" : "off")
        
        if bgPlayer != nil {
            
            if sender.on {
                bgPlayer?.play()
            } else {
                bgPlayer?.stop()
            }
        }
    }
    
    //MARK: OpenAL
    
    private func initBuffer() {
        var format: ALenum = 0
        var size: ALsizei = 0
        var freq: ALsizei = 0
        
        let bundle = NSBundle.mainBundle()
        
        // get some audio data from a wave file
        let fileURL = NSURL(fileURLWithPath: bundle.pathForResource("sound", ofType: "caf")!)
        
        if fileURL != nil {
            data = MyGetOpenALAudioData(fileURL!, &size, &format, &freq)
            
            var error = alGetError()
            if error != AL_NO_ERROR {
                fatalError("error loading sound: \(error)\n")
            }
            
            // use the static buffer data API
            alBufferData(buffer, format, data, size, freq)
            MyFreeOpenALAudioData(data, size)
            
            error = alGetError()
            if error != AL_NO_ERROR {
                NSLog("error attaching audio to buffer: \(error)\n")
            }
        } else {
            NSLog("Could not find file!\n")
        }
    }
    
    private func initSource() {
        var error: ALenum = AL_NO_ERROR
        alGetError() // Clear the error
        
        // Turn Looping ON
        alSourcei(source, AL_LOOPING, AL_TRUE)
        
        // Set Source Position
        let sourcePosAL: [Float] = [Float(sourcePos.x), kDefaultDistance, Float(sourcePos.y)]
        alSourcefv(source, AL_POSITION, sourcePosAL)
        
        // Set Source Reference Distance
        alSourcef(source, AL_REFERENCE_DISTANCE, 50.0)
        
        // attach OpenAL Buffer to OpenAL Source
        alSourcei(source, AL_BUFFER, ALint(buffer))
        
        error = alGetError()
        if error != AL_NO_ERROR {
            fatalError("Error attaching buffer to source: \(error)\n")
        }
    }
    
    
    func initOpenAL() {
        var error: ALenum = AL_NO_ERROR
        
        // Create a new OpenAL Device
        // Pass NULL to specify the system’s default output device
        device = alcOpenDevice(nil)
        if device != nil {
            // Create a new OpenAL Context
            // The new context will render to the OpenAL Device just created
            context = alcCreateContext(device, nil)
            if context != nil {
                // Make the new context the Current OpenAL Context
                alcMakeContextCurrent(context)
                
                // Create some OpenAL Buffer Objects
                alGenBuffers(1, &buffer)
                error = alGetError()
                if error != AL_NO_ERROR {
                    fatalError("Error Generating Buffers: \(error)")
                }
                
                // Create some OpenAL Source Objects
                alGenSources(1, &source)
                if alGetError() != AL_NO_ERROR {
                    fatalError("Error generating sources! \(error)\n")
                }
                
            }
        }
        // clear any errors
        alGetError()
        
        self.initBuffer()
        self.initSource()
    }
    
    func teardownOpenAL() {
        // Delete the Sources
        alDeleteSources(1, &source)
        // Delete the Buffers
        alDeleteBuffers(1, &buffer)
        
        //Release context
        alcDestroyContext(context)
        //Close device
        alcCloseDevice(device)
    }
    
    //MARK: Play / Pause
    
    func startSound() {
        var error: ALenum = AL_NO_ERROR
        
        NSLog("Start!\n")
        // Begin playing our source file
        alSourcePlay(source)
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error starting source: %x\n", error)
        } else {
            // Mark our state as playing (the view looks at this)
            self.isPlaying = true
        }
    }
    
    func stopSound() {
        var error: ALenum = AL_NO_ERROR
        
        NSLog("Stop!!\n")
        // Stop playing our source file
        alSourceStop(source)
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error stopping source: %x\n", error)
        } else {
            // Mark our state as not playing (the view looks at this)
            self.isPlaying = false
        }
    }
    
    //MARK: Setters / Getters
    
    // The coordinates of the sound source
    private var _sourcePos: CGPoint = CGPoint()
    dynamic var sourcePos: CGPoint {
        get {
            return self._sourcePos
        }
        
        set(SOURCEPOS) {
            self._sourcePos = SOURCEPOS
            let sourcePosAL: [Float] = [Float(self._sourcePos.x), kDefaultDistance, Float(self._sourcePos.y)]
            // Move our audio source coordinates
            alSourcefv(source, AL_POSITION, sourcePosAL)
        }
    }
    
    
    
    // The coordinates of the listener
    private var _listenerPos: CGPoint = CGPoint()
    dynamic var listenerPos: CGPoint {
        get {
            return self._listenerPos
        }
        
        set(LISTENERPOS) {
            self._listenerPos = LISTENERPOS
            let listenerPosAL: [Float] = [Float(self._listenerPos.x), 0.0, Float(self._listenerPos.y)]
            // Move our listener coordinates
            alListenerfv(AL_POSITION, listenerPosAL)
        }
    }
    
    
    
    // The rotation angle of the listener in radians
    private var _listenerRotation: CGFloat = 0
    dynamic var listenerRotation: CGFloat {
        get {
            return self._listenerRotation
        }
        
        set(radians) {
            self._listenerRotation = radians
            let ori: [Float] = [Float(cos(radians + M_PI_2.g)), Float(sin(radians + M_PI_2.g)), 0.0, 0.0, 0.0, 1.0]
            
            // Set our listener orientation (rotation)
            alListenerfv(AL_ORIENTATION, ori)
        }
    }
    
}