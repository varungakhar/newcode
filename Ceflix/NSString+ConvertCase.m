//
//  NSString+ConvertCase.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "NSString+ConvertCase.h"

@implementation NSString (ConvertCase)

-(NSString *)capitalizeFirstLetter
{
    //capitalizes first letter of a NSString
    //find position of first alphanumeric charecter (compensates for if the string starts with space or other special character)
    if (self.length<1) {
        return @"";
    }
    NSRange firstLetterRange = [self rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
    if (firstLetterRange.location > self.length)
        return self;
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(firstLetterRange.location,1) withString:[[self substringWithRange:NSMakeRange(firstLetterRange.location, 1)] capitalizedString]];
    
}

-(NSString *)capitalizeSentences
{
    NSString *inputString = [self copy];
    
    //capitalize the first letter of the string
    NSString *outputStr = [inputString capitalizeFirstLetter];
    
    //capitalize every first letter after "."
    NSArray *sentences = [outputStr componentsSeparatedByString:@"."];
    outputStr = @"";
    for (NSString *sentence in sentences){
        static int i = 0;
        if (i<sentences.count-1)
            outputStr = [outputStr stringByAppendingString:[NSString stringWithFormat:@"%@.",[sentence capitalizeFirstLetter]]];
        else
            outputStr = [outputStr stringByAppendingString:[sentence capitalizeFirstLetter]];
        i++;
    }
    
    //capitalize every first letter after "?"
    sentences = [outputStr componentsSeparatedByString:@"?"];
    outputStr = @"";
    for (NSString *sentence in sentences){
        static int i = 0;
        if (i<sentences.count-1)
            outputStr = [outputStr stringByAppendingString:[NSString stringWithFormat:@"%@?",[sentence capitalizeFirstLetter]]];
        else
            outputStr = [outputStr stringByAppendingString:[sentence capitalizeFirstLetter]];
        i++;
    }
    //capitalize every first letter after "!"
    sentences = [outputStr componentsSeparatedByString:@"!"];
    outputStr = @"";
    for (NSString *sentence in sentences){
        static int i = 0;
        if (i<sentences.count-1)
            outputStr = [outputStr stringByAppendingString:[NSString stringWithFormat:@"%@!",[sentence capitalizeFirstLetter]]];
        else
            outputStr = [outputStr stringByAppendingString:[sentence capitalizeFirstLetter]];
        i++;
    }
    
    return outputStr;
}

@end
