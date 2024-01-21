//
//  ViewController.swift
//  instagrid 2
//
//  Created by younes ouasmi on 15/12/2023.
//

import UIKit
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imageGrid = ImageGrid()

    
    
    @IBOutlet weak var addPicture: UIStackView!
    
    @IBOutlet weak var widthConstraintViewD: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintViewC: NSLayoutConstraint!
    

    @IBOutlet weak var widthConstraintViewB: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintViewA: NSLayoutConstraint!
    @IBOutlet weak var ViewA: UIView!
    @IBOutlet weak var ViewB: UIView!

    @IBOutlet weak var PictureContainer: UIStackView!
    @IBOutlet weak var Template1: UIButton!
    @IBOutlet weak var Template2: UIButton!
    @IBOutlet weak var Template3: UIButton!
    
    @IBOutlet weak var ViewD: UIView!
    @IBOutlet weak var ViewC: UIView!
    var selectedImageView: UIImageView?
    var currentSelectedButton: UIButton?

    @IBOutlet weak var imageA: UIImageView!

    @IBOutlet weak var imageB: UIImageView!
    @IBOutlet weak var imageC: UIImageView!
    @IBOutlet weak var imageD: UIImageView!
    
    

    private var selectedImageViews: UIImageView?



    
    @IBAction func selectViewA(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageA
        checkAndOpenPhotoLibrary()
    }
    @IBAction func selectViewB(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageB
        checkAndOpenPhotoLibrary()
    }
    
    @IBAction func selectViewC(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageC
        checkAndOpenPhotoLibrary()
    }
    
    @IBAction func selectViewD(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageD
        checkAndOpenPhotoLibrary()
    }
    
    private func checkAndOpenPhotoLibrary() {
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch authorizationStatus {
            case .authorized:
                openPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                    if newStatus == .authorized {
                        DispatchQueue.main.async {
                            self?.openPhotoLibrary()
                        }
                    }
                }
            case .denied, .restricted:

                break
            case .limited:
                openPhotoLibrary()
            @unknown default:
                break
            }
        }

        private func openPhotoLibrary() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {

            if let selectedTag = selectedImageView?.tag {
                imageGrid.setImage(selectedImage, atIndex: selectedTag)
                updateImageViews()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func updateImageViews() {

        imageA.image = imageGrid.images[0]
        imageB.image = imageGrid.images[1]
        imageC.image = imageGrid.images[2]
        imageD.image = imageGrid.images[3]

    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
  

            imageA.tag = 0
            imageB.tag = 1
            imageC.tag = 2
            imageD.tag = 3
           configureImageView(imageA)
           configureImageView(imageB)
           configureImageView(imageC)
           configureImageView(imageD)
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeUpGesture.direction = .up
            addPicture.addGestureRecognizer(swipeUpGesture)

            let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeLeftGesture.direction = .left
            addPicture.addGestureRecognizer(swipeLeftGesture)
        
    }
    func convertToImage(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait && gesture.direction == .up {
            handleSwipeAnimation(translationX: 0, y: -self.view.bounds.height)
        } else if UIDevice.current.orientation.isLandscape && gesture.direction == .left {
            handleSwipeAnimation(translationX: -self.view.bounds.width, y: 0)
        }
    }

    private func handleSwipeAnimation(translationX x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.addPicture.transform = CGAffineTransform(translationX: x, y: y)
        }, completion: { _ in
            self.showActivityViewController()
        })
    }

    func showActivityViewController() {
        guard let imageToShare = convertToImage(addPicture) else { return }
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)


        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.addPicture.transform = .identity
            }
        }

        present(activityViewController, animated: true, completion: nil)
    }
    private func configureImageView(_ imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            selectedImageView = imageView
            checkAndOpenPhotoLibrary()
        }
    }
    
    @IBAction func templateButtonPressed(_ sender: UIButton) {
        switch sender {
            case Template1:
                imageGrid.setTemplate(.template1)
            case Template2:
                imageGrid.setTemplate(.template2)
            case Template3:
                imageGrid.setTemplate(.template3)
            default:
                break
            }
            applyLayoutForCurrentTemplate()
    }
    func applyLayoutForCurrentTemplate() {
        switch imageGrid.currentTemplate {
        case .template1:
            applyLayoutForTemplate1()
        case .template2:
            applyLayoutForTemplate2()
        case .template3:

        }
    }


    func applyLayoutForTemplate1() {
        UIView.animate(withDuration: 0.5, animations: {
            if UIDevice.current.orientation.isPortrait {
                self.widthConstraintViewA.constant = 270
                self.widthConstraintViewB.constant = 0
                
                self.ViewB.isHidden = true
                self.ViewD.isHidden = false
                
                self.widthConstraintViewC.constant = 127
                self.widthConstraintViewD.constant = 127
            } else {
                self.widthConstraintViewA.constant = 100
                self.widthConstraintViewB.constant = 0
                
                self.ViewB.isHidden = true
                self.ViewD.isHidden = false
                
                self.widthConstraintViewC.constant = 100
                self.widthConstraintViewD.constant = 100
            }

            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.resizeImagesForNewLayout()
            
            self.imageA.isUserInteractionEnabled = true
            self.imageB.isUserInteractionEnabled = false
        })
    }

    func applyLayoutForTemplate2() {
        UIView.animate(withDuration: 0.5, animations: {
            if UIDevice.current.orientation.isPortrait {
                self.widthConstraintViewC.constant = 270
                self.widthConstraintViewD.constant = 0
                self.ViewD.isHidden = true
                self.ViewB.isHidden = false
                self.imageB.isHidden = false
                
                self.widthConstraintViewA.constant = 127
                self.widthConstraintViewB.constant = 127
            } else {
                self.widthConstraintViewC.constant = 216
                self.widthConstraintViewD.constant = 0
                self.ViewD.isHidden = true
                self.ViewB.isHidden = false
                self.imageB.isHidden = false
                
                self.widthConstraintViewA.constant = 100
                self.widthConstraintViewB.constant = 100
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.resizeImagesForNewLayout()
            self.imageB.isUserInteractionEnabled = true
        })
    }

    func applyLayoutForTemplate3() {
        UIView.animate(withDuration: 0.5, animations: {
            if UIDevice.current.orientation.isPortrait {
                self.widthConstraintViewC.constant = 127
                self.widthConstraintViewD.constant = 127
                self.widthConstraintViewA.constant = 127
                self.widthConstraintViewB.constant = 127
                self.ViewD.isHidden = false
                self.ViewB.isHidden = false
            } else {
                self.widthConstraintViewC.constant = 100
                self.widthConstraintViewD.constant = 100
                self.widthConstraintViewA.constant = 100
                self.widthConstraintViewB.constant = 100
                self.ViewD.isHidden = false
                self.ViewB.isHidden = false
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.resizeImagesForNewLayout()
        })
    }

    func resizeImagesForNewLayout() {
        [imageA, imageB, imageC, imageD].forEach { imageView in
            if let image = imageView?.image {
                imageView?.image = image
            }
        }
    }
        }
    
   

