//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Felipe Valdivia on 10/9/17.
//  Copyright © 2017 Felipe Valdivia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
        
    }
    
    // MARK: Function to enable and unable buttons
    
    func settingLabelsAndButtons(isRecording: Bool){
            recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
            stopRecordingButton.isEnabled = isRecording
            recordButton.isEnabled = !isRecording
    }

    // MARK: recordAudio Function
    
    @IBAction func recordAudio(_ sender: Any) {
        settingLabelsAndButtons(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stop recording function

    @IBAction func stopRecording(_ sender: Any) {
        settingLabelsAndButtons(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "stopRecording" {
            let playSoundsVc = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVc.recordedAudioURL = recordedAudioURL
        }
    }
}

