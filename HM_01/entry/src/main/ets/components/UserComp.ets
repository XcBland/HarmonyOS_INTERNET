import { UserInfo } from "../entity/UserInfo"

@Component
export struct UserComp {
  @Prop user:UserInfo
  build() {
    Column({space:20}){
      Text('员工编号:'+this.user.id + '').fontSize(20)
      Text('员工真实姓名:'+this.user.name)
      Text('员工职场姓名:'+this.user.username)
      Text('员工邮箱:'+this.user.email)
      Text('员工手机号码:'+this.user.phone)
      Text('员工博客地址:'+this.user.website)
      Column({space:20}){
        Text('Address:')
        Text('公司地址-城市:'+this.user.address.city)
        Text('公司地址-街道:'+this.user.address.street)
        Text('公司地址-门牌号:'+this.user.address.suite)
        Text('公司地址-邮编:'+this.user.address.zipcode)
        Text('公司地址-经纬度:'+this.user.address.geo.lat + ','+ this.user.address.geo.lng)
      }
      .width('100%')
      Column({space:20}){
        Text('Company:')
        Text('公司名称:'+this.user.company.name)
        Text('公司简称:'+this.user.company.catchPhrase)
        Text('公司描述:'+this.user.company.bs)
      }
      .width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .margin({top:20})
  }
}