//
//  NomiViewController.m
//  Example
//
//  Created by Nomi on 1/28/14.
//  Copyright (c) 2014 Nomi. All rights reserved.
//


#import "NomiViewController.h"

@interface NomiViewController ()
{
    UIImage *image;
}

@end

@implementation NomiViewController
@synthesize coredataManagerObject;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    /*NSManagedObject *sr=[[[self ]]
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     UIImage *image = [UIImage imageWithData:[selectedObject valueForKey:@"imageKey"]];
     [[selectedObject yourImageView] setImage:image];*/
    
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity1];
    
    NSError *error;
    
    NSArray * array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (array == nil) {
        
        NSLog(@"Testing: No results found");
        
    }else {
        
        NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
    }
    
    NSData * dataBytes = [[array objectAtIndex:0] data];
    
    image = [UIImage imageWithData:dataBytes];

    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImage:(id)sender
{
    UIImagePickerController *pickMe=[[UIImagePickerController alloc]init];
    pickMe.delegate=self;
    pickMe.allowsEditing=YES;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertMe=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera is not available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertMe show];
        
    }
    else{
        pickMe.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:pickMe animated:YES completion:Nil];
    
    
}
- (IBAction)takeIt:(id)sender {
    
    UIImagePickerController *pickeOne=[[UIImagePickerController alloc]init];
    pickeOne.delegate=self;
    pickeOne.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickeOne animated:YES completion:Nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *prefer=info[UIImagePickerControllerEditedImage];
    self.imageProp.image=prefer;
   NSData *imageData = UIImageJPEGRepresentation(_imageProp.image, 1.0);// converting ito nsdata
    
    
   // NSLog(@"imageData==> %@",imageData);
    
    
    coredataManagerObject = [[CoredataManager alloc]init];
    _managedObjectContext = [coredataManagerObject managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ImageEntity" inManagedObjectContext:_managedObjectContext];
    
    NSManagedObject *mangedObj = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:_managedObjectContext];

    [mangedObj setValue:imageData forKey:@"image"];
    NSError *error;
    [_managedObjectContext save:&error];
    NSLog(@"Image added into Coredata..");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)postToFriendWall:(NSString *)userId {
    facebook = [[Facebook alloc]initWithAppId:APP_ID andDelegate:self];
    
    if (![facebook isSessionValid]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [facebook setAccessToken:[defaults objectForKey:FB_ACCESS_TOKEN]];
        [facebook setExpirationDate:[defaults objectForKey:FB_EXPIRATION_DATE]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultWish = [defaults objectForKey:[NSString stringWithFormat:@"%@%@", DEFAULT_WISH, [defaults objectForKey:FB_USER_ID]]];
    NSString *defaultImage = [defaults objectForKey:[NSString stringWithFormat:@"%@%@", DEFAULT_IMAGE, [defaults objectForKey:FB_USER_ID]]];
    
    if (defaultImage == nil && defaultWish == nil) {
        [self showAlertViewWithTitle:@"Post wasn't sent" message:@""];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    [params setObject:defaultWish forKey:@"message"];
    if (![defaultImage isEqualToString:@"none"])
        [params setObject:[UIImage imageNamed:defaultImage] forKey:@"picture"];
    
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", userId] andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
}

- (void)fbDidLogin {
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:FB_ACCESS_TOKEN];
    [defaults setObject:[facebook expirationDate] forKey:FB_EXPIRATION_DATE];
    
    [defaults synchronize];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSString *errorDescription = [error description];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)fbDidNotLogin:(BOOL)cancelled{
}

- (void)fbDidLogout{
}

- (void)fbSessionInvalidated{
}

- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
}

- (void)fbDialogNotLogin:(BOOL)cancelled {
}

- (IBAction)retrivre:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"ImageEntity" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity1];
    
    NSError *error;
    
    NSArray * array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (array == nil) {
        
        NSLog(@"Testing: No results found");
        
    }else {
        
        NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
    }
    
    NSData * dataBytes = [[array objectAtIndex:0] data];
    
    image = [UIImage imageWithData:dataBytes];
    NSLog(@"====> %@", image);
    
//    coredataManagerObject = [[CoredataManager alloc]init];
//     _managedObjectContext = [coredataManagerObject managedObjectContext];
//    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"ImageEntity" inManagedObjectContext:_managedObjectContext];
//    NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
//    [fetch setEntity:entityDesc];
//
//    
//    NSManagedObject *manageObj=Nil;
//    NSError *error;
//    NSArray *arrayObj=[_managedObjectContext executeFetchRequest:fetch error:&error];
//    if ([arrayObj count]==0) {
//        
//        NSLog(@"No Object found %@", arrayObj);
//    }
//    else
//    {
//        manageObj=[arrayObj objectAtIndex:0];
//        NSLog(@"Objects found %@", arrayObj);
//
//        
//        
//    }
    
  }

    

@end
