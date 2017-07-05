#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SRMRegularExpression.h"
#import "SRMRouteHandler.h"
#import "SRMRouter.h"
#import "SRMRouteRequest.h"

FOUNDATION_EXPORT double SRMRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char SRMRouterVersionString[];

