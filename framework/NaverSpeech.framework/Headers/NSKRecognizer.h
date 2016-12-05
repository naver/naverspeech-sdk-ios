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

#import <Foundation/Foundation.h>
#import "NSKType.h"
#import "NSKRecognizerConfiguration.h"
#import "NSKRecognizedResult.h"


@protocol NSKRecognizerDelegate;

/**
 NSKRecognizer는 네이버 음성인식 서비스를 사용할 수 있도록 client 역할을 제공합니다.
 네이버 음성인식은 server와 client간의 통신으로 구성되어 있고,
 client는 음성을 입력 받아 server로 전송하고, server로부터 인식 결과를 받는 역할을 합니다.
 따라서 network 연결과 앱에서 마이크에 대한 접근 허용이 필요합니다.
 음성인식 수행 과정은 아래의 state diagram과 같습니다.

 ![State diagram](https://github.com/naver/naverspeech-sdk-ios/blob/master/framework/NaverSpeech.framework/state_diagram.png "diagram")
 
 State가 바뀔 때 마다 NSKRecognizerDelegate protocol의 각 state에 해당하는 messege를 받습니다.
 */
@interface NSKRecognizer : NSObject


/**
 NSKRecognizerDelegate protocol을 구현한 delegate
 */
@property (nonatomic, weak) id <NSKRecognizerDelegate> delegate;


/**
 음성인식기의 동작 상태
 */
@property (nonatomic, readonly, getter=isRunning) BOOL running;


/**
 @param     aConfiguration      NSKRecognizerConfiguration 음성인식기 설정값
 @return    음성인식기 instance
 @see       NSKRecognizerConfiguration
 */
- (instancetype)initWithConfiguration:(NSKRecognizerConfiguration *)aConfiguration;

/**
 음성인식기를 동작시킵니다.
 해당 method가 호출되면 background로 audio 자원을 할당하고 network를 연결합니다.
 모든 준비가 완료되면 음성인식을 수행합니다.

 @param     aLanguageCode       NSKRecognizerLanguageCode 인식하고자 하는 언어
 @return    성공유무
 @see       NSKRecognizerLanguageCode
 */
- (BOOL)startWithLanguageCode:(NSKRecognizerLanguageCode)aLanguageCode;

/**
 음성인식기의 동작을 중지시킵니다.
 음성인식 서버로 부터 최종 결과를 받은 후 종료됩니다.
 네트워크 환경에 따라 최종 결과 수신 및 종료가 지연될 수 있습니다.

 @return 성공유무
 */
- (BOOL)stop;

/**
 음성인식기의 동작을 취소합니다.
 즉시 음성인식의 모든 동작을 정지시키며 결과를 받지 않습니다.
 @warning 취소에 대한 별도의 delegate method가 호출되지 않습니다.
 
 @return 성공유무
 */
- (BOOL)cancel;

/**
 음성인식기의 EPD(End Point Detection)Type을 선택할 수 있습니다.
 @warning 설정의 EPDType이 hybrid인 경우에만 정상동작 합니다.

 @return 성공유무
 */
- (BOOL)setEPDType:(NSKEPDType)aEPDType;


@end


#pragma mark -
/**
 음성인식기의 상태변화와 인식된 정보를 전달합니다.
 */
@protocol NSKRecognizerDelegate <NSObject>


@optional

/**
 음성인식 준비가 완료된 상태일 때 호출됩니다.
 
 @param     aRecognizer     음성인식기
 */
- (void)recognizerDidEnterReady:(NSKRecognizer *)aRecognizer;

/**
 음성발성이 종료되었을 때 호출됩니다.
 
 @param     aRecognizer     음성인식기
 */
- (void)recognizerDidDetectEndPoint:(NSKRecognizer *)aRecognizer;

/**
 음성인식이 완료된 상태일 때 호출됩니다.
 
 @param     aRecognizer     음성인식기
 */
- (void)recognizerDidEnterInactive:(NSKRecognizer *)aRecognizer;

/**
 음성입력을 받은 즉시 호출됩니다.
 
 @param     aRecognizer     음성인식기
 @param     aSpeechData     음성신호가 저장된 버퍼
 */
- (void)recognizer:(NSKRecognizer *)aRecognizer didRecordSpeechData:(NSData *)aSpeechData;

/**
 음성인식기 설정값 중 EPDType이 hybrid인 경우에만 호출 됩니다.
 1. `-setEPDType:`이 정상동작 한 경우
 2. 음성인식기 동작 후 600ms동안 EPDType이 선택되지 않은 경우(manual)
 
 @param     aRecognizer         음성인식기
 @param     aEPDType            결정된 EPD type(manual or auto)
 @see       -setEPDType:
 */
- (void)recognizer:(NSKRecognizer *)aRecognizer didSelectEndPointDetectType:(NSNumber *)aEPDType;

/**
 음성인식 중간 결과를 받으면 호출됩니다.
 음성인식 중간 결과는 없거나 여러번 있을 수 있습니다.
 
 @param     aRecognizer     음성인식기
 @param     aResult         음성인식 중간결과
 */
- (void)recognizer:(NSKRecognizer *)aRecognizer didReceivePartialResult:(NSString *)aResult;

/**
 음성인식 중 오류가 발생했을 때 호출됩니다.
 
 @param     aRecognizer     음성인식기
 @param     aError          음성인식 오류
 @see       NMSpeechErrors.h
 */
- (void)recognizer:(NSKRecognizer *)aRecognizer didReceiveError:(NSError *)aError;

@required

/**
 음성인식 최종 결과를 받으면 호출됩니다.
 음성인식 최종 결과는 5개의 인식된 string array와 화자의 gender정보로 이루어져 있습니다.
 
 @param     aRecognizer     음성인식기
 @param     aResult         음성인식 최종결과
 @see       NSKGender
 @see       NSKRecognizerResult
 */
- (void)recognizer:(NSKRecognizer *)aRecognizer didReceiveResult:(NSKRecognizedResult *)aResult;


@end
