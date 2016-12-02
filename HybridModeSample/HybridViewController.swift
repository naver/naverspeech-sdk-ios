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

/*네이버 개발자 센터(https://developers.naver.com)에서 앱 등록을 한 후 발급받은 client id가 필요합니다.*/
let ClientID = ""

/////////////////////////////////////////////////////////////////////
//음성인식기를 hybrid mode로 동작 시키는 sample app
/////////////////////////////////////////////////////////////////////
class HybridViewController: UIViewController {
    
    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        /*
         *  NSKRecognizer를 초기화 하는데 필요한 NSKRecognizerConfiguration을 생성합니다.
         */
        let configuration = NSKRecognizerConfiguration(clientID: ClientID)
        configuration?.canQuestionDetected = true
        configuration?.epdType = .hybrid
        self.speechRecognizer = NSKRecognizer(configuration: configuration)
        
        super.init(coder: aDecoder)
        
        self.speechRecognizer.delegate = self
    }

    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLanguagePicker()
        self.setupRecognitionButton()
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
        self.pickerView.frame = CGRect(x: x, y: y, width: languagePickerButton.bounds.size.width, height: self.pickerView.bounds.size.height)
    }
    
    // MARK: - action
    @IBAction func languagePickerButtonTapped(_ sender: Any) {
        self.pickerView.isHidden = false
    }
    
    /*
     * Hybrid mode에서는 auto mode나 manual mode를 모두 사용할 수 있습니다.
     * 이 sample app에서는 button으로 음성인식을 시작하고 끝내게 됩니다.
     * setupRecognitionButton()을 보면 button에 UILongPressGestureRecognizer를 등록하고,
     * 이때 minimumPressDuration을 0으로 setting하여 tap동작과 long press동작을 구분 할 수 있도록 하였습니다.
     * hybrid mode에서는 서버에서 현재 음성인식의 EPD(End Point Detection)type이 auto인지 manual인지 delegate method형태로 알려주기 때문에
     * epd type을 받을 수 있는 변수를 선언해 두었습니다.
     * 
     * 1. UILongPressGestureRecognizer의 state가 began일때, 
     *   - 음성인식기가 동작중이 아니라면 음성인식기를 동작시킵니다. 이때 epd type을 받을 변수에 현재 epd type인 hybrid를 넣습니다.
     *   - 음성인식기가 동작중이고 epd type 변수의 값이 auto라면 음성인식기를 중지 시킵니다.
     *
     * 2. UILongPressGestureRecognizer의 state가 ended일때,
     *   - epd type 변수의 값이 초기 설정 그대로 hybrid라면 long press가 아닌 tap동작을 한 것 입니다.
     *     그러므로 setEPDType(.auto)를 호출하여, auto mode로 동작 시킵니다.
     *   - epd type 변수의 값이 manual이라면 이는 long press 동작으로 서버에서 delegate method을 통해 epd type이 manual임을 알려준 상태입니다.
     *     그러므로 이때는 음성인식을 중지 시킵니다.
     */
    @IBAction func recognitionButtonPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if self.speechRecognizer.isRunning == false {
                self.epdType = .hybrid
                self.speechRecognizer.start(with: self.languages.selectedLanguage)
                self.statusLabel.text = "Connecting........"
                
            } else if self.epdType == .auto {
                self.speechRecognizer.stop()
                
            }
            
        } else if sender.state == .ended {
            if self.epdType == .hybrid {
                self.speechRecognizer.setEPDType(.auto)
            } else if self.epdType == .manual {
                self.speechRecognizer.stop()
            }
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
    fileprivate var epdType: NSKEPDType = .none
}

/*
 * NSKRecognizerDelegate protocol 구현부
 */
extension HybridViewController: NSKRecognizerDelegate {
    
    public func recognizerDidEnterReady(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: Ready")
        
        self.statusLabel.text = "Connected"
        self.recognitionResultLabel.text = "Recognizing......"
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
    }
    
    public func recognizer(_ aRecognizer: NSKRecognizer!, didRecordSpeechData aSpeechData: Data!) {
        print("Record speech data, data size: \(aSpeechData.count)")
        
    }
    
    /*
     * 해당 delegation method는 configuration의 epd type이 hybrid로 설정되었을 경우에만 호출 됩니다.
     * 약 600ms 동안 setEPDType(.auto)가 호출되지 않으면 서버에서는 manual mode로 동작되었음을 인식하고
     * epd type으로 manual에 해당하는 값을 보내 줍니다. 
     */
    public func recognizer(_ aRecognizer: NSKRecognizer!, didSelectEndPointDetectType aEPDType: NSNumber!) {
        
        if let type = NSKEPDType(rawValue: aEPDType.intValue) {
            self.epdType = type
        }
        
        let title = (self.epdType == .manual) ? "Recognizing" : "Stop"
        self.setRecognitionButtonTitle(withText: title, color: .red)
        
        print("End point type: \((self.epdType == .auto) ? "Auto" : "Manual")")
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


extension HybridViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        }
    }
}


fileprivate extension HybridViewController {
    
    func setupLanguagePicker() {
        self.view.addSubview(self.pickerView)
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.isHidden = true
    }
    
    func setupRecognitionButton() {
        let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recognitionButtonPressed(_:)))
        longpressRecognizer.minimumPressDuration = 0
        self.recognitionButton.addGestureRecognizer(longpressRecognizer)
    }
    
    func setRecognitionButtonTitle(withText text: String, color: UIColor) {
        self.recognitionButton.setTitle(text, for: .normal)
        self.recognitionButton.setTitleColor(color, for: .normal)
    }
}


