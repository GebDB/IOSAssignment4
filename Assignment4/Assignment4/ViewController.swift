//
//  ViewController.swift
//  Assignment4
//
//  Created by user940256 on 1/30/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var TimePicker: UIDatePicker!
    @IBOutlet weak var DateAndTime: UILabel!
    @IBOutlet weak var TimeRemaining: UILabel!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    var timeLeft: Int?
    var timer = Timer()
    
    var notification: AVAudioPlayer?
    
    // Instantiate button title and update background and date/time.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        StartButton.setTitle("Start", for: .normal)
        updateDateAndTime()
        updateBackgroundImage()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDateAndTime), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBackgroundImage), userInfo: nil, repeats: true)
    }

    // Set timeLeft through CountDown DatePicker
    @IBAction func TimerSetter(_ sender: UIDatePicker) {
        timeLeft = Int(sender.countDownDuration)
        
        if let timeLeft = timeLeft, timeLeft > 0 {
            TimeRemaining.text = "Time Remaining: \(formatTime(timeLeft))"
        } else {
            TimeRemaining.text = "Time Remaining: 00:00:00"
        }
    }
    
    // Instantiate timer or stop music when button is pressed.
    @IBAction func startTimer(_ sender: UIButton) {
        if notification?.isPlaying == true {
            notification?.stop()
            StartButton.setTitle("Start", for: .normal)
            return
        }
        if timeLeft == nil || timeLeft! <= 0 {
            TimeRemaining.text = "Time Remaining: 00:00:00"
            return
        }

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
    }
    
    // Countdown the timer and play a sound at the end
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            TimeRemaining.text = "Time Remaining: \(formatTime(timeLeft!))"
            timeLeft! -= 1
        } else {
            timer.invalidate()
            playSound()
            StartButton.setTitle("Stop Music", for: .normal)
        }
    }
    
    // Change background and colors based on day/night time
    @objc func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 6 && hour < 18 {
            background.image = UIImage(named: "day")
            TimeRemaining.setValue(UIColor.black, forKey: "textColor")
            DateAndTime.setValue(UIColor.black, forKey: "textColor")
            TimePicker.backgroundColor = .white
            TimePicker.setValue(UIColor.black, forKey: "textColor")
            StartButton.setTitleColor(UIColor.black, for: .normal)
            StartButton.layer.borderColor = UIColor.black.cgColor
            StartButton.layer.borderWidth = 2.0
        } else {
            background.image = UIImage(named: "night")
            TimeRemaining.setValue(UIColor.white, forKey: "textColor")
            DateAndTime.setValue(UIColor.white, forKey: "textColor")
            TimePicker.backgroundColor = .black
            TimePicker.setValue(UIColor.white, forKey: "textColor")
            StartButton.setTitleColor(UIColor.white, for: .normal)
            StartButton.layer.borderColor = UIColor.white.cgColor
            StartButton.layer.borderWidth = 2.0
        }
    }
    
    // Format time to a Hours/Minutes/Seconds format.
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    // Format date and time.
    @objc func updateDateAndTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy, HH:mm:ss"
        DateAndTime.text = formatter.string(from: Date())
    }
    
    // Plays a sound, do/catch for testing without audio.
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            do {
                notification = try AVAudioPlayer(contentsOf: soundURL)
                notification?.play()
            } catch {
                print("Error playing sound")
            }
        } else {
            print("file not found")
        }
    }
}

