//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Formative Mini on 4/8/18.
//  Copyright © 2018 Formative Web Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = "Recording in Progress"
        recordButton.isEnabled = false
        stopRecording.isEnabled = true
        
        if let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first {
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]

            if let filePath = URL(string: pathArray.joined(separator: "/")) {
                let session = AVAudioSession.sharedInstance()
                try? session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
                
                try? audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            }
            
        }
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        stopRecording.isEnabled = false
        recordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording",
            let playSoundsVC = segue.destination as? PlaySoundsViewController,
            let recordedAudioURL = sender as? URL {
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else {
            print("recording was not successful")
            return
        }
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
}

