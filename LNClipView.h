//
//  LNClipView.h
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) David Keegan. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

@interface LNScrollView : NSScrollView
- (void)setPattern:(NSImage *)pattern;
@end

@interface LNWebView : WebView
- (void)setPattern:(NSImage *)pattern;
@end
