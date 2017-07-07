//
//  ApptentiveSafeCollections.h
//  Apptentive
//
//  Created by Alex Lementuev on 3/20/17.
//  Copyright © 2017 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Safely adds key and value into the dictionary
 */
void ApptentiveDictionarySetKeyValue(NSMutableDictionary *dictionary, NSString *key, id value);

/**
 Tries to add nullable value into the dictionary
 */
BOOL ApptentiveDictionaryTrySetKeyValue(NSMutableDictionary *dictionary, NSString *key, id value);

/**
 Safely retrieves string from a dictionary (or returns nil if failed)
 */
NSString *ApptentiveDictionaryGetString(NSDictionary *dictionary, NSString *key);

/**
 Safely retrieves array from a dictionary (or returns nil if failed)
 */
NSArray *ApptentiveDictionaryGetArray(NSDictionary *dictionary, NSString *key);