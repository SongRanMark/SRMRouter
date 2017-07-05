//
//  SRMRegularExpression.h
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import <Foundation/Foundation.h>
@class SRMMatchResult;

@interface SRMRegularExpression : NSRegularExpression

+ (SRMRegularExpression *)expressionWithPattern:(NSString *)pattern;
- (SRMMatchResult *)matchesString:(NSString *)string;

@end

@interface SRMMatchResult : NSObject

@property (nonatomic) BOOL match;
@property (nonatomic) NSDictionary *parametersDictionary;

@end
