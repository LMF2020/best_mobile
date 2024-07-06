//
//  SampleHandler.swift
//  ScreenShare
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler, MobileRTCScreenShareServiceDelegate {

    var screenShareService: MobileRTCScreenShareService?
    override init() {
        super.init()
        screenShareService = MobileRTCScreenShareService()
        screenShareService?.appGroup = "group.com.bestMobile.meeting"
        screenShareService?.delegate = self
    }
    
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional. 
        screenShareService?.broadcastStarted(withSetupInfo: setupInfo)
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        screenShareService?.broadcastPaused()
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        screenShareService?.broadcastResumed()
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        screenShareService?.broadcastFinished()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
//        switch sampleBufferType {
//        case RPSampleBufferType.video:
//            // Handle video sample buffer
//            break
//        case RPSampleBufferType.audioApp:
//            // Handle audio sample buffer for app audio
//            break
//        case RPSampleBufferType.audioMic:
//            // Handle audio sample buffer for mic audio
//            break
//        @unknown default:
//            // Handle other sample buffer types
//            fatalError("Unknown type of sample buffer")
//        }
        screenShareService?.processSampleBuffer(sampleBuffer, with: sampleBufferType)
    }
    
    func mobileRTCScreenShareServiceFinishBroadcastWithError(_ error: Error!) {
        finishBroadcastWithError(error)
    }
}
