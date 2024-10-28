import { UserComp } from '../components/UserComp'
import { UserInfo } from '../entity/UserInfo'
import { Request } from '../util/RequestUtil'
import { http } from '@kit.NetworkKit'

@Entry
@Component
struct Index {
  @State userList:UserInfo[] = []
  aboutToAppear(): void {
    Request.request('/users',http.RequestMethod.GET,{'_page':'1','_limit':'10'} as Record<string,string>).then(res=>{
      console.log('hmlog-->res.result'+res.result)
      this.userList = JSON.parse(res.result.toString()) as UserInfo[]
    })
  }
  build() {
    List({space:20}){
      ForEach(this.userList,(user:UserInfo,index)=>{
        ListItem(){
          UserComp({user})
        }
        .width('100%')
        .align(Alignment.Start)    // 子组件的对齐方式
      })
    }
    .backgroundColor('#f3f5f7')
    .width('100%')
    .height('100%')

    
  }
}