//
//  HITMarqueeLabel.h
//
//
//  Created by Lolo on 15/7/9.
//  Copyright © 2015年 Lolo. All rights reserved.
//

//  Scrolling Marquee

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HITMarqueeType) {
    HITMarqueeBounce = 0,
    HITMarqueeScroll
};




//IB_DESIGNABLE

@interface HITMarqueeLabel : UIView

+ (instancetype)marqueeWithType:(HITMarqueeType)type;



@property(nonatomic, strong)IBInspectable NSString* text;
@property(nonatomic, strong)IBInspectable UIColor*  textColor;
@property(nonatomic, strong)IBInspectable UIFont*   font;
@property(nonatomic, assign)IBInspectable CGFloat   interval;
#if TARGET_INTERFACE_BUILDER
@property(nonatomic, assign)IBInspectable NSInteger type;
#else
@property(nonatomic, assign)HITMarqueeType type;
#endif

- (void)marquee;



@end
