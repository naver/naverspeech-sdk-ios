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
 음성인식 최종 결과 
 음성인식 최종 결과는 string array와 화자의 gender정보로 이루어져 있습니다.
 */
@interface NSKRecognizedResult : NSObject


/**
 음성인식 결과 string array
 신뢰도가 높은 순으로 5개가 포함되어 있습니다.
 */
@property (nonatomic, readonly) NSArray  *results;

/**
 음성인식 최종 결과 화자 gender 정보
 
 - NSKMale: 남성
 - NSKFemale: 여성
 */
@property (nonatomic, readonly) NSKGender gender;


@end
