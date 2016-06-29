//
//  SpeechDetailTableViewController.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/28/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "SpeechDetailTableViewController.h"
#import "SpeechDetailAnimator.h"
#import "MaxCountWordFinder.h"

@interface SpeechDetailTableViewController ()
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic,strong) MaxCountWordFinder* maxCountWordFinder;

@end

@implementation SpeechDetailTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 240;
    // hide lines and add padding to the bottom
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    self.imageView.image = self.speech.image;
    self.titleLabel.text = self.speech.name;
    self.speakerLabel.text = self.speech.by;
    self.dateLabel.text = self.speech.date;
    self.repeatingLabel.hidden = YES;
    
    ///////////////////////////////////////////////////////////////
    // Set the line spacing in the UITextView for better reading
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.headIndent = 15;
    //paragraphStyle.firstLineHeadIndent = 15;
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacingBefore = 15;
    NSDictionary *attrsDictionary = @{ NSParagraphStyleAttributeName: paragraphStyle,
                                       NSFontAttributeName : self.textView.font ,
                                       NSForegroundColorAttributeName: [UIColor darkTextColor]};
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.speech.text attributes:attrsDictionary];

    
    // Add constirate to preserver the width and height of the image
    CGFloat aspectRatioMult = (self.imageView.image.size.width / self.imageView.image.size.height);
    [self.imageView addConstraint: [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.imageView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:aspectRatioMult
                                                                 constant:0]];
    
    // Create progressive view
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.0f;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if(self.maxCountWordFinder == nil) {
        self.maxCountWordFinder = [[MaxCountWordFinder alloc] initWithString:self.speech.text];
        [self.maxCountWordFinder findMaxWordWithProgressMinStep:0.1f progress:^(float progress) {
            [self.progressView setProgress:progress animated:YES];
        } completion:^(NSString * _Nullable maxWordString) {
            self.progressView.hidden = YES;
            
            self.repeatingLabel.text = maxWordString ? maxWordString : @"None";;
            [UIView animateWithDuration:0.3f animations:^{
                self.repeatingLabel.hidden = NO;
            } completion:nil];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0) {
        return 400;
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.progressView.bounds.size.height;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.progressView;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Transition
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[SpeechDetailAnimator alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[SpeechDetailAnimator alloc] init];
}
@end
