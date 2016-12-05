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

#ifndef NMSpeechErrors_h
#define NMSpeechErrors_h


/**
 음성인식기 Error
 */
typedef NS_ENUM(NSInteger, NMSpeechRecognizerError)
{
    
    /// - NMSpeechErrorNetworkInitialize: Network 자원 초기화 오류
    NMSpeechErrorNetworkInitialize = 10,
    /// - NMSpeechErrorNetworkFinalize: Network 자원 해제 오류
    NMSpeechErrorNetworkFinalize = 11,
    /// - NMSpeechErrorNetworkRead: Network data 수신 오류
    NMSpeechErrorNetworkRead = 12,
    /// - NMSpeechErrorNetworkWrite: Network data 전송 오류
    NMSpeechErrorNetworkWrite = 13,
    /// - NMSpeechErrorNetworkNACK: 인식 server 오류
    NMSpeechErrorNetworkNACK = 14,
    /// - NMSpeechErrorPacket: 전송/수신 packet오류
    NMSpeechErrorPacket = 15,
    
    ///- NMSpeechErrorAudioInitialize: Audio 자원 초기화 오류
    NMSpeechErrorAudioInitialize = 20,
    /// - NMSpeechErrorAudioFinalize: Audio 자원 해제 오류
    NMSpeechErrorAudioFinalize = 21,
    /// - NMSpeechErrorAudioRecord: 음성 입력(녹음) 오류
    NMSpeechErrorAudioRecord = 22,

    /// - NMSpeechErrorSecurity: 인증 권한 오류
    NMSpeechErrorSecurity = 30,

    /// - NMSpeechErrorNoResult: 인식 결과 오류
    NMSpeechErrorNoResult = 40,
    /// - NMSpeechErrorTimeout: 일정 시간 이상 인식 server로 음성을 전송하지 못하거나, 인식 결과를 받지 못하였음
    NMSpeechErrorTimeout = 41,
    /// - NMSpeechErrorNULLClient: Client가 음성인식을 수행하고 있지 않는 상황에서, 특정 음성인식 관련 event가 감지되었음
    NMSpeechErrorNULLClient = 42,

    /// - NMSpeechErrorUnknownEvent: Client 내부에 규정되어 있지 않은 event가 감지되었음
    NMSpeechErrorUnknownEvent = 50,

    /// - NMSpeechErrorVersion: Protocol version 오류
    NMSpeechErrorVersion = 60,
    /// - NMSpeechErrorClientInfo: Client property 오류
    NMSpeechErrorClientInfo = 61,
    /// - NMSpeechErrorServerPool: 음성인식 server pool 부족
    NMSpeechErrorServerPool = 62,
    /// - NMSpeechErrorSessionExpired: 음성인식 server session 만료
    NMSpeechErrorSessionExpired = 63,
    /// - NMSpeechErrorSpeechSizeExceeded: 음성 packet 사이즈 초과
    NMSpeechErrorSpeechSizeExceeded = 64,
    /// - NMSpeechErrorExceedTimeLimit: 인증 time stamp 불량
    NMSpeechErrorExceedTimeLimit = 65,
    /// - NMSpeechErrorWrongServiceCode: 올바른 service code가 아님
    NMSpeechErrorWrongServiceCode = 66,
    /// - NMSpeechErrorWrongLanguageCode: 올바른 language code가 아님
    NMSpeechErrorWrongLanguageCode = 67,

    /// - NMSpeechErrorOpenAPIAuth: OpenAPI 인증 에러(Client ID또는 bundle id가 개발자센터에 등록한 값과 다름)
    NMSpeechErrorOpenAPIAuth = 70,
    /// - NMSpeechErrorQuotaOverflow: 정해진 Quota를 다 소진함
    NMSpeechErrorQuotaOverflow = 71
};


/**
 음성인식 sdk Error
 */
typedef NS_ENUM(NSInteger, NMSpeechSDKError)
{
    /// - NMSpeechSDKErrorNone: none
    NMSpeechSDKErrorNone = 0,

    /// - NMSpeechSDKErrorInvalidClientID: client ID가 유효하지 않음
    NMSpeechSDKErrorInvalidClientID = 10,
    /// - NMSpeechSDKErrorInvalidVersion: library version이 유효하지 않음
    NMSpeechSDKErrorInvalidVersion = 11,
    /// - NMSpeechSDKErrorInvalidDevice: device type이 유효하지 않음
    NMSpeechSDKErrorInvalidDevice = 12,
    /// - NMSpeechSDKErrorInvalidOS: OS version이 유효하지 않음
    NMSpeechSDKErrorInvalidOS = 13,
    /// - NMSpeechSDKErrorInvalidServiceCode: service code가 유효하지 않음
    NMSpeechSDKErrorInvalidServiceCode = 14,
    /// - NMSpeechSDKErrorInvalidLanguageCode: language code가 유효하지 않음
    NMSpeechSDKErrorInvalidLanguageCode = 15,
    /// - NMSpeechSDKErrorVersionTooLong: library version string이 유효범위를 벗어남
    NMSpeechSDKErrorVersionTooLong = 16,
    /// - NMSpeechSDKErrorBundleIdentifierTooLong: bundle identifier가 유효범위를 벗어남
    NMSpeechSDKErrorBundleIdentifierTooLong = 17,
    /// - NMSpeechSDKErrorInvalidRecognitionCode: recognition code가 유효하지 않음
    NMSpeechSDKErrorInvalidRecognitionCode = 18,
    
    /// - NMSpeechSDKErrorAlreadyRunning: 음성인식기가 이미 동작 중
    NMSpeechSDKErrorAlreadyRunning = 20
};


#endif /* NMSpeechErrors_h */
