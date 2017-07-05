//
//  SRMRouteHandler.h
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import <Foundation/Foundation.h>
@class SRMRouteRequest;

@interface SRMRouteHandler : NSObject

- (BOOL)shouldHandleRequest:(SRMRouteRequest *)request;
- (void)handleRouteRequest:(SRMRouteRequest *)request;

@end
