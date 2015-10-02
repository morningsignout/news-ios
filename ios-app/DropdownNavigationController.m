//
//  NavDropdownController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DropdownNavigationController.h"
#import "ContainerViewController.h"
#import "Constants.h"
#import <IonIcons.h>

#define FEATURE_INDEX 0
#define SEARCH_INDEX 1
#define CATEGORIES_INDEX 2
#define BOOKMARKS_INDEX 3

NSString * const section[] = {
    @"Featured", @"Search", @"Categories", @"Bookmarks"
};

@interface DropdownNavigationController () {
    int sectionCurrentlyOn;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonOutletArray;
@property (strong, nonatomic) ContainerViewController *containerVC;

@end

@implementation DropdownNavigationController

@synthesize buttons = _buttons;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeMenu];
    sectionCurrentlyOn = FEATURE_INDEX;
}

-(void) customizeMenu {
    // To set the menubar background colour programmatically.
    [self setMenubarBackground:[UIColor kNavBackgroundColor]];
    
    // Replace menu button with an IonIcon.
    [self.menuButton setTitle:nil forState:UIControlStateNormal];
    [self.menuButton setImage:[IonIcons imageWithIcon:ion_navicon size:30.0f color:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        [button setTitle:section[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setImage:[IonIcons imageWithIcon:ion_music_note size:20.0f color:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else if (i == 1) {
            [button setImage:[IonIcons imageWithIcon:ion_mouse size:20.0f color:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else if (i == 2) {
            [button setImage:[IonIcons imageWithIcon:ion_model_s size:20.0f color:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else if (i == 3) {
            [button setImage:[IonIcons imageWithIcon:ion_map size:20.0f color:[UIColor whiteColor]] forState:UIControlStateNormal];
        }
        
        // Set the title and icon position
        [button sizeToFit];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width-10, 0, button.imageView.frame.size.width);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel.frame.size.width, 0, -button.titleLabel.frame.size.width);

    }
    
    //Uncomment to stop drop 'Triangle' from appearing
    //[self dropShapeShouldShowWhenOpen:NO];
    
    //Uncomment to fade to white instead of default (black)
    [self setFadeTintWithColor:[UIColor blackColor]];
    
    //Uncomment for increased fade effect (default is 0.5f)
    //[self setFadeAmountWithAlpha:0.2f];

}

- (IBAction)swapButtonPressed:(UIButton *)sender
{
    int index = (int)[self.buttonOutletArray indexOfObject:sender];
    
    if (index == sectionCurrentlyOn) {
        return;
    }
    
    [self.containerVC swapViewControllersToIndex:index];
    sectionCurrentlyOn = index;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerVC = segue.destinationViewController;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
