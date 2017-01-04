/*
 * Copyright 2016 NAVER Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import NaverSpeech
import Common
import AVFoundation


/*네이버 개발자 센터(https://developers.naver.com)에서 앱 등록을 한 후 발급받은 client id가 필요합니다.*/
let ClientID = ""

/////////////////////////////////////////////////////////////////////
//음성인식기를 auto mode로 동작 시키는 sample app
/////////////////////////////////////////////////////////////////////
class AutoViewController: UIViewController {
    
    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        /*
         *  NSKRecognizer를 초기화 하는데 필요한 NSKRecognizerConfiguration을 생성합니다.
         *  configuration의 EPD(End Point Detection)type의 default값은 auto 이므로 여기에서 따로 값을 setting하지 않아도 됩니다.
         */
        let configuration = NSKRecognizerConfiguration(clientID: ClientID)
        configuration?.canQuestionDetected = true
        self.speechRecognizer = NSKRecognizer(configuration: configuration)
        super.init(coder: aDecoder)
        
        self.speechRecognizer.delegate = self
    }
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLanguagePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let x = languagePickerButton.frame.minX
        let y = languagePickerButton.frame.maxY
        self.pickerView.frame = CGRect.init(x: x, y: y, width: languagePickerButton.bounds.size.width, height: self.pickerView.bounds.size.height)
    }

    // MARK: - action
    @IBAction func languagePickerButtonTapped(_ sender: Any) {
        self.pickerView.isHidden = false
    }
   
    /*
     * Auto mode는 화자의 발화가 일정시간 이상 지속되지 않으면 자동으로 끝점을 인식하여 음성인식이 종료됩니다.
     * 이 sample app에서는 button으로 음성인식을 시작하고 끝내게 됩니다. 
     * 인식기가 동작 중일 때 button에 대한 tap action이 들어오면 인식기를 중지 시킵니다.
     * 인식기가 동작 중이지 않을 때 button에 대한 tap action이 들어오면 인식기에 언어 코드를 넣어서 인식기를 시작시킵니다.
     */
    @IBAction func recognitionButtonTapped(_ sender: Any) {
        if self.speechRecognizer.isRunning {
            self.speechRecognizer.stop()
        } else {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            self.speechRecognizer.start(with: self.languages.selectedLanguage)
            self.recognitionButton.isEnabled = false
            self.statusLabel.text = "Connecting......"
        }
    }
    
    // MARK: - property
    @IBOutlet weak var languagePickerButton: UIButton!
    @IBOutlet weak var recognitionResultLabel: UILabel!
    @IBOutlet weak var recognitionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    fileprivate let speechRecognizer: NSKRecognizer
    fileprivate let languages = Languages()
    fileprivate let pickerView = UIPickerView()
}

/*
 * NSKRecognizerDelegate protocol 구현부
 */
extension AutoViewController: NSKRecognizerDelegate {
    
    public func recognizerDidEnterReady(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: Ready")
        
        self.statusLabel.text = "Connected"
        self.recognitionResultLabel.text = "Recognizing......"
        self.setRecognitionButtonTitle(withText: "Stop", color: .red)
        self.recognitionButton.isEnabled = true
    }
    
    public func recognizerDidDetectEndPoint(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: End point detected")
    }
    
    public func recognizerDidEnterInactive(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: Inactive")
        
        self.setRecognitionButtonTitle(withText: "Record", color: .blue)
        self.recognitionButton.isEnabled = true
        self.statusLabel.text = ""
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
    }
    
    public func recognizer(_ aRecognizer: NSKRecognizer!, didRecordSpeechData aSpeechData: Data!) {
        print("Record speech data, data size: \(aSpeechData.count)")

    }
    
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceivePartialResult aResult: String!) {
        print("Partial result: \(aResult)")

        self.recognitionResultLabel.text = aResult
    }
    
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceiveError aError: Error!) {
        print("Error: \(aError)")

        self.setRecognitionButtonTitle(withText: "Record", color: .blue)
        self.recognitionButton.isEnabled = true
    }
    
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceive aResult: NSKRecognizedResult!) {
        print("Final result: \(aResult)")
        
        if let result = aResult.results.first as? String {
            self.recognitionResultLabel.text = "Result: " + result
        }
    }
}


extension AutoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages.languageString(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languages.selectLanguage(at: row)
        languagePickerButton.setTitle(languages.selectedLanguageString, for: .normal)
        self.pickerView.isHidden = true
        
        /*
         * 음성인식 중 언어를 변경하게 되면 음성인식을 즉시 중지(cancel()) 합니다.
         * 음성인식이 즉시 중지되면 별도의 delegate method가 호출되지 않습니다.
         */
        if self.speechRecognizer.isRunning {
            self.speechRecognizer.cancel()
            self.recognitionResultLabel.text = "Canceled"
            self.setRecognitionButtonTitle(withText: "Record", color: .blue)
            self.recognitionButton.isEnabled = true
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        }
    }
}


fileprivate extension AutoViewController {
    func setupLanguagePicker() {
        self.view.addSubview(self.pickerView)
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.isHidden = true
    }
    
    func setRecognitionButtonTitle(withText text: String, color: UIColor) {
        self.recognitionButton.setTitle(text, for: .normal)
        self.recognitionButton.setTitleColor(color, for: .normal)
    }
}

