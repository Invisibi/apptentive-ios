//
//  ApptentiveClient.h
//  Apptentive
//
//  Created by Frank Schmitt on 4/24/17.
//  Copyright © 2017 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApptentiveRequestOperation.h"
#import "ApptentiveMessage.h"

NS_ASSUME_NONNULL_BEGIN

@class ApptentiveConversation;


@interface ApptentiveClient : NSObject <NSURLSessionDelegate, ApptentiveRequestOperationDataSource>

@property (readonly, nonatomic) NSOperationQueue *networkQueue;
@property (readonly, nonatomic) NSURL *baseURL;
@property (readonly, nonatomic) NSString *apptentiveKey;
@property (readonly, nonatomic) NSString *apptentiveSignature;

- (instancetype)initWithBaseURL:(NSURL *)baseURL apptentiveKey:(NSString *)apptentiveKey apptentiveSignature:(NSString *)apptentiveSignature delegateQueue:(NSOperationQueue *)delegateQueue;

- (ApptentiveRequestOperation *)requestOperationWithRequest:(id<ApptentiveRequest>)request token:(NSString *_Nullable)token delegate:(ApptentiveRequestOperationCallback *)delegate;
- (ApptentiveRequestOperation *)requestOperationWithRequest:(id<ApptentiveRequest>)request legacyToken:(NSString *_Nullable)token delegate:(ApptentiveRequestOperationCallback *)delegate;

@end

NS_ASSUME_NONNULL_END
