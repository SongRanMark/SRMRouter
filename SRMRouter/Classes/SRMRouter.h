//
//  SRMRouter.h
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import <Foundation/Foundation.h>
@import UIKit;
@class SRMRouteHandler;

@interface SRMRouter : NSObject

+ (instancetype)sharedInstance;
- (void)registerHandler:(SRMRouteHandler *)handler forRoute:(NSString *)route;
- (BOOL)requestRoute:(NSString *)route withParameters:(NSDictionary *)parameters sourceController:(UIViewController *)sourceController;

@end
