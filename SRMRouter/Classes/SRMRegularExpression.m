//
//  SRMRegularExpression.m
//  Pods
//
//  Created by marksong on 05/07/2017.
//
//

#import "SRMRegularExpression.h"

static NSString * const kRouteParameterPattern = @":[a-zA-Z0-9-_][^/]+";
static NSString * const kRouteParameterNamePattern = @":[a-zA-Z0-9-_]+";

@interface SRMRegularExpression ()

@property (nonatomic) NSArray *parameterNameArray;

@end

@implementation SRMRegularExpression

+ (SRMRegularExpression *)expressionWithPattern:(NSString *)pattern {
    SRMRegularExpression *regularExpression =[[SRMRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];

    return regularExpression;
}

- (instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError * _Nullable __autoreleasing *)error {
    NSString *transformedPattern = [[self class] transformPattern:pattern];

    if (self = [super initWithPattern:transformedPattern options:options error:error]) {
        self.parameterNameArray = [[self class] parameterNameArrayFromPattern:pattern];
    }

    return self;
}

- (SRMMatchResult *)matchesString:(NSString *)string {
    NSArray *resultArray = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    SRMMatchResult *matchResult = [[SRMMatchResult alloc] init];

    if (resultArray.count == 0) {
        return matchResult;
    }

    matchResult.match = YES;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];

    for (NSTextCheckingResult *result in resultArray) {
        for (int i = 1; i<result.numberOfRanges && i <= self.parameterNameArray.count; i++) {
            NSString *parameterName = self.parameterNameArray[i-1];
            NSString *parameterValue = [string substringWithRange:[result rangeAtIndex:i]];
            [parameterDictionary setObject:parameterValue forKey:parameterName];
        }
    }

    matchResult.parametersDictionary = [parameterDictionary copy];

    return matchResult;
}

+ (NSString *)transformPattern:(NSString *)pattern {
    NSString *transformedPattern = [NSString stringWithString:pattern];
    NSArray *parameterPatternArray = [self parameterPatternArrayFromPattern:pattern];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:kRouteParameterNamePattern options:NSRegularExpressionCaseInsensitive error:nil];

    for (NSString *parameterPattern in parameterPatternArray) {
        NSString *replacedParameterPattern;
        NSTextCheckingResult *parameterNameResult = [regularExpression matchesInString:parameterPattern options:NSMatchingReportProgress range:NSMakeRange(0, parameterPattern.length)].firstObject;

        if (parameterNameResult) {
            NSString *parameterName =[parameterPattern substringWithRange:parameterNameResult.range];
            replacedParameterPattern = [parameterPattern stringByReplacingOccurrencesOfString:parameterName withString:@""];
        }

        if (replacedParameterPattern.length == 0) {
            replacedParameterPattern = @"([^/]+)";
        }

        transformedPattern = [transformedPattern stringByReplacingOccurrencesOfString:parameterPattern withString:replacedParameterPattern];
    }

    if (transformedPattern.length && !([transformedPattern characterAtIndex:0] == '/')) {
        transformedPattern = [@"^" stringByAppendingString:transformedPattern];
    }

    transformedPattern = [transformedPattern stringByAppendingString:@"$"];

    return transformedPattern;
}

+ (NSArray<NSString *> * )parameterPatternArrayFromPattern:(NSString *)pattern {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:kRouteParameterPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [regularExpression matchesInString:pattern options:NSMatchingReportProgress range:NSMakeRange(0, pattern.length)];
    NSMutableArray *array = [NSMutableArray array];

    for (NSTextCheckingResult *result in resultArray) {
        NSString *parameterPattern = [pattern substringWithRange:result.range];
        [array addObject:parameterPattern];
    }

    return [array copy];
}

+ (NSArray *)parameterNameArrayFromPattern:(NSString *)pattern{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:kRouteParameterNamePattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *parameterPatternArray = [self parameterPatternArrayFromPattern:pattern];
    NSMutableArray *parameterNameArray = [[NSMutableArray alloc] init];

    for (NSString *parameterPattern in parameterPatternArray) {
        NSTextCheckingResult *parameterNameResult = [regularExpression matchesInString:parameterPattern options:NSMatchingReportProgress range:NSMakeRange(0, parameterPattern.length)].firstObject;

        if (parameterNameResult) {
            NSString *parameterName = [parameterPattern substringWithRange:parameterNameResult.range];
            parameterName = [parameterName stringByReplacingOccurrencesOfString:@":" withString:@""];
            [parameterNameArray addObject:parameterName];
        }
    }
    
    return [parameterNameArray copy];
}

@end

@implementation SRMMatchResult

@end
