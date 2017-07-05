//
//  SRMRouter.m
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import "SRMRouter.h"
#import "SRMRouteRequest.h"
#import "SRMRouteHandler.h"
#import "SRMRegularExpression.h"

@interface SRMRouter ()

@property (nonatomic) NSMutableDictionary *handlerDictionary;
@property (nonatomic) NSMutableDictionary *expressionDictionary;

@end

@implementation SRMRouter

- (instancetype)init {
    if (self = [super init]) {
        self.handlerDictionary = [[NSMutableDictionary alloc] init];
        self.expressionDictionary = [[NSMutableDictionary alloc] init];
    }

    return self;
}

+ (instancetype)sharedInstance {
    static SRMRouter *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SRMRouter alloc] init];
    });

    return sharedInstance;
}

- (void)registerHandler:(SRMRouteHandler *)handler forRoute:(NSString *)route {
    if (!route.length || !handler) {
        return;
    }

    self.handlerDictionary[route] = handler;
    SRMRegularExpression *regularExpression = [SRMRegularExpression expressionWithPattern:route];
    self.expressionDictionary[route] = regularExpression;
}

- (BOOL)requestRoute:(NSString *)route withParameters:(NSDictionary *)parameters sourceController:(UIViewController *)sourceController {
    if (!route.length) {
        return NO;
    }

    __block BOOL isHandled = NO;

    [self.handlerDictionary.allKeys enumerateObjectsUsingBlock:^(NSString *registeredRoute, NSUInteger index, BOOL * _Nonnull stop) {
        SRMRegularExpression *regularExpression = self.expressionDictionary[registeredRoute];
        SRMMatchResult *result = [regularExpression matchesString:route];

        if (!result.match) {
            return;
        }

        SRMRouteRequest *routeRequest = [[SRMRouteRequest alloc] init];
        routeRequest.route = route;
        NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [allParameters addEntriesFromDictionary:result.parametersDictionary];
        routeRequest.parameters = [allParameters copy];
        routeRequest.sourceController = sourceController;
        SRMRouteHandler *handler = self.handlerDictionary[registeredRoute];

        if (![handler shouldHandleRequest:routeRequest]) {
            return;
        }

        [handler handleRouteRequest:routeRequest];
        isHandled = YES;
        *stop = YES;
    }];
    
    return isHandled;
}

@end
