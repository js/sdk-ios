//
//  SPiDResponse.m
//  SPiDSDK
//
//  Copyright (c) 2012 Schibsted Payment. All rights reserved.
//

#import "SPiDResponse.h"
#import "SPiDClient.h"
#import "SPiDError.h"

@implementation SPiDResponse

- (id)initWithJSONData:(NSData *)data {
    self = [super init];
    if (self) {
        NSError *jsonError = nil;
        if ([data length] > 0) {
            [self setRawJSON:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            [self setMessage:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError]];
            if (jsonError) {
                [self setError:[SPiDError errorFromNSError:jsonError]];
                SPiDDebugLog(@"JSON parse error: %@", self.rawJSON);
            } else {
                if ([[self message] objectForKey:@"error"] && ![[[self message] objectForKey:@"error"] isEqual:[NSNull null]]) {
                    [self setError:[SPiDError errorFromJSONData:[self message]]];
                } // else everything ok
            }
        } else {
            [self setError:[SPiDError apiErrorWithCode:SPiDUserAbortedLogin reason:@"ApiException" descriptions:[NSDictionary dictionaryWithObjectsAndKeys:@"Recevied empty response", @"error", nil]]];
        }
    }
    return self;
}

- (id)initWithError:(NSError *)error {
    self = [super self];
    if (self) {
        [self setError:[SPiDError errorFromNSError:error]];
    }
    return self;
}

@end