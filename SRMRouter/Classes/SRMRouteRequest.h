//
//  SRMRouteRequest.h
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface SRMRouteRequest : NSObject

@property (nonatomic) NSString *route;
@property (nonatomic) NSDictionary *parameters;
@property (nonatomic) UIViewController *sourceController;

@end
