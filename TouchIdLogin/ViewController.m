//
//  ViewController.m
//  TouchIdLogin
//
//  Created by malikj on 25/10/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitClicked:(id)sender {
    if ([_userTextfield.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserName"]] && [_passwordTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"Password"]]) {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController * presentControllerss = [storyBoard instantiateViewControllerWithIdentifier:@"NavigationView"];
        [self presentViewController:presentControllerss animated:YES completion:nil];
    }
    else {
        [self alertWithTitle:@"Authentication Failed" andMessage:@"Invalid Creadentials"];
    }
}

- (void)loginWithTouchId {
    LAContext *context = [[LAContext alloc] init];
        __block  NSString *message;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Unlock access to locked feature" reply:^(BOOL success, NSError *authenticationError) {
            if (success) {
                UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController * presentController = [storyBoard instantiateViewControllerWithIdentifier:@"NavigationView"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:presentController animated:YES completion:nil];
                });
            }
            else {
                message = [NSString stringWithFormat:@"evaluatePolicy: %@", authenticationError.localizedDescription];
                NSLog(@"no");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithTitle:@"TouchId Authentication failed" andMessage:message];
            });

        }];
}

- (IBAction)touchIDClicked:(id)sender {
    [self loginWithTouchId];
}

//- (IBAction)cancel:(UIStoryboardSegue*)cancelSegue {
//
//    
//}

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        NSLog(@"OK Button Pressed");
    }];
    
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
