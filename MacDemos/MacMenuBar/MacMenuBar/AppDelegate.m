//
//  AppDelegate.m
//  MacMenuBar
//
//  Created by coderyi on 15/12/2.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
@interface AppDelegate ()
@property (strong,nonatomic) NSStatusItem *item;
@property(nonatomic,strong)DemoViewController *demoViewController;
@property(nonatomic,strong)NSPopover *sharePopover;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _demoViewController =[[DemoViewController alloc] init];
    NSStatusBar *systemStatusBar=[NSStatusBar systemStatusBar];
    NSStatusItem *tempItem = [systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    tempItem.button.title=@"xx";
    tempItem.button.target=self;
    tempItem.button.action=@selector(popAction:);
    self.item=tempItem;
}

- (void)popAction:(NSStatusBarButton *)button{
    [self.sharePopover showRelativeToRect:[button bounds] ofView:button preferredEdge:NSRectEdgeMaxY];
    
}

- (NSPopover*)sharePopover
{
    if(!_sharePopover){
        _sharePopover = [[NSPopover alloc]init];
        _sharePopover.contentViewController = self.demoViewController;
        _sharePopover.behavior = NSPopoverBehaviorTransient;
    }
    return _sharePopover;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
