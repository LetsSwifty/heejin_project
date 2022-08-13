import UIKit
import RxSwift
import RxCocoa

//MARK - Observavle

let observable = Observable.just(1)
let observable2 = Observable.of(1,2,3)
let observable3 = Observable.of([1,2,3])
let observable4 = Observable.from([1,2,3])

observable4.subscribe { event in
    print(event)
    if let element = event.element {
        print(element)
    }
}

observable3.subscribe { event in
    print(event)
    if let element = event.element {
        print(element)
    }
}

observable4.subscribe(onNext: {element in
    print(element)
})



//MARK - Observable create & dispose

let subscription4 = observable4.subscribe(onNext: {element in
    print(element)
})
subscription4.dispose()


let disposeBag = DisposeBag()

Observable.of("A","B","C")
    .subscribe{
        print($0)
}.disposed(by: disposeBag)

//PublishRelay
Observable<String>.create { observer in
    observer.onNext("A")
    observer.onCompleted()
    observer.onNext("?") // not be called

    return Disposables.create()
    
}.subscribe( onNext: { print($0) } , onError: { print($0)}, onCompleted: {print("Compelted")}, onDisposed: {print("Disposed")})
.disposed(by: disposeBag)



//MARK - subject
let subject = PublishSubject<String>()

subject.onNext("ISSUE 1") // not working. 초기값이 없어서!

subject.subscribe { event in
    print(event)
}
subject.onNext("ISSUE 2")  // working
subject.onNext("working too")

//subject.dispose()
//subject.onNext("ignored")

subject.onCompleted() // dispose 이후에는 completed도 실행되지 않음
//subject.onNext("ignored")



// BehaviorSubject 는subsribe 이후 가장 최근 값을 리턴한다.
let subject2 = BehaviorSubject(value: "initial value")

subject2.onNext("last issue")

subject2.subscribe { event in
    print(event)
}

subject2.onNext("issue 1")


// replaySubject 는 버퍼 사이즈만큼 만 subscribe 한다. subscribe 가 되기 전 가장 최근 두 값을 리턴한다
let subject3 = ReplaySubject<String>.create(bufferSize: 2)

subject3.onNext("relay issue 1")
subject3.onNext("relay issue 2")
subject3.onNext("relay issue 3")

subject3.subscribe {
    print($0)
}

subject3.onNext("relay issue 4")
subject3.onNext("relay issue 5")
subject3.onNext("relay issue 6")

print("_________")
subject3.subscribe {
    print($0)
}

//variables - deprecated. 값이 바뀔때마다 subscribe 된다
let variable = Variable("initial Value")
variable.value = "hello world"

variable.asObservable()
    .subscribe{
        print($0)
}

let variable2 = Variable([String]())
variable2.value.append("item 1")
variable2.asObservable()
    .subscribe{
        print($0)
}
variable2.value.append("item 2")


//dehaviorRellay - variable의 대체품. rxcocoa 프레임워크임
let relay = BehaviorRelay(value: "initial value")
relay.asObservable()
    .subscribe{
        print($0)
}
// relay.value = "Hello world" // 불가!
relay.accept("Hello world!")


let relay2 = BehaviorRelay(value: [String]())
relay2.accept(["tiem 1"])
relay2.asObservable()
    .subscribe{
        print($0)
}


let relay3 = BehaviorRelay(value: ["item 1"])
//relay3.accept(["item 2"]) // item2가 append되는게 아니라, item1이 2로 바뀜
relay3.accept(relay3.value + ["item 2"])

var value = relay3.value
value.append("item 3")
value.append("item 4")
relay3.accept(value) // 위 한줄 방식과 동일

relay3.asObservable()
    .subscribe{
        print($0)
}


//ignoreElements()
let strikes = PublishSubject<String>()
strikes
.ignoreElements()
.subscribe{_ in
    print("subscribtion is called")
}.disposed(by: disposeBag)

strikes.onNext("A")
strikes.onNext("B")
strikes.onNext("C")
strikes.onCompleted() // 이때 subscribtion 되어서 위엣게 출력된다. 나머지는 onNext 안됨


//elementAt()
let strikes2 = PublishSubject<String>()
strikes2.elementAt(2)
.subscribe(onNext: { item in
    print("you are out \(item)")
}).disposed(by: disposeBag)

strikes2.onNext("X1")
strikes2.onNext("X2") // 여기까지만 했을때는 subscribe 되지 않음
strikes2.onNext("X3") // 이떄 subscribe 되어서 출력됨


//filter
Observable.of(1,2,3,4,5,6,7)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


//skip
Observable.of("A","B","C","D","E")
    .skip(3)
    .subscribe(onNext: {
        print($0)  //3개 건너뛰고 D, E 만 출력된다
    }).disposed(by: disposeBag)


//skipWhile
Observable.of(2,2,3,3,4,4)
    .skipWhile { $0 % 2 == 0 } // 이조건을 만족하지 않은 3 부터 쭈우욱 출력
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


//skipUntil
let subject10 = PublishSubject<Int>()
let subject20 = PublishSubject<Int>()
let db = DisposeBag()

subject10
  .skipUntil(subject20)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: db)

subject10.onNext(1)
subject10.onNext(2)
subject20.onNext(10)
subject10.onNext(30)


//take
Observable.of(10,20,30,40,50,60)
    .take(3)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: db)


//takeWhile
Observable.of(2,4,6,7,8,10)
    .takeWhile {
        return $0 % 2 == 0
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: db)
//2,4,6 출력했는데 7은 만족못해서 그 이후인 8, 10 은 출력되지 않는다.


//takeUntil
let subject5 = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject5.takeUntil(trigger)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: db)

subject5.onNext("1")
subject5.onNext("2")
trigger.onNext("X")
subject5.onNext("3") // 1,2만 출력


//toArray
Observable.of(1,2,3,4,5)
    .toArray()
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


//map
Observable.of(1,2,3,4,5)
    .map {
        return   $0 * 2
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


//flatMap
struct Student {
    var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 95))

let student = PublishSubject<Student>()

student.asObservable()
    .flatMap { $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

student.onNext(john)
john.score.accept(100)
// 값이 바뀌면 subscribe되어서 75, 100 이 출력된다

student.onNext(mary)
// 75, 100, 95 출력
john.score.accept(80)
// 75, 100, 95, 80 출력

mary.score.accept(43)
// 75, 100, 95, 80, 43 출력. flatMap을 통해 하나의 sequence로 만들었기 떄문에 계속 존의 score를 옵저브 한다.


//flatMapLatest
print("||||||||||||||||||||")
let student2 = PublishSubject<Student>()
let john2 = Student(score: BehaviorRelay(value: 75))
let mary2 = Student(score: BehaviorRelay(value: 95))

student2.asObservable()
    .flatMapLatest { $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

student2.onNext(john2)
john2.score.accept(200)

student2.onNext(mary2)
john2.score.accept(300) // mary를 한번 accept했기 때문에 75, 200, 95 만 출력
mary.score.accept(300) // 75, 200, 95, 300 출력


//startsWith
let numbers = Observable.of(2,3,4)
let observable5 = numbers.startWith(1)
observable5.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
// sequence 처음에 값을 넣어서 반환. 1,2,3,4,5 출력된다


//concat
let first = Observable.of(1,2,3)
let second = Observable.of(4,5,6)
let observable6 = Observable.concat([first, second])
observable6.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag) // 1,2,3,4,5,6 출력


//Merge - 들어온 순서대로 하나의 스트림을 만들어낸다
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let source = Observable.of(left.asObservable(), right.asObservable())
let observable7 = source.merge()
observable7.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

left.onNext(5)
left.onNext(3)
right.onNext(2)
right.onNext(1)
left.onNext(99) // 5,3,2,1,99 출력


//combineLatest
let left2 = PublishSubject<Int>()
let right2 = PublishSubject<Int>()

let observable8 = Observable.combineLatest(left2, right2, resultSelector: { lastLaft, lastRight in
    "\(lastLaft) \(lastRight)"
})

let disposable9 = observable8.subscribe(onNext: {value in
    print(value)
})

left2.onNext(5)
right2.onNext(22)
left2.onNext(3)
right2.onNext(1)
right2.onNext(14)
//5 22
//3 22
//3 1
//3 14


//withLatestFrom
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observable9 = button.withLatestFrom(textField)
let disposable10 = observable9.subscribe(onNext: {
    print($0)
})

textField.onNext("Swi")
textField.onNext("Swif")
textField.onNext("Swift")

button.onNext(())
button.onNext(()) // 항상 가장 마지막인 swift 를 출력한다.


//reduce
let source2 = Observable.of(1,2,3)
source2.reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
// 6 출력

source2.reduce(0, accumulator: { summary, newValue in
    return summary + newValue
}).subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
// 마찬가지로 6 출력


//scan
let source3 = Observable.of(1,2,3,4,5,6)
source3.scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
// 1, 3, 6, 10, 15, 21 출력. reduce 와 비슷하긴 한데 과정을 찍어낼 수 있음
