//
//  NomiViewController.h
//  Example
//
//  Created by Nomi on 1/28/14.
//  Copyright (c) 2014 Nomi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NomiAppDelegate.h"
#import "CoredataManager.h"


@interface NomiViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>





@property(nonatomic,strong)CoredataManager *coredataManagerObject;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) IBOutlet UIImageView *imageProp;
- (IBAction)selectImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *takeImage;
- (IBAction)takeIt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shareBttn;
@property (strong, nonatomic) IBOutlet UIButton *shareBttnPressed;
- (IBAction)retrivre:(id)sender;
-(void)postToFriendWall:(NSString *)userId;
@end
