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


/**
 음성인식기 설정
 설정에서는 EPD(End Point Detection)Type과 의문문 인식 가능여부를 선택할 수 있습니다.
 */
@interface NSKRecognizerConfiguration : NSObject


/**
 client library version
 */
@property (nonatomic, readonly) NSString *version;

/**
 iPhone device type
 */
@property (nonatomic, readonly) NSString *device;

/**
 system name, system version e.g @"iOS 8.0"
 */
@property (nonatomic, readonly) NSString *osVersion;

/**
 client id
 */
@property (nonatomic, readonly) NSString *clientID;

/**
 mainBundle의 bundle id
 */
@property (nonatomic, readonly) NSString *bundleIdentifier;

/**
 음성인식시 의문문 인식 가능여부 선택
 default는 false
 */
@property (nonatomic, getter=canQuestionDetected) BOOL       questionDetected;

/**
 EPD(End Point Detection)type 선택
 default는 Auto
 */
@property (nonatomic)                             NSKEPDType epdType;

/**
 네이버 개발자 센터(https://developers.naver.com)에서 앱 등록을 한 후 발급받은 client id가 필요합니다.
 
 @param     aClientID       Client id
 @return    NSKRecognizerConfiguration instance
 */
- (instancetype)initWithClientID:(NSString *)aClientID;


@end
