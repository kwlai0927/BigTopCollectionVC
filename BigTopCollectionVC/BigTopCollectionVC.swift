//
//  BigTopCollectionVC.swift
//  BigTopCollectionVC
//
//  Created by Lavend K. Mi on 2017/12/14.
//  Copyright © 2017年 Lavend. All rights reserved.
//

import UIKit

class BigTopCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var indecator: UIView!
    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var imgvBanner: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    var item: BigTopCollectionVC.Item!{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        imgvBanner.image = item.image
        lbTitle.text = item.title
        lbSubTitle.text = item.subTitle
    }
}

class BigTopCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let originPropotion: CGFloat = 9.0 / 16.0
    let shinkPropotion: CGFloat = 4.0 / 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        originHeight = collectionView.frame.width * originPropotion
        shinkHeight = collectionView.frame.width * shinkPropotion
        //        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var originHeight: CGFloat = 0.0
    var shinkHeight: CGFloat = 0.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    struct Item{
        let title: String
        let subTitle: String
        let image: UIImage
    }
    
    var collectionData: [Item] = [
        Item(title: "Title 0", subTitle: "Subtitle 0", image: #imageLiteral(resourceName: "Image"))
        , Item(title: "Title 1", subTitle: "Subtitle 1", image: #imageLiteral(resourceName: "Image-1"))
        , Item(title: "Title 2", subTitle: "Subtitle 2", image: #imageLiteral(resourceName: "Image-2"))
        , Item(title: "Title 3", subTitle: "Subtitle 3", image: #imageLiteral(resourceName: "Image-3"))
        , Item(title: "Title 4", subTitle: "Subtitle 4", image: #imageLiteral(resourceName: "Image-4"))
        , Item(title: "Title 5", subTitle: "Subtitle 5", image: #imageLiteral(resourceName: "Image-5"))
        , Item(title: "Title 6", subTitle: "Subtitle 6", image: #imageLiteral(resourceName: "Image-6"))
        , Item(title: "Title 7", subTitle: "Subtitle 7", image: #imageLiteral(resourceName: "Image-7"))
        , Item(title: "Title 8", subTitle: "Subtitle 8", image: #imageLiteral(resourceName: "Image-8"))
        , Item(title: "Title 9", subTitle: "Subtitle 9", image: #imageLiteral(resourceName: "Image-9"))
        
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! BigTopCollectionCell
        cell.item = collectionData[indexPath.row]
        if indexPath.row == 0{
            var frame = cell.bounds
            frame.size.height = originHeight
            frame.origin.y = cell.bounds.size.height - frame.size.height
            cell.contentView.frame = frame
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: collectionView.bounds.height - originHeight, right: 0   )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.width, height: originHeight)
        }
        return CGSize(width: collectionView.frame.width, height: shinkHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let topVisiableSpace = cell.frame.origin.y - collectionView.contentOffset.y
        
        collectionView.sendSubview(toBack: cell)
        
        if indexPath.row == 0{ // 第一個永遠為 Origin Size
            return
        }
        else if topVisiableSpace > originHeight{ // 已縮
            //            (cell as! TelescopicCell).indecator.backgroundColor = UIColor.lightGray
            cell.contentView.frame = cell.bounds
        }
        else if topVisiableSpace + cell.bounds.size.height < originHeight{ // 原始尺寸
            //            (cell as! TelescopicCell).indecator.backgroundColor = .orange
            var frame = cell.bounds
            frame.size.height = originHeight
            frame.origin.y = shinkHeight - frame.size.height
            cell.contentView.frame = frame
            collectionView.sendSubview(toBack: cell)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in collectionView.visibleCells{
            let topVisiableSpace = cell.frame.origin.y - scrollView.contentOffset.y
            // 變化中的Cell
            if topVisiableSpace <= originHeight && topVisiableSpace + shinkHeight >= originHeight{
                //                (cell as! TelescopicCell).indecator.backgroundColor = .green
                collectionView.bringSubview(toFront: cell)
                var frame = cell.bounds
                let deltaRate = (originHeight - topVisiableSpace) / shinkHeight
                frame.size.height =  shinkHeight + (originHeight - shinkHeight) * deltaRate
                //                print("expending Height: \(frame.size.height)")
                frame.origin.y = shinkHeight - frame.size.height
                cell.contentView.frame = frame
                break
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollVisableCellToRightPlace(collectionView: scrollView as! UICollectionView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollVisableCellToRightPlace(collectionView: scrollView as! UICollectionView)
    }
    
    func scrollVisableCellToRightPlace(collectionView: UICollectionView){
        for cell in collectionView.visibleCells{
            let topVisiableSpace = cell.frame.origin.y - collectionView.contentOffset.y
            
            if topVisiableSpace < originHeight && topVisiableSpace + shinkHeight > originHeight{
                
                let deltaRate = (originHeight - topVisiableSpace) / shinkHeight
                let targetY: CGFloat = deltaRate > 0.5 ? cell.frame.origin.y - originHeight + shinkHeight : cell.frame.origin.y - originHeight
                collectionView.setContentOffset(CGPoint(x: 0, y: targetY), animated: true)
                break
            }
        }
    }
}
