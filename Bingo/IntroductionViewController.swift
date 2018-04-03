//
//  IntroductionViewController.swift
//  Bingo
//
//  Created by adb on 3/11/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import paper_onboarding
import TIHexColor

class IntroductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {

        return [
            OnboardingItemInfo(imageName:UIImage(named:"page_1")!,
                               title: "",
                               description: "پایانه خرید خود را همه‌جا همراه داشته باشید",
                               iconName: UIImage(named:"page_1")!,
                               color: UIColor.colorWithHexString(baseHexString: "25c6da", alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 10),
                               descriptionFont:  UIFont(name: "IRANSans-Medium", size: 15)!),
            
            OnboardingItemInfo(imageName: UIImage(named:"page_2")!,
                               title: "",
                               description: "گزارش‌ همه تراکنش‌های خود را مشاهده کنید",
                               iconName: UIImage(named:"page_2")!,
                               color: UIColor.colorWithHexString(baseHexString: "4cb6ac", alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont:  UIFont(name: "IRANSans-Medium", size: 11)!,
                               descriptionFont:  UIFont(name: "IRANSans-Medium", size: 15)!),
            
            OnboardingItemInfo(imageName: UIImage(named:"page_3")!,
                               title: "",
                               description: "به سادگی و با سرعت محصولات خود را بفروشید",
                               iconName: UIImage(named:"page_3")!,
                               color: UIColor.colorWithHexString(baseHexString:"81c683", alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont(name: "IRANSans-Medium", size: 11)!,
                               descriptionFont:  UIFont(name: "IRANSans-Medium", size: 15)!)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
