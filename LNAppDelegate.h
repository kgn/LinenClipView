//
//  LNAppDelegate.h
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LNClipView.h"

@interface LNAppDelegate : NSObject 
<NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet LNWebView *webView;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet LNScrollView *tableScrollView;

@end
