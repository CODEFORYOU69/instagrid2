//
//  ViewController.swift
//  instagrid 2
//
//  Created by younes ouasmi on 15/12/2023.
//

import UIKit
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
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
                selectedImageView?.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        
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
        [Template1, Template2, Template3].forEach { button in
            button.subviews.forEach { subview in
                if subview.tag == 100 {
                    subview.removeFromSuperview()
                }
            }
        }

        let selectedImageView = UIImageView(image: UIImage(named: "Selected"))
        selectedImageView.frame = sender.bounds
        selectedImageView.tag = 100
        sender.addSubview(selectedImageView)

        switch sender {
        case Template1:
            applyLayoutForTemplate1()
        case Template2:
            applyLayoutForTemplate2()
        case Template3:
            applyLayoutForTemplate3()
        default:
            break
        }
    }

    func applyLayoutForTemplate1() {
        if UIDevice.current.orientation.isPortrait {
            widthConstraintViewA.constant = 270
            widthConstraintViewB.constant = 0
            
            ViewB.isHidden = true
            ViewD.isHidden = false
            
            widthConstraintViewC.constant = 127
            widthConstraintViewD.constant = 127
            
            self.view.layoutIfNeeded()
            
            resizeImagesForNewLayout()
            
            imageA.isUserInteractionEnabled = true
            imageB.isUserInteractionEnabled = false
        } else if UIDevice.current.orientation.isLandscape {
            widthConstraintViewA.constant = 100
            widthConstraintViewB.constant = 0
            
            ViewB.isHidden = true
            ViewD.isHidden = false
            
            widthConstraintViewC.constant = 100
            widthConstraintViewD.constant = 100
            
            self.view.layoutIfNeeded()
            
            resizeImagesForNewLayout()
            
            imageA.isUserInteractionEnabled = true
            imageB.isUserInteractionEnabled = false
        }}

    func applyLayoutForTemplate2() {
        if UIDevice.current.orientation.isPortrait {
            widthConstraintViewC.constant = 270
            widthConstraintViewD.constant = 0
            ViewD.isHidden = true
            ViewB.isHidden = false
            imageB.isHidden = false
            
            
            
            widthConstraintViewA.constant = 127
            widthConstraintViewB.constant = 127
            self.view.layoutIfNeeded()
            
            resizeImagesForNewLayout()
            
            imageB.isUserInteractionEnabled = true
        } else if UIDevice.current.orientation.isLandscape {
            widthConstraintViewC.constant = 216
            widthConstraintViewD.constant = 0
            ViewD.isHidden = true
            ViewB.isHidden = false
            imageB.isHidden = false
            
            
            
            widthConstraintViewA.constant = 100
            widthConstraintViewB.constant = 100
            self.view.layoutIfNeeded()
            
            resizeImagesForNewLayout()
            
            imageB.isUserInteractionEnabled = true
        }}
    
    func applyLayoutForTemplate3() {
        if UIDevice.current.orientation.isPortrait {
            widthConstraintViewC.constant = 127
            widthConstraintViewD.constant = 127
            widthConstraintViewA.constant = 127
            widthConstraintViewB.constant = 127
            ViewD.isHidden = false
            ViewB.isHidden = false
        } else if UIDevice.current.orientation.isLandscape {
            
            widthConstraintViewC.constant = 100
            widthConstraintViewD.constant = 100
            widthConstraintViewA.constant = 100
            widthConstraintViewB.constant = 100
            ViewD.isHidden = false
            ViewB.isHidden = false
            
        }}
    func resizeImagesForNewLayout() {
        [imageA, imageB, imageC, imageD].forEach { imageView in
            if let image = imageView?.image {
                imageView?.image = image
            }
        }
    }
        }
    
   

