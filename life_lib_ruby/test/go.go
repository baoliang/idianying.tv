package main
 
import "fmt"
import "time"
import "math/rand"
import "runtime"
 
var total_tickets int32 = 10;
list := {"http://www.baidu.com/" "http://www.qiyi.com/" "http://www.idianying.tv/"};
func sell_tickets(i int){
    for{
        if total_tickets > 0 { //如果有票就卖
            time.Sleep( time.Duration(rand.Intn(5)) * time.Millisecond)
            total_tickets-- //卖一张票
            fmt.Println("id:", i, "  ticket:", total_tickets)
        }else{
            break
        }
    }
}
 
func main() {
    runtime.GOMAXPROCS(1) //我的电脑是4核处理器，所以我设置了4
 
 
    for i := 0; i < 5; i++ { //并发5个goroutine来卖票
         go sell_tickets(i)
    }
    //等待线程执行完
    var input string
    fmt.Scanln(&input)
    fmt.Println(total_tickets, "done") //退出时打印还有多少票
}