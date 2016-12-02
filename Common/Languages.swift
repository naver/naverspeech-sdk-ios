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

import Foundation
import NaverSpeech


open class Languages {
    
    public init() {
        languages = [.korean: "Korean", .japanese: "Japanese", .english: "English", .simplifiedChinese: "Simplified Chinese"]
    }
    
    // MARK: - public
    open var count: Int {
        return self.languages.count
    }
    open var selectedLanguageString: String {
        if let language = self.languages[self._selectedLanguage] {
            return language
        }
        return "Korean"
    }
    open var selectedLanguage: NSKRecognizerLanguageCode {
       return self._selectedLanguage
    }
    
    open func languageString(at index: Int) -> String {
        if let code = NSKRecognizerLanguageCode(rawValue: index),
            let string = self.languages[code] {
            return string
        }
        return "Korean"
    }
    
    open func selectLanguage(at index: Int) {
        if let language = NSKRecognizerLanguageCode(rawValue: index) {
            self._selectedLanguage = language
        }
    }

    // MARK: - private
    fileprivate let languages: [NSKRecognizerLanguageCode: String]
    fileprivate var _selectedLanguage: NSKRecognizerLanguageCode = .korean
    
}

