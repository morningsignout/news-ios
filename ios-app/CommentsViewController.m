//
//  CommentsViewController.m
//  ios-app
//
//  Created by Vincent Chau on 11/19/15.
//  Edited by Siddharth Verma on 12/17/15
//  Copyright © 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "CommentsViewController.h"
#import <IonIcons.h>
@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UITextField *commentTextField;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"CellIdentifier";
    UITableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
        
    }
    cell.textLabel.text       = @"This article is awesome!";
    cell.detailTextLabel.text = @"Random Person 11/21/15";
    cell.backgroundColor      = [UIColor clearColor];
    return cell;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)loadView
{
    // Set up view
    CGRect screenFrame                  = [UIScreen mainScreen].bounds;
    CGRect viewSize                     = CGRectMake(0, screenFrame.size.height * 0.35, screenFrame.size.width, screenFrame.size.height * 0.65);
    CGRect tableViewSize                = CGRectMake(0, screenFrame.size.height * 0.5, screenFrame.size.width, screenFrame.size.height / 2.0);
    self.view = [[UIView alloc]         initWithFrame:screenFrame];

    // Tableview setup
    UITableView *tableView              = [[UITableView alloc] initWithFrame:tableViewSize
                                                                       style:UITableViewStylePlain];
    tableView.autoresizingMask          = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate                  = self;
    tableView.dataSource                = self;
    tableView.backgroundColor           = [UIColor whiteColor];
    [tableView reloadData];
    [self.view addSubview:tableView];
    
    // Textfield and Submit setup
    UIView *blankView                           = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                           viewSize.origin.y + 30 ,
                                                                                           viewSize.size.width,
                                                                                           viewSize.size.height - tableViewSize.size.height - 30 )];
    blankView.backgroundColor                   = [UIColor whiteColor];
    [self.view addSubview:blankView];
    
    _commentTextField                           = [[UITextField alloc] initWithFrame:CGRectMake(viewSize.size.width * 0.04,
                                                                                               viewSize.origin.y + 55,
                                                                                               viewSize.size.width * 0.81,
                                                                                               blankView.frame.size.height * 0.4)]; ////////////
    _commentTextField.delegate                  = self;
    _commentTextField.backgroundColor           = [UIColor whiteColor];
    _commentTextField.textAlignment             = NSTextAlignmentLeft;
    _commentTextField.contentVerticalAlignment  = UIControlContentVerticalAlignmentTop;
    _commentTextField.placeholder               = @"Type your comment...";
    [_commentTextField setBorderStyle:         UITextBorderStyleRoundedRect];
    [self.view addSubview:_commentTextField];
    
    // Post button set up
    UIButton *postButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame                            = CGRectMake(viewSize.size.width * 0.85, viewSize.origin.y + 60.25, 50, 20);
    postButton.backgroundColor                  = [UIColor whiteColor];
    
    [postButton         addTarget:self
                           action:@selector(postButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [postButton          setTitle:@"Post"
                         forState:UIControlStateNormal];
    
    [postButton     setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]
                         forState:UIControlStateNormal];
    
    [postButton     setTitleColor:[UIColor grayColor]
                         forState:UIControlStateHighlighted];
   
    [self.view addSubview:postButton];
    
    // Set up invisible button for user exit
    UIButton *closeButton                       = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame                           = CGRectMake(0,0, screenFrame.size.width, screenFrame.size.height * 0.35);
    closeButton.backgroundColor                 = [UIColor clearColor];
    
    [closeButton        addTarget:self
                           action:@selector(closeButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
   
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
   
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder]; return YES;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)postButtonPressed:(UIButton*)button{
    NSLog(@"post pressed");
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                       message:@"Your comment has been posted."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}
-(void)closeButtonPressed:(UIBarButtonItem*)button{
    NSLog(@"close button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

