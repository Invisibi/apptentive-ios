//
//  ApptentiveLog.m
//  Apptentive
//
//  Created by Alex Lementuev on 3/29/17.
//  Copyright © 2017 Apptentive, Inc. All rights reserved.
//

#import "ApptentiveLog.h"

NS_ASSUME_NONNULL_BEGIN

static ApptentiveLogLevel _logLevel = ApptentiveLogLevelInfo;

static const char * _Nonnull _logLevelNameLookup[] = {
	"C", // ApptentiveLogLevelCrit,
	"E", // ApptentiveLogLevelError,
	"W", // ApptentiveLogLevelWarn,
	"I", // ApptentiveLogLevelInfo,
	"D", // ApptentiveLogLevelDebug,
	"V", // ApptentiveLogLevelVerbose
};

#pragma mark -
#pragma mark Helper Functions

inline static BOOL shouldLogLevel(ApptentiveLogLevel logLevel) {
	return logLevel <= _logLevel;
}

static NSString *getCurrentThreadName() {
	if ([NSThread currentThread].isMainThread) {
		return nil;
	}

	NSString *threadName = [NSThread currentThread].name;
	if (threadName.length > 0) {
		return threadName;
	}

	NSOperationQueue *currentOperationQueue = [NSOperationQueue currentQueue];
	if (currentOperationQueue != nil) {
		return currentOperationQueue.name;
	}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

	dispatch_queue_t currentDispatchQueue = dispatch_get_current_queue();
	if (currentDispatchQueue != NULL) {
		if (currentDispatchQueue == dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			return @"QUEUE_DEFAULT";
		}
		if (currentDispatchQueue == dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			return @"QUEUE_HIGH";
		}
		if (currentDispatchQueue == dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
			return @"QUEUE_LOW";
		}
		if (currentDispatchQueue == dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
			return @"QUEUE_BACKGROUND";
		}

		const char *label = dispatch_queue_get_label(currentDispatchQueue);
		return label != NULL ? [NSString stringWithFormat:@"%s", label] : @"Serial queue";
	}

#pragma clang diagnostic pop

	return @"Background Thread";
}

#pragma mark -
#pragma mark Log Functions

static void _ApptentiveLogHelper(ApptentiveLogLevel level, id arg, va_list ap) {
	ApptentiveLogTag *tag = [arg isKindOfClass:[ApptentiveLogTag class]] ? arg : nil;
	if (shouldLogLevel(level) && (tag == nil || tag.enabled)) {
		if (tag != nil) {
			arg = va_arg(ap, ApptentiveLogTag *);
		}

		NSString *format = arg;
		NSString *threadName = getCurrentThreadName();
		NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];

		NSMutableString *fullMessage = [[NSMutableString alloc] initWithFormat:@"%s/Apptentive: ", _logLevelNameLookup[level]];
		if (threadName != nil) {
			[fullMessage appendFormat:@"[%@] ", threadName];
		}
		if (tag != nil) {
			[fullMessage appendFormat:@"[%@] ", tag.name];
		}
		[fullMessage appendString:message];

		NSLog(@"%@", fullMessage);
	}
}

void ApptentiveLogCrit(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelCrit, arg, ap);
	va_end(ap);
}

void ApptentiveLogError(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelError, arg, ap);
	va_end(ap);
}

void ApptentiveLogWarning(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelWarn, arg, ap);
	va_end(ap);
}

void ApptentiveLogInfo(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelInfo, arg, ap);
	va_end(ap);
}

void ApptentiveLogDebug(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelDebug, arg, ap);
	va_end(ap);
}

void ApptentiveLogVerbose(id arg, ...) {
	va_list ap;
	va_start(ap, arg);
	_ApptentiveLogHelper(ApptentiveLogLevelVerbose, arg, ap);
	va_end(ap);
}


ApptentiveLogLevel ApptentiveLogGetLevel(void) {
	return _logLevel;
}

void ApptentiveLogSetLevel(ApptentiveLogLevel level) {
	_logLevel = level;
}

BOOL ApptentiveCanLogLevel(ApptentiveLogLevel level) {
	return shouldLogLevel(level);
}

NS_ASSUME_NONNULL_END
