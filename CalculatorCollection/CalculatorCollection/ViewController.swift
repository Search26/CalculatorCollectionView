//
//  ViewController.swift
//  CalculatorCollection
//
//  Created by Ney on 05/06/2021.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    var numberFirst: Float = 0
    var numberSecond: Float = 0
    var numberResult: Float = 0
    var isFirst = true
    var didClickedComma = false
    var operationPresent : Type = .number
    var numberAfterComma:Float = 1 // power(10,numberAfterComma)
    var factor:Float = 10 // 10 neu khong co dau phay , bang 1 neu co dau phay
    var type: Type = .number
    var value = -1
    let data = ["AC","+/-","%","/","7","8","9","X","4","5","6","-","1","2","3","+","0",",","="]
    let arrayOfOperator = [3,7,11,15,18]
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self
    }
    
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "btn", for: indexPath) as! CollectionViewCell
        cell.cellDelegate = self
        let conerR: Float = (Float(CollectionView.frame.width) - 24) / 8
        value = Int(data[indexPath.row]) ?? -1
        if (arrayOfOperator.contains(indexPath.row)) {//cac toan tu +-*/=
            switch indexPath.row {
            case 3:
                type = .div
            case 7:
                type = .mul
            case 11:
                type = .sub
            case 15:
                type = .add
            default:
                type = .cal
            }
            cell.btn.setButton(index: indexPath.row, value: value , displayValue: data[indexPath.row], type: type)
            cell.btn = setButton(btnOld : cell.btn,backgroundColor: .orange, titleColor: .white, state: .normal, title: cell.btn.displayValue , cornerRadius: conerR)
            return cell
        }
        if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){//btnClear , btnSign , btnPercent
            switch indexPath.row {
            case 0:
                type = .delete
            case 2:
                type = .percent
            default:
                type = .sign
            }
            cell.btn.setButton(index: indexPath.row, value: value , displayValue: data[indexPath.row], type: type)
            cell.btn = setButton(btnOld : cell.btn,backgroundColor: .lightGray, titleColor: .black, state: .normal, title: data[indexPath.row], cornerRadius: conerR)
            return cell
        }
        type = .number
        if (indexPath.row == 17 ) {type = .comma}
        cell.btn.setButton(index: indexPath.row, value: value , displayValue: data[indexPath.row], type: type)
        cell.btn = setButton(btnOld : cell.btn,backgroundColor: .gray, titleColor: .white, state: .normal, title: data[indexPath.row], cornerRadius: conerR)
        return cell
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 16) {
            return CGSize(width: (CollectionView.frame.width - 24) / 2 + 8, height: (CollectionView.frame.width - 24) / 4 )
        }
        return CGSize(width: (CollectionView.frame.width - 24) / 4, height: (CollectionView.frame.width - 24) / 4 )
    }
}
extension ViewController: YourCellDelegate {
    
    func didPressButton(_ btn : Button) {
        if(isFirst == true){
            //print(numberAfterComma)
            factor = 10
            if (didClickedComma == true){
                numberAfterComma *= 10;
                factor = 1
            }
            if (btn.type == .number){
                numberFirst = numberFirst * factor + Float(btn.value) / numberAfterComma
                lblResult.text = convertFloatToString0(number: numberFirst , numberAfterDecimalPoint: Int(numberAfterComma))
                return
            }
            if(btn.type == .comma) {
                if(didClickedComma){
                    numberAfterComma /= 10
                }
                didClickedComma = true
                return
            }
            if(btn.type == .delete ){
                numberFirst = 0
                isFirst = true ;didClickedComma = false; numberAfterComma = 1 ;
                lblResult.text = "0"
                return
            }
            isFirst = false ;didClickedComma = false; numberAfterComma = 1
            switch btn.type {
            case .sign:
                numberFirst = numberFirst * -1
                lblResult.text = convertFloatToString(number: numberFirst)
            case .percent :
                numberFirst /= 100
                lblResult.text = convertFloatToString(number: numberFirst)
            default:
                operationPresent = btn.type
            }
        }
        else {
            factor = 10
            if (didClickedComma == true){
                numberAfterComma *= 10;
                factor = 1
            }
            if (btn.type == .number){
                numberSecond = numberSecond * factor + Float(btn.value) / numberAfterComma
                lblResult.text = convertFloatToString0(number: numberSecond , numberAfterDecimalPoint: Int(numberAfterComma))
                return
            }
            if(btn.type == .comma) {
                if(didClickedComma){
                    numberAfterComma /= 10
                }
                didClickedComma = true
                return
            }
            if(btn.type == .delete ){
                numberFirst = 0
                numberSecond = 0
                isFirst = true ;didClickedComma = false; numberAfterComma = 1
                lblResult.text = "0"
                return
            }
            isFirst = false ;didClickedComma = false; numberAfterComma = 1
            switch btn.type {
            case .sign:
                numberSecond = numberSecond * -1
                lblResult.text = convertFloatToString(number: numberSecond)
                return
            case .percent :
                numberSecond /= 100
                lblResult.text = convertFloatToString(number: numberSecond)
                return
            default:
                (numberFirst , numberSecond , numberResult) = calculator(numberFirst: numberFirst, numberSecond: numberSecond, operation: operationPresent)
                operationPresent = btn.type
            }
            let numberResult = round(numberResult * 1000000) / 1000000
            lblResult.text = convertFloatToString(number: numberResult)
        }
    }
    
}
func convertFloatToString0(number : Float , numberAfterDecimalPoint: Int ) -> String{
    let str = String(numberAfterDecimalPoint)
    var ind = str.endIndex
    var numberAfterDecimalPointR = -1 ;
    while(ind != str.startIndex){
        ind = str.index(before: ind)
        numberAfterDecimalPointR += 1;
    }
    return String(format:"%." + numberAfterDecimalPointR.description + "f", number)
}
func convertFloatToString(number : Float) -> String {
    let str = String(format: "%.7f", number)
    var numberAfterDecimalPoint : Int = 7
    var index = str.index(before: str.endIndex)
    while(str[index] == "0") {
        index = str.index(before: index)
        print(str[index])
        numberAfterDecimalPoint -= 1
    }
    return String(format:"%." + numberAfterDecimalPoint.description + "f", number)
}
func calculator(numberFirst : Float , numberSecond : Float , operation : Type) -> (Float , Float , Float){
    var numberResult : Float = 0
    let numberFirst = round(numberFirst * 100000) / 100000
    let numberSecond = round(numberSecond * 100000) / 100000
    if (operation == .div ) {
        if (numberSecond == 0 ) {return (numberFirst,numberSecond,numberFirst)}
        numberResult = numberFirst / numberSecond
        return (numberResult,0,numberResult)}
    if (operation == .mul ) {
        numberResult = numberFirst * numberSecond
        return (numberResult,0,numberResult)}
    if (operation == .sub ) {
        numberResult = numberFirst - numberSecond
        return (numberResult,0,numberResult)}
    if (operation == .add ) {
        numberResult = numberFirst + numberSecond
        return (numberResult,0,numberResult)}
    return (numberFirst,numberSecond,numberFirst)
}
func setButton(btnOld : Button,backgroundColor : UIColor , titleColor : UIColor , state : UIControl.State , title :String , cornerRadius : Float) -> Button{
    let btn = btnOld
    btn.backgroundColor = backgroundColor
    btn.setTitleColor(titleColor, for: state)
    btn.setTitle(title, for: state)
    btn.layer.cornerRadius = CGFloat(cornerRadius)
    return btn
}


