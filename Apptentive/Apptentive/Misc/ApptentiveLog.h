//
//  ApptentiveLog.h
//  Apptentive
//
//  Created by Alex Lementuev on 3/29/17.
//  Copyright (c) 2017 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apptentive.h"
#import "ApptentiveLogTag.h"

NS_ASSUME_NONNULL_BEGIN

#define ApptentiveLogTagConversation [ApptentiveLogTag conversationTag]
#define ApptentiveLogTagNetwork [ApptentiveLogTag networkTag]
#define ApptentiveLogTagPayload [ApptentiveLogTag payloadTag]
#define ApptentiveLogTagUtility [ApptentiveLogTag utilityTag]
#define ApptentiveLogTagStorage [ApptentiveLogTag storageTag]

extern ApptentiveLogLevel ApptentiveLogGetLevel(void);
extern void ApptentiveLogSetLevel(ApptentiveLogLevel level);
extern BOOL ApptentiveCanLogLevel(ApptentiveLogLevel level);

void ApptentiveLogCrit(id arg, ...);
void ApptentiveLogError(id arg, ...);
void ApptentiveLogWarning(id arg, ...);
void ApptentiveLogInfo(id arg, ...);
void ApptentiveLogDebug(id arg, ...);
void ApptentiveLogVerbose(id arg, ...);

NS_ASSUME_NONNULL_END
