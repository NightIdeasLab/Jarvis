#import <AppKit/AppKit.h>
#import "NSFancyPanel.h"
@class ScrollingTextView;


@interface AboutPanelController : NSObject <NSWindowDelegate, NSFancyPanelController> {
    // This panel exists in the nib file, but the user never sees it, because
    // we rip out its contents and place them in “panelToDisplay”.
    IBOutlet NSPanel            *panelInNib;
    // This panel is not in the nib file; we create it programmatically.
    NSPanel                     *panelToDisplay;
    // Scrolling text: the scroll-view and the text-view itself
    IBOutlet NSScrollView       *textScrollView;
    IBOutlet NSTextView         *textView;
    // Outlet we fill in using information from the application’s bundle
    IBOutlet NSTextField        *versionField;
    IBOutlet NSTextField        *shortInfoField;
    // Timer to fire scrolling animation
    NSTimer                     *scrollingTimer;
}

#pragma mark PUBLIC CLASS METHODS
+ (AboutPanelController *)sharedInstance;

#pragma mark PUBLIC INSTANCE METHODS
// Show the panel, starting the text at the top with the animation going
- (void)showPanel;

// Stop scrolling and hide the panel.
- (void)hidePanel;

- (IBAction)closePanel:(id)sender;

// This method exists only because this is a developer example.
// You wouldn’t want it in a real application.
- (void)setShowsScroller:(BOOL)newSetting;

@end