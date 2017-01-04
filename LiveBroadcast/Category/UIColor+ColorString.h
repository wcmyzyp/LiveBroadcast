//
//  ILSUIColor.h
//  ILSApp
//
//  Created by jun on 14-1-13.
//  Copyright (c) 2014年 iLegendSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (ColorString)

+ (UIColor *) colorFromHexString:(NSString *)hexString;
- (BOOL) isEqualToColor:(UIColor *)otherColor;

@end
