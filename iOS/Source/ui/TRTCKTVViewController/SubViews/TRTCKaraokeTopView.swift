//
//  TRTCKaraokeTopView.swift
//  TXLiteAVDemo
//
//  Created by gg on 2021/3/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation
import Kingfisher

class TRTCKaraokeImageOnlyCell: UICollectionViewCell {
    
    public let headImageView : UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isViewReady = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else {
            return
        }
        isViewReady = true
        contentView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        headImageView.layer.cornerRadius = headImageView.frame.height*0.5
    }
}

class TRTCKaraokeTopView: UIView {
    
    public let viewModel: TRTCKaraokeViewModel
    
    public var memberAudienceDataSource : [AudienceInfoModel] = []
    public func reloadAudienceList() {
        memberAudienceDataSource = viewModel.getRealMemberAudienceList()
        audienceListCollectionView.reloadData()
    }
    public func reloadRoomAvatar() {
        roomImageView.kf.setImage(with: URL(string: TRTCKaraokeIMManager.shared.checkBgImage(viewModel.roomInfo.coverUrl)), placeholder: nil, options: [], completionHandler: nil)
    }
    public func reloadRoomInfo(_ info: RoomInfo) {
        roomTitleLabel.text = info.roomName
        roomDescLabel.text = LocalizeReplaceXX(.roomIdDescText, String(info.roomID))
        setNeedsDisplay()
    }
    
    private let roomContainerView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    private let roomBgView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.alpha = 0.2
        return view
    }()
    public let roomImageView : UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.clipsToBounds = true
        return imageV
    }()
    private let roomTitleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = .roomTitleText
        label.font = UIFont(name: "PingFangSC-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    private let roomDescLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFangSC-Medium", size: 12)
        label.textColor = .white
        return label
    }()
    private let shareBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "share", in: KaraokeBundle(), compatibleWith: nil), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.isHidden = true
        return btn
    }()
    private let closeBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "exit", in: KaraokeBundle(), compatibleWith: nil), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private let reportBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "karaoke_report", in: KaraokeBundle(), compatibleWith: nil), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private let audienceListCollectionView : UICollectionView = {
        let layout = TRTCKaraokeAudienceListLayout()
        layout.itemSize = CGSize(width: 24, height: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private let nextBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "room_scrollright", in: KaraokeBundle(), compatibleWith: nil), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    init(frame: CGRect = .zero, viewModel: TRTCKaraokeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    deinit {
        TRTCLog.out("top view deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isViewReady = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else {
            return
        }
        isViewReady = true
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roomContainerView.layer.cornerRadius = roomContainerView.frame.height*0.5
        roomImageView.layer.cornerRadius = roomImageView.frame.height * 0.5
    }
    
    private func constructViewHierarchy() {
        addSubview(roomContainerView)
        roomContainerView.addSubview(roomBgView)
        roomContainerView.addSubview(roomImageView)
        roomContainerView.addSubview(roomTitleLabel)
        roomContainerView.addSubview(roomDescLabel)
        
        addSubview(shareBtn)
        addSubview(closeBtn)
        addSubview(audienceListCollectionView)
        addSubview(nextBtn)
#if RTCube_APPSTORE
        if !viewModel.isOwner {
            addSubview(reportBtn)
        }
#endif
    }
    
    private func activateConstraints() {
        activateConstraintsRoomView() // 顶部房间信息区域
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(roomContainerView)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        shareBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeBtn.snp.leading).offset(-10)
            make.centerY.equalTo(closeBtn)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        nextBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(audienceListCollectionView.snp.trailing).offset(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalTo(audienceListCollectionView)
        }
        if reportBtn.superview != nil {
            reportBtn.snp.makeConstraints { (make) in
                make.trailing.equalTo(closeBtn.snp.leading).offset(-10)
                make.centerY.equalTo(closeBtn)
                make.size.equalTo(CGSize(width: 32, height: 32))
            }
            audienceListCollectionView.snp.makeConstraints { (make) in
                make.centerY.equalTo(reportBtn)
                make.trailing.equalTo(reportBtn.snp.leading).offset(-48)
                make.height.equalTo(24)
                make.width.equalTo(24*2+8)
            }
        } else {
            audienceListCollectionView.snp.makeConstraints { (make) in
                make.centerY.equalTo(closeBtn)
                make.trailing.equalTo(closeBtn.snp.leading).offset(-48)
                make.height.equalTo(24)
                make.width.equalTo(24*2+8)
            }
        }
    }
    
    private func activateConstraintsRoomView() {
        roomContainerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kDeviceSafeTopHeight+6)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        roomBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        roomImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.centerY.equalToSuperview()
        }
        roomTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(roomImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(9)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
        roomDescLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(roomTitleLabel)
            make.top.equalTo(roomTitleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    private func bindInteraction() {
        audienceListCollectionView.dataSource = self
        audienceListCollectionView.delegate = self
        audienceListCollectionView.register(TRTCKaraokeImageOnlyCell.self, forCellWithReuseIdentifier: "audienceListCell")
        memberAudienceDataSource = viewModel.getRealMemberAudienceList()
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(reportBtnClick), for: .touchUpInside)
    }
    
    @objc func closeBtnClick() {
        if viewModel.isOwner {
            viewModel.viewResponder?.showAlert(info: (.exitText, .sureToExitText), sureAction: { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.exitRoom { // 主播销毁房间
                    
                }
            }, cancelAction: {
                
            })
        }
        else {
            if viewModel.userType == .anchor {
                viewModel.viewResponder?.showAlert(info: (title: .alertToMicoffText, message: ""), sureAction: { [weak self] in
                    guard let `self` = self else { return }
                    self.viewModel.leaveSeat()
                    if TRTCKaraokeFloatingWindowManager.shared().enableFloatingWindow {
                        guard let rootVC = self.viewModel.rootVC else {
                            return
                        }
                        TRTCKaraokeFloatingWindowManager.shared().hide(vc: rootVC)
                    }
                    else {
                        self.viewModel.exitRoom {
                            
                        }
                    }
                }, cancelAction: {
                    
                })
            }
            else {
                if TRTCKaraokeFloatingWindowManager.shared().enableFloatingWindow {
                    guard let rootVC = viewModel.rootVC else {
                        return
                    }
                    TRTCKaraokeFloatingWindowManager.shared().hide(vc: rootVC)
                }
                else {
                    viewModel.exitRoom {
                        
                    }
                }
            }
        }
    }
    
    private var audienceIndex: Int = 0
    @objc func nextBtnClick() {
        audienceIndex += 1
        if audienceIndex >= memberAudienceDataSource.count {
            audienceIndex = 0
        }
        if audienceIndex >= 0, audienceIndex < audienceListCollectionView.numberOfItems(inSection: 0) {
            audienceListCollectionView.scrollToItem(at: IndexPath(item: audienceIndex, section: 0), at: .left, animated: true)
        }
    }
    @objc func shareBtnClick() {
        
    }
    @objc func reportBtnClick() {
        let selector = NSSelectorFromString("showReportAlertWithRoomId:ownerId:")
        if responds(to: selector) {
            perform(selector, with: viewModel.roomInfo.roomID.description, with: viewModel.roomInfo.ownerId)
        }
    }
}

class TRTCKaraokeAudienceListLayout : UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        if attrs?.count == 1 {
            if var frame = attrs?.first!.frame {
                frame.origin.x = self.itemSize.width + self.minimumInteritemSpacing
                attrs?.first!.frame = frame
            }
        }
        return attrs
    }
}

extension TRTCKaraokeTopView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberAudienceDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audienceListCell", for: indexPath) as! TRTCKaraokeImageOnlyCell
        let info = memberAudienceDataSource[indexPath.item]
        cell.headImageView.kf.setImage(with: URL(string: info.userInfo.userAvatar), placeholder: nil, options: [], completionHandler: nil)
        return cell
    }
}

extension TRTCKaraokeTopView : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let x = scrollView.contentOffset.x
            let page = roundf(Float(x / (24+8)))
            audienceIndex = Int(page)
            audienceListCollectionView.scrollToItem(at: IndexPath(item: audienceIndex, section: 0), at: .left, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = roundf(Float(x / (24+8)))
        audienceIndex = Int(page)
        audienceListCollectionView.scrollToItem(at: IndexPath(item: audienceIndex, section: 0), at: .left, animated: true)
    }
}

/// MARK: - internationalization string
fileprivate extension String {
    static let roomTitleText = KaraokeLocalize("Demo.TRTC.Karaoke.roomname")
    static let roomIdDescText = KaraokeLocalize("Demo.TRTC.Karaoke.roomidxx")
    static let welcomeText = KaraokeLocalize("Demo.TRTC.Karaoke.xxenterroom")
    static let exitText = KaraokeLocalize("Demo.TRTC.Karaoke.exit")
    static let sureToExitText = KaraokeLocalize("Demo.TRTC.Karaoke.isvoicingandsuretoexit")
    static let alertToMicoffText = KaraokeLocalize("退出会下麦哦～")
}
