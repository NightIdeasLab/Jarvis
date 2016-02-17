#import <AppKit/AppKit.h>

@protocol NSFancyPanelController
- (BOOL)handlesKeyDown:(NSEvent *)keyDown inWindow:(NSWindow *)window;
- (BOOL)handlesMouseDown:(NSEvent *)mouseDown inWindow:(NSWindow *)window;
@end

@interface NSFancyPanel : NSPanel {
    id<NSFancyPanelController> controller;
}

@property (assign, nonatomic) id<NSFancyPanelController> controller;

@end