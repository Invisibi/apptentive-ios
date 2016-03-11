//
//  ATEngagementManifestParser.m
//  ApptentiveConnect
//
//  Created by Peter Kamb on 8/20/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import "ATEngagementManifestParser.h"
#import "ATJSONSerialization.h"
#import "ATEngagementBackend.h"
#import "ATInteraction.h"
#import "ATInteractionInvocation.h"


@implementation ATEngagementManifestParser {
	NSError *parserError;
}

- (NSDictionary *)targetsAndInteractionsForEngagementManifest:(NSData *)jsonManifest {
	NSMutableDictionary *targets = [NSMutableDictionary dictionary];
	NSMutableDictionary *interactions = [NSMutableDictionary dictionary];

	BOOL success = NO;

	@autoreleasepool {
		@try {
			NSError *error = nil;

			id decodedObject = [ATJSONSerialization JSONObjectWithData:jsonManifest error:&error];
			if (decodedObject && [decodedObject isKindOfClass:[NSDictionary class]]) {
				NSDictionary *jsonDictionary = (NSDictionary *)decodedObject;

				// Targets
				NSDictionary *targetsDictionary = jsonDictionary[@"targets"];
				for (NSString *event in [targetsDictionary allKeys]) {
					NSArray *invocationsJSONArray = targetsDictionary[event];
					NSArray *invocationsArray = [ATInteractionInvocation invocationsWithJSONArray:invocationsJSONArray];
					[targets setObject:invocationsArray forKey:event];
				}

				// Interactions
				NSArray *interactionsArray = jsonDictionary[@"interactions"];
				for (NSDictionary *interactionDictionary in interactionsArray) {
					ATInteraction *interactionObject = [ATInteraction interactionWithJSONDictionary:interactionDictionary];
					[interactions setObject:interactionObject forKey:interactionObject.identifier];
				}

				success = YES;
			} else {
				parserError = nil;
				parserError = error;
				success = NO;
			}
		}
		@catch (NSException *exception) {
			ATLogError(@"Exception parsing engagement manifest: %@", exception);
			success = NO;
		}
	}

	NSDictionary *targetsAndInteractions = nil;
	if (success) {
#if APPTENTIVE_DEBUG
		targetsAndInteractions = @{ @"targets": targets,
			@"interactions": interactions,
			@"raw": jsonManifest };
#else
		targetsAndInteractions = @{ @"targets": targets,
			@"interactions": interactions };
#endif
	}

	return targetsAndInteractions;
}

- (NSError *)parserError {
	return parserError;
}
@end
