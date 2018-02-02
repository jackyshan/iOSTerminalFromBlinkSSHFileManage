//
//  FileCommandViewController.h
//  Blink
//
//  Created by jackyshan on 2018/2/2.
//  Copyright © 2018年 Carlos Cabañero Projects SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileCommandDelegate <NSObject>

- (void)excuteCommand:(NSString *)command;

@end

@interface FileCommandViewController : UIViewController

@property (weak) id<FileCommandDelegate> delegate;

@end
